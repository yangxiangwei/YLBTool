//
//  YLBInfo.m
//  BlueWhale
//
//  Created by 永利宝 on 15/7/24.
//  Copyright (c) 2015年 RXJ. All rights reserved.
//

#import "YLBInfo.h"
#import "YYModel.h"
@implementation YLBInfo

- (id)copyWithZone:(nullable NSZone *)zone{
    YLBInfo *copy = [[[self class] allocWithZone:zone] init];
    
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
    }
    return self;

}

-(id)initWithDataDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
    }
    return self;
}

/**
 *  重载方法
 *
 *  @return 返回数据字典，用于查看数据
 */
-(NSString *)description{ 
    return [self yy_modelDescription];
}

@end
