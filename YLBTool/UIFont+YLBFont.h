//
//  UIFont+YLBFont.h
//  WhiteDragon
//
//  Created by 杨相伟 on 16/7/28.
//  Copyright © 2016年 YongLibao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SystemFont(fontSize)                [UIFont systemFontOfSize:(fontSize)]

#define Font_10 ([UIFont systemFontOfSize:10])
#define Font_12 ([UIFont systemFontOfSize:12])
#define Font_14 ([UIFont systemFontOfSize:14])
#define Font_15 ([UIFont systemFontOfSize:15])
#define Font_16 ([UIFont systemFontOfSize:16])
#define Font_17 ([UIFont systemFontOfSize:17])
#define Font_18 ([UIFont systemFontOfSize:18])
#define Font_20 ([UIFont systemFontOfSize:20])
#define Font_30 ([UIFont systemFontOfSize:30])

#define fontH_10 ([UIFont fontWithName:@"HelveticaNeue" size:10])
#define fontH_12 ([UIFont fontWithName:@"HelveticaNeue" size:12])
#define fontH_13 ([UIFont fontWithName:@"HelveticaNeue" size:13])
#define fontH_14 ([UIFont fontWithName:@"HelveticaNeue" size:14])
#define fontH_15 ([UIFont fontWithName:@"HelveticaNeue" size:15])
#define fontH_16 ([UIFont fontWithName:@"HelveticaNeue" size:16])
#define fontH_18 ([UIFont fontWithName:@"HelveticaNeue" size:18])
#define fontH_20 ([UIFont fontWithName:@"HelveticaNeue" size:20])
#define fontH_22 ([UIFont fontWithName:@"HelveticaNeue" size:22])
#define fontH_25 ([UIFont fontWithName:@"HelveticaNeue" size:25])
#define fontH_26 ([UIFont fontWithName:@"HelveticaNeue" size:26])
#define fontH_36 ([UIFont fontWithName:@"HelveticaNeue" size:36])
#define fontH_45 ([UIFont fontWithName:@"HelveticaNeue" size:45])


@interface UIFont (YLBFont)

/**
 *  HelveticaNeue
 *
 *  @param fontSize 字体大小
 *
 *  @return UIFont
 */
+(UIFont *)helveticaNeueOfSize:(CGFloat)fontSize;

/**
 *  HelveticaNeue-Light
 *
 *  @param fontSize 字体大小
 *
 *  @return UIFont
 */
+(UIFont *)helveticaNeueLightOfSize:(CGFloat)fontSize;

/**
 *  HelveticaNeue-Bold
 *
 *  @param fontSize 字体大小
 *
 *  @return UIFont
 */
+(UIFont *)helveticaNeueBoldOfSize:(CGFloat)fontSize;

@end
