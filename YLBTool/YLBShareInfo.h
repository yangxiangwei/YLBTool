//
//  YLBShareInfo.h
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/13.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLBInfo.h"
@interface YLBShareInfo : YLBInfo

/**
 *  分享标题
 */
@property(nonatomic,copy)NSString *sTitle;

/**
 *  分享内容
 */
@property(nonatomic,copy)NSString *sContent;

/**
 *  分享链接
 */
@property(nonatomic,copy)NSString *sUrl;

/**
 *  分享图片
 */
@property(nonatomic,copy)NSString *sImageUrl;

/**
 *  是否是需要解析sUrl来设置分享的内容
 */
@property(nonatomic,assign)BOOL sShareFromHtml;

@end
