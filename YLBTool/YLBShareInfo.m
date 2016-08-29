//
//  YLBShareInfo.m
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/13.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import "YLBShareInfo.h"

@implementation YLBShareInfo

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            self.sTitle = dict[@"title"];
            self.sContent= dict[@"content"];
            self.sUrl = dict[@"shareUrl"];
            self.sImageUrl = dict[@"imgUrl"]; 
        }
    }
    return self;
}

@end
