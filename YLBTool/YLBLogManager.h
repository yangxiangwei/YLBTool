//
//  YLBLogManager.h
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/7.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLBLogInfo.h"

@interface YLBLogManager : NSObject
 
+(void)destoryInstance;

+(instancetype)sharedInstance;
 
/**
 *  添加日志
 *
 *  @param log 日志
 */
-(void)efAddLog:(YLBLogInfo *)log;
+(void)efAddLog:(YLBLogInfo *)log;
/**
 *  添加日志
 *
 *  @param title 标题
 */
-(void)efAddLogWithTitle:(NSString *)title;
+(void)efAddLogWithTitle:(NSString *)title;
/**
 *  添加日志
 *
 *  @param title  标题
 *  @param detail 日志内容
 */
-(void)efAddLogWithTitle:(NSString *)title detail:(NSString *)detail;
+(void)efAddLogWithTitle:(NSString *)title detail:(NSString *)detail;
/**
 *  获取日志数组(已过滤重复)
 *
 *  @return 日志数组
 */
-(NSArray *)efGetLogArray;
+(NSArray *)efGetLogArray;

/**
 *  发送日志(可以抽象为接口,发送其他数据类型)
 */
-(void)efMailLog:(id)mailObject;
+(void)efMailLog:(id)mailObject;


/**
 *  测试日志（添加，归档，邮件）
 */
-(void)efTestAddLog;
+(void)efTestAddLog;

/**
 *  设置邮件参数
 *
 *  @param fromMail      发件人地址
 *  @param toMail        收件人地址
 *  @param loginName     发件人邮件登录名称
 *  @param loginPassword 发件人邮件登录名称
 */
-(void)efSetSMTPMessageFromMail:(NSString *)fromMail
                 toMail:(NSString *)toMail
              loginName:(NSString *)loginName
          loginPassword:(NSString *)loginPassword;

+(void)efSetSMTPMessageFromMail:(NSString *)fromMail
                 toMail:(NSString *)toMail
              loginName:(NSString *)loginName
          loginPassword:(NSString *)loginPassword;

@end

