//
//  UIColor+XJ.m
//  WhiteDragon
//
//  Created by rxj on 16/1/17.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import "UIColor+XJ.h"

@implementation UIColor (XJ)

+ (UIColor *)XJColorWithstartColor:(UIColor *)startColor endColor:(UIColor *)endColor fraction:(CGFloat)fraction {
    CGFloat startR = 0;
    CGFloat startG = 0;
    CGFloat startB = 0;
    CGFloat startA = 0;
    CGFloat endR = 0;
    CGFloat endG = 0;
    CGFloat endB = 0;
    CGFloat endA = 0;
    [startColor getRed:&startR green:&startG blue:&startB alpha:&startA];
    [endColor getRed:&endR green:&endG blue:&endB alpha:&endA];
    CGFloat resultA = startA + (endA - startA) * fraction;
    CGFloat resultR = startR + (endR - startR) * fraction;
    CGFloat resultG = startG + (endG - startG) * fraction;
    CGFloat resultB = startB + (endB - startB) * fraction;
    return [UIColor colorWithRed:resultR green:resultG blue:resultB alpha:resultA];

}

+ (UIColor *)colorWithHexString:(NSString *)colorString{
    NSString *cString = [[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *)colorWithR:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    return [self colorWithR:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)colorWithR:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:(red)/255.0 green:(green)/255.0 blue:(blue)/255.0 alpha:alpha];
}

+ (UIColor *)bgColor
{
    return [self colorWithHexString:@"#f5f4f9"];
}

+ (UIColor *)titleBlackColor
{
    return [self colorWithHexString:@"#20222e"];
}
+ (UIColor *)titleGrayColor
{
    return [self colorWithHexString:@"#999ea3"];
}

+ (UIColor *)titleGrayColorForDate {
    return [self colorWithHexString:@"#999999"];
}

+ (UIColor *)titleGrayColorForcontent {
    return [self colorWithHexString:@"#8c8c8c"];
}
+ (UIColor *)bgOrangeColorForLabel {
    return [self colorWithHexString:@"#ffb74d"];
}
+ (UIColor *)bgRedColorForLabel {
    return [self colorWithHexString:@"#ff5252"];
}
+ (UIColor *)bgBlueColorForLabel {
    return [self colorWithHexString:@"#00aaef"];
}
+ (UIColor *)bgBlueColorForButton {
    return [self colorWithHexString:@"#00aaef"];
}

+ (UIColor *)separatorColor {
    return [self colorWithHexString:@"#e1e6eb"];
}

@end
