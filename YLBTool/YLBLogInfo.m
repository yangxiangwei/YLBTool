//
//  YLBLogInfo.m
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/7.
//  Copyright © 2016年 YongLibao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "YLBLogInfo.h"
#import "Tool.h"
#import "YLBMemoryManager.h"
@implementation YLBLogInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
      
        self.lUserInfo = [NSString stringWithFormat:@"userId=%@",[[NSNumber numberWithDouble:[[YLBMemoryManager sharedInstance] efGetUserId]] stringValue]];
        
        self.lDeviceInfo = [NSString stringWithFormat:@"%@ -> memory（canUse:%.2fM,hasUse:%.2fM）",[Tool getDeviceInfo],[Tool getAvailableMemory],[Tool getUsedMemory]];
        
        if (self.lDescription == nil || ((NSString *)self.lDescription).length == 0) {
            self.lDescription = [NSThread callStackSymbols]; 
        }
        
        self.lVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        self.lDate = [NSDate date]; 
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.lTitle forKey:NSStringFromSelector(@selector(lTitle))];
    [aCoder encodeObject:self.lDescription forKey:NSStringFromSelector(@selector(lDescription))];
    [aCoder encodeObject:self.lDeviceInfo forKey:NSStringFromSelector(@selector(lDeviceInfo))];
    [aCoder encodeObject:self.lUserInfo forKey:NSStringFromSelector(@selector(lUserInfo))];
    [aCoder encodeObject:self.lDate forKey:NSStringFromSelector(@selector(lDate))];
    [aCoder encodeInt:self.lLevel forKey:NSStringFromSelector(@selector(lLevel))];
    [aCoder encodeObject:self.lVersion forKey:NSStringFromSelector(@selector(lVersion))];
    [aCoder encodeInt:self.lState forKey:NSStringFromSelector(@selector(lState))];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) { 
        _lTitle = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(lTitle))];
        _lDescription = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(lDescription))];
        _lDeviceInfo = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(lDeviceInfo))];
        _lUserInfo = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(lUserInfo))];
        _lDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(lDate))];
        _lLevel = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(lLevel))];
        _lState = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(lState))];
        _lVersion = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(lVersion))];
    }
    
    return self;
}

@end
