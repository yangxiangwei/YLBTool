//
//  UIColor+XJ.h
//  WhiteDragon
//
//  Created by rxj on 16/1/17.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XJ)

+ (UIColor *)XJColorWithstartColor:(UIColor *)startColor
                          endColor:(UIColor *)endColor
                          fraction:(CGFloat)fraction;

/**
 *  获取UIColor(已经除了255.0)
 *
 *  @param red   255  红
 *  @param green 255  绿
 *  @param blue  255  蓝
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithR:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/**
 *  获取UIColor(已经除了255.0)
 *
 *  @param red   255  红
 *  @param green 255  绿
 *  @param blue  255  蓝
 *  @param alpha 1.0  透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithR:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**
 *  通过16进制获取颜色
 *
 *  @param colorString (0x123443 ,#232322 ,232322)
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)colorString;

/**
 *  背景色
 *
 *  @return UIColor
 */
+ (UIColor *)bgColor;

/**
 *  黑色字体
 *
 *  @return UIColor
 */
+ (UIColor *)titleBlackColor;

/**
 *  灰色字体
 *
 *  @return UIColor
 */
+ (UIColor *)titleGrayColor;

/**
 *  日期的灰色
 *
 *  @return UIColor
 */
+ (UIColor *)titleGrayColorForDate;

/**
 *  label橘色的背景
 *
 *  @return UIColor
 */
+ (UIColor *)bgOrangeColorForLabel;

/**
 *  label红色的背景
 *
 *  @return UIColor
 */
+ (UIColor *)bgRedColorForLabel;

/**
 *  label蓝色的背景
 *
 *  @return UIColor
 */
+ (UIColor *)bgBlueColorForLabel;

/**
 *  button蓝色背景
 *
 *  @return UIColor
 */
+ (UIColor *)bgBlueColorForButton;

/**
 *  分割线的颜色
 *
 *  @return UIColor
 */
+ (UIColor *)separatorColor;

@end
