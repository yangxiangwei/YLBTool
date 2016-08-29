//
//  UIImage+YLBImage.h
//  WhiteDragon
//
//  Created by 杨相伟 on 16/8/24.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YLBImage)

/**
 *  等比例缩放图片
 *
 *  @param scale 缩放比例
 *
 *  @return UIImage
 */
- (UIImage *)scaleImageToScale:(CGFloat)scale;

@end
