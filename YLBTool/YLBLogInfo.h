//
//  YLBLogInfo.h
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/7.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

typedef NS_ENUM(NSInteger,LogLevel) {
    /**
     *  错误
     */
    LogLevelError   = 0,
    /**
     *  警告
     */
    LogLevelWarn    = 1
};

typedef NS_ENUM(NSInteger,LogState) {
    /**
     *  未发送
     */
    LogStateUnSend   = 0,
    /**
     *  发送中
     */
    LogStateSending   = 1,
    /**
     *  发送失败
     */
    LogStateSendingFail   = 1,
    /**
     *  已发送
     */
    
    LogStateSended    = 3
};
 
#import "YLBInfo.h"
@interface YLBLogInfo : YLBInfo

/**
 *  标题
 */
@property(nonatomic,copy)NSString *lTitle;

/**
 *  详情
 */
@property(nonatomic,strong)id lDescription;

/**
 *  日志级别（错误，警告）
 */
@property(nonatomic,assign)LogLevel lLevel;

/**
 *  用户信息
 */
@property(nonatomic,copy)NSString *lUserInfo;

/**
 *  设备
 */
@property(nonatomic,copy)NSString *lDeviceInfo;

/**
 *  日志状态
 */
@property(nonatomic,assign)LogState lState; 

/**
 *  软件版本
 */
@property(nonatomic,copy)NSString *lVersion;

/**
 *  时间
 */
@property(nonatomic,strong)NSDate *lDate;

@end
