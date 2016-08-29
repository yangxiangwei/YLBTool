//
//  YLBInfo.h
//  BlueWhale
//
//  Created by 永利宝 on 15/7/24.
//  Copyright (c) 2015年 RXJ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YLBInfo : NSObject<NSCoding,NSCopying>

/**
 *  从网络数据初始化对象
 *
 *  @param dict 数据
 *
 *  @return 对象
 */
- (id)initWithDict:(NSDictionary *)dict;

/**
 *  从本地数据(YLBDataManager)初始化对象
 *
 *  @param dict 数据
 *
 *  @return 对象
 */
- (id)initWithDataDict:(NSDictionary *)dict;

@end
