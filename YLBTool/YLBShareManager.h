//
//  YLBShareManager.h
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/13.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLBShareInfo.h"
#import <UIKit/UIKit.h>
@interface YLBShareManager : NSObject

+(instancetype)sharedInstance;

/**
 *  如果分享内容来自html则需要设置此属性
 */
@property(nonatomic,strong)UIWebView *evWebView;


/**
 *  分享
 *
 *  @param shareInfo 分享内容
 */
-(void)efExecShare:(YLBShareInfo *)shareInfo;
+(void)efExecShare:(YLBShareInfo *)shareInfo;

/**
 *  分享设置
 *
 *  @param appKey          appKey
 *  @param platformInfo    平台appid/appKey
 
 platformInfo:
    @{
 @"SSDKPlatformTypeWechat":@{@"appId":@"wx238b4bd646cbe485",@"appKey":@"ab645e9180ffe34f297b9a1b086d70d6"},
    
     @"SSDKPlatformTypeQQ":@{@"appId":@"1103700273",@"appKey":@"HGG4OJbTOJ6C6fb7"}
    }
 */
-(void)efSetShareWithAppKey:(NSString *)appKey platformInfo:(NSDictionary *)platformInfo;
+(void)efSetShareWithAppKey:(NSString *)appKey platformInfo:(NSDictionary *)platformInfo;

@end
