//
//  NSArray+YLBUtil.m
//  WhiteDragon
//
//  Created by rxj on 16/7/1.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import "NSArray+YLBUtil.h"
#import "YLBLogManager.h"
@implementation NSArray (YLBUtil)

- (id)objectAtIndexCheck:(NSUInteger)index {
    if (index < self.count) {
        return self[index];
    }else{
        //添加错误日志
         
        [[YLBLogManager sharedInstance] efAddLogWithTitle:@"IndexOutOfBoundsException" detail:[self description]];
    }
    return nil;
}


@end
