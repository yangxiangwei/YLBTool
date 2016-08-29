//
//  ShareSheet.h
//  shareSdk
//
//  Created by rxj on 15/11/23.
//  Copyright © 2015年 rxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareSheet : UIView

@property(nonatomic, strong) UIImage *bgImg;
@property(nonatomic, strong) NSArray *shareContents;


@property(nonatomic, copy) void (^shareClick) (NSInteger index);

- (void)show;

@end
