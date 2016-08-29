//
//  YLBMemoryManager.h
//  WhiteDragon
//
//  Created by 杨相伟 on 16/8/17.
//  Copyright © 2016年 YongLibao. All rights reserved.
//
typedef enum {
    ///未登录
    loginStatusNoneLogin = 0,
    ///已经登录
    loginStatusDidLogin
    
} LoginStatus;

#import <Foundation/Foundation.h>

@interface YLBMemoryManager : NSObject

+(nonnull instancetype)sharedInstance;

/**
 *  保存用户ID到内存
 *
 *  @param userId 用户ID
 */
-(void)efSaveUserId:(long)userId;

/**
 *  获取用户ID
 *
 *  @param userId 用户ID
 */
-(long)efGetUserId;

/**
 *  保存服务器地址到内存
 *
 *  @param ip 服务器地址
 */
-(void)efSaveServerIp:(nonnull NSString *)ip;

/**
 *  获取服务器地址
 *
 */
-(nonnull NSString *)efGetServerIp;

/**
 *  获取用户登录状态
 *
 *  @return 登录状态
 */
-(LoginStatus)efGetUserLoginStatus;

/**
 *  保存对象到内存
 *
 *  @param object 需要保存的对象
 *  @param key    key
 */
-(void)efSaveObject:(nonnull id)object forKey:(nonnull NSString *)key;

/**
 *  从内存中获取对象
 *
 *  @param key key
 *
 *  @return 内存对象
 */
-(nonnull id)efGetObjectForKey:(nonnull NSString *)key;

@end
