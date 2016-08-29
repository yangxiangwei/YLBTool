//
//  YLBAchiveManager.h
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/22.
//  Copyright © 2016年 YongLibao. All rights reserved.
//
 
#import <Foundation/Foundation.h>

@interface YLBArchiveManager : NSObject 

+(instancetype)sharedInstance;

/**
 *  归档到Document目录下
 *
 *  @param data 要归档的数据源
 *  @param key  文件名称
 */
-(void)efArchiveObject:(id)data forKey:(NSString *)key;
+(void)efArchiveObject:(id)data forKey:(NSString *)key;

/**
 *  从设备取出数据
 *
 *  @param key 文件名称
 *
 *  @return 数据源
 */
-(id)efUnArcheiveForKey:(NSString *)key;
+(id)efUnArcheiveForKey:(NSString *)key;

@end



//***********************************在此设置归档的Key*************************************//
/**
 *  日志
 */
FOUNDATION_EXPORT NSString *const YLBArchiveLogKey ;

/**
 *  判断用户是否已经设置支付密码( 0 未设置 1 已设置)保存格式为 0_userId 1_userId
 */
FOUNDATION_EXPORT NSString *const YLBArchiveHasSetSinaPayPasswordKey ;

/**
 *  是否要显示安全保障页面
 */
FOUNDATION_EXPORT NSString *const YLBArchiveInsuranceViewKey;
