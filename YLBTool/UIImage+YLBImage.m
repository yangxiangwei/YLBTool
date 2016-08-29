//
//  UIImage+YLBImage.m
//  WhiteDragon
//
//  Created by 杨相伟 on 16/8/24.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import "UIImage+YLBImage.h"

@implementation UIImage (YLBImage)

- (UIImage *)scaleImageToScale:(CGFloat)scale{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scale, self.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
