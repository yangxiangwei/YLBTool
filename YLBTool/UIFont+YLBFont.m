//
//  UIFont+YLBFont.m
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/28.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import "UIFont+YLBFont.h"

@implementation UIFont (YLBFont)

+(UIFont *)helveticaNeueOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

+(UIFont *)helveticaNeueLightOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
}

+(UIFont *)helveticaNeueBoldOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
}

@end
