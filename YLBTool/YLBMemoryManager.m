//
//  YLBMemoryManager.m
//  WhiteDragon
//
//  Created by 杨相伟 on 16/8/17.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import "YLBMemoryManager.h"

long memoryUserId = 0;
NSString *memoryIP = @"";
NSMutableDictionary *dic = nil;

@implementation YLBMemoryManager
static YLBMemoryManager *memoryManager = nil;

+(nonnull instancetype)sharedInstance{
    static dispatch_once_t onece;
    dispatch_once(&onece, ^{
        memoryManager = [[self alloc] init];
        dic = [NSMutableDictionary dictionary];
    });
    return memoryManager;
}

-(void)efSaveUserId:(long)userId{
    memoryUserId = userId;
}

-(void)efSaveServerIp:(nonnull NSString *)ip{
    memoryIP = ip;
}

-(nonnull NSString *)efGetServerIp{
    return memoryIP;
}

-(long)efGetUserId{
    return memoryUserId;
}

-(LoginStatus)efGetUserLoginStatus{
    return memoryUserId >0 ? loginStatusDidLogin : loginStatusNoneLogin;
}

-(void)efSaveObject:(nonnull id)object forKey:(nonnull NSString *)key{
    [dic setObject:object forKey:key];
}

-(nonnull id)efGetObjectForKey:(nonnull NSString *)key{
    return [dic objectForKey:key];
}

@end
