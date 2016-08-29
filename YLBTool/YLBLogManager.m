//
//  YLBLogManager.m
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/7.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import "YLBLogManager.h"
#import "YLBArchiveManager.h"
#import "SKPSMTPMessage.h"
#import "YYModel.h"
@interface YLBLogManager ()<SKPSMTPMessageDelegate>{
    SKPSMTPMessage *skMessage;
}

@end

@implementation YLBLogManager

NSMutableArray *logArray;
static YLBLogManager *logManager = nil;

-(instancetype)init{
    self = [super init];
    if (self) {
        logArray = [[NSMutableArray alloc] init];
        
        [self efSetSMTPMessageFromMail:@"abcdefghi_521@163.com"
                                toMail:@"abcdefghi_521@163.com"
                             loginName:@"abcdefghi_521@163.com"
                         loginPassword:@"abc521"];
    }
    return self;
}

+(void)destoryInstance{
    if (logManager) {
        logManager = nil;
    }
}

+(instancetype)sharedInstance{
    static dispatch_once_t onece;
    dispatch_once(&onece, ^{
        logManager = [[self alloc] init];
    });
    return logManager;
}

-(void)efAddLog:(YLBLogInfo *)log{
    if (log) {
        [logArray addObject:log];
    }
}

+(void)efAddLog:(YLBLogInfo *)log{
    [[YLBLogManager sharedInstance] efAddLog:log];
}


-(void)efAddLogWithTitle:(NSString *)title{
    [self efAddLogWithTitle:title detail:@""];
}

+(void)efAddLogWithTitle:(NSString *)title{
    [[YLBLogManager sharedInstance] efAddLogWithTitle:title detail:@""];
}

-(void)efAddLogWithTitle:(NSString *)title detail:(NSString *)detail{
    YLBLogInfo *log = [[YLBLogInfo alloc] init];
    log.lTitle = title;
    if (detail.length >0) {
        log.lDescription = detail;
    } 

    [self efAddLog:log];
}

+(void)efAddLogWithTitle:(NSString *)title detail:(NSString *)detail{
    [[YLBLogManager sharedInstance] efAddLogWithTitle:title detail:detail];
}


-(NSArray *)efGetLogArray{
    return [self filterDuplicate:[self getUnSendLog]];
}
+(NSArray *)efGetLogArray{
    return [[YLBLogManager sharedInstance] efGetLogArray];
}
 

-(NSArray *)getUnSendLog{
    NSMutableArray *resultArray = [NSMutableArray new];
    [logArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((YLBLogInfo *)obj).lState < LogStateSended) {
            [resultArray addObject:obj];
        }
    }];

    return resultArray;
}

-(NSArray *)filterDuplicate:(NSArray *)array{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dic setValue:obj forKey:((YLBLogInfo *)obj).lDescription];
    }];
    
    return [dic allValues];
}


-(void)efMailLog:(id)mailObject{
    NSMutableArray *mailLogArray = [NSMutableArray arrayWithArray:mailObject];
    if (mailLogArray.count >0) {
        //归档数据放到内存，用于更新发送后的状态
        [logArray addObjectsFromArray:mailLogArray];
        
        //发邮件
        SKPSMTPMessage *smtpMsg = skMessage;
        smtpMsg.delegate = self;
        //发送的内容
        smtpMsg.sendObject = mailLogArray;
        //主题
        smtpMsg.subject = [NSString stringWithFormat:@"重要内容:（%ld）",(unsigned long)mailLogArray.count];
        
        NSMutableArray *mailedArray = [[NSMutableArray alloc] initWithCapacity:mailLogArray.count];
        [mailLogArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YLBLogInfo *log = obj;
            if (log) {
                [mailedArray addObject:[log yy_modelDescription]];
            }
        }];
        
        NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain; charset=UTF-8",kSKPSMTPPartContentTypeKey,
                                   [mailedArray debugDescription],kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
        
        smtpMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
        @try {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if ([smtpMsg send]) {
                    [mailLogArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        //更新日志的发送状态为发送中(只是中间状态)
                        if (((YLBLogInfo *)obj).lState == LogStateUnSend) {
                            ((YLBLogInfo *)obj).lState = LogStateSending;
                        }
                    }];
                }
            });
        } @catch (NSException *exception) {
            
        }
    } 
}

+(void)efMailLog:(id)mailObject{
    [[YLBLogManager sharedInstance] efMailLog:mailObject];
}

#pragma mark - SKPSMTPMessageDelegate
-(void)messageSent:(SKPSMTPMessage *)message{
    NSLog(@"邮件发送成功");
    NSArray *tmpArray = message.sendObject;
    if (tmpArray) {
        [logArray removeObjectsInArray:tmpArray];
        
        [[YLBArchiveManager sharedInstance] efArchiveObject:logArray forKey:YLBArchiveLogKey];
    }
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    NSLog(@"邮件发送失败");
    @try {
        NSArray *tmpArray = message.sendObject;
       
        [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
             //更新日志的发送状态为发送失败
            if (((YLBLogInfo *)obj).lState == LogStateSending) {
                ((YLBLogInfo *)obj).lState = LogStateSendingFail;
            }
            
            //日志发送失败,更新内存数组
            [logArray enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([((YLBLogInfo *)obj).lDescription isEqualToString:((YLBLogInfo *)obj).lDescription]) {
                    [logArray replaceObjectAtIndex:idx withObject:obj];
                }
            }];
        }];
        
        [[YLBArchiveManager sharedInstance] efArchiveObject:logArray forKey:YLBArchiveLogKey];
    } @catch (NSException *exception) {
        [[YLBLogManager sharedInstance] efAddLogWithTitle:exception.reason];
    }
}

-(void)efTestAddLog{
    @try {
        [[YLBLogManager sharedInstance] efAddLogWithTitle:@"test"];
        id logArray = [[YLBLogManager sharedInstance] efGetLogArray];
        [[YLBArchiveManager sharedInstance] efArchiveObject:logArray forKey:YLBArchiveLogKey];
        NSArray *mailObject = [[YLBArchiveManager sharedInstance] efUnArcheiveForKey:YLBArchiveLogKey];
        if (mailObject.count >0) {
            [[YLBLogManager sharedInstance] efMailLog:mailObject];
        }
    } @catch (NSException *exception) {
        
    }
}

+(void)efTestAddLog{
    [[YLBLogManager sharedInstance] efTestAddLog];
}

-(void)efSetSMTPMessageFromMail:(NSString *)fromMail
                 toMail:(NSString *)toMail
              loginName:(NSString *)loginName
          loginPassword:(NSString *)loginPassword{
 
    SKPSMTPMessage *smtpMsg = [[SKPSMTPMessage alloc] init];
    smtpMsg.fromEmail = fromMail;
    smtpMsg.toEmail = toMail;
    smtpMsg.relayHost = @"smtp.163.com";
    smtpMsg.requiresAuth = YES;
    if (smtpMsg.requiresAuth) {
        smtpMsg.login = loginName;
        smtpMsg.pass = loginPassword;
    }
    
    smtpMsg.wantsSecure = YES;
    
    //设置为全局属性
    skMessage = smtpMsg;
}

+(void)efSetSMTPMessageFromMail:(NSString *)fromMail
                 toMail:(NSString *)toMail
              loginName:(NSString *)loginName
          loginPassword:(NSString *)loginPassword{
    
    [[YLBLogManager sharedInstance] efSetSMTPMessageFromMail:fromMail
                                              toMail:toMail
                                           loginName:loginName
                                       loginPassword:loginPassword];
}

@end





