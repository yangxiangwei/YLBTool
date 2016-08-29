//
//  YLBAchiveManager.m
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/22.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import "YLBArchiveManager.h"

/**
 *  归档目录
 */
NSString *const archivepath = @"_achive_";



//***********************************在此设置归档的Key*************************************//

NSString *const YLBArchiveLogKey                        = @"YLBArchiveLogKey";
NSString *const YLBArchiveHasSetSinaPayPasswordKey      = @"YLBArchiveHasSetSinaPayPasswordKey";
NSString *const YLBArchiveInsuranceViewKey              = @"YLBArchiveInsuranceViewKey";

@implementation YLBArchiveManager

static YLBArchiveManager *achiveManager = nil;

+(instancetype)sharedInstance{
    static dispatch_once_t onece;
    dispatch_once(&onece, ^{
        achiveManager = [[self alloc] init];
        BOOL isDirectory = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:[achiveManager getArchivePath] isDirectory:&isDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[achiveManager getArchivePath] withIntermediateDirectories:NO attributes:nil error:nil];
        }
    });
    return achiveManager;
}

-(void)efArchiveObject:(id)data forKey:(NSString *)key{
    if ([NSKeyedArchiver archiveRootObject:data toFile:[self getPathWithKey:key]]) {
        NSLog(@"归档成功");
    }else{
        NSLog(@"归档失败");
    }
}

+(void)efArchiveObject:(id)data forKey:(NSString *)key{
    [[YLBArchiveManager sharedInstance] efArchiveObject:data forKey:key];
}

-(id)efUnArcheiveForKey:(NSString *)key{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getPathWithKey:key]];
}

+(id)efUnArcheiveForKey:(NSString *)key{
    return [[YLBArchiveManager sharedInstance] efUnArcheiveForKey:key];
}


-(NSString *)getPathWithKey:(NSString *)key{
    NSString *path = [self getArchivePath];
    path = [path stringByAppendingPathComponent:key];
    return path;
}

-(NSString *)getArchivePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                    NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
 
    NSString *path = [documentsPath stringByAppendingPathComponent:archivepath];
    
    return path;
}

@end
