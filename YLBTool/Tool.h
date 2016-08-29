//
//  Tool.h
//  CourseCenter
//
//  Created by jian on 15/5/13.
//  Copyright (c) 2015年 line0.com. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import <UIKit/UIKit.h>
@interface Tool : NSObject



#pragma mark- 时间处理

//获取今天日期
+ (NSString *)getToday;
//获取30天以前日期
+(NSString *)getTheDayThirtyDaysAgo;
//获取现在的时间
+ (NSString *)getNowTime;
//将时间转换为时间戳
+ (NSTimeInterval)timeToTimestamp:(NSString *)timeStr;
//时间戳转换为时间
+ (NSString *)timestampToTime:(NSTimeInterval)timestamp;
+ (NSString *)timestampToTimeWithWord:(NSTimeInterval)timestamp;
+ (NSString *)tampToTime:(NSTimeInterval)timestamp;

#pragma mark- 对象处理

//将对象装换为dic
+ (NSMutableDictionary *)dictFromObject:(id)object;
//将一个数组转换为json格式
+ (NSString *)jsonFromArray:(NSArray *)array;
//将一个数组里的对象转换为字典
+ (NSArray *)arrayFormObjectArray:(NSArray *)array;
//判断字典是否有某key值
+(BOOL)dicContainsKey:(NSDictionary *)dic keyValue:(NSString *)key;
//判断对象是否为空
+(BOOL)objectIsEmpty:(id)object;
//把空的的字符串转换为@“”
+(NSString *)EmptyObjectContainEmptyString:(id)object;
//判断手机号是否有效
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//校验银行卡卡号
+ (BOOL)isBankNumber:(NSString *)bankNum;
//校验身份证号码
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo;
//校验是否为中文
+ (BOOL)isChinese:(NSString *)str;

//判断邀请码是否正确;
+ (BOOL)isNumberOrNil:(NSString *)recommendedTelStr;
+ (BOOL)isRightPassworld:(NSString *)passWorld;

+ (NSDictionary *)getParameters:(id)params withUrl:(NSString *)url token:(NSString *)token;
//将加密后的数据解密后转换为字符串
+ (NSString *)dataToStringwithdata:(NSData*)data;
//将加密后的数据解密后转换为字典
+ (NSDictionary *)dataToDictionary:(NSData *)data;

/**
 *  字符串转换为Dictionary
 *
 *  @param jsonString jsonString
 *
 *  @return Dictionary
 */
+ (NSDictionary *)jsonToDictionary:(NSString *)jsonString;
//转化成带逗号的钱数
+ (NSString *)numFormaterWithNUmber:(NSNumber *)number;
+ (NSString *)floatFormaterWithNUmber:(NSNumber *)number;

/**
 *  格式化金额字符串
 *
 *  @param money 金额
 *
 *  @return
 */
+ (NSString *)stringByAppendComma:(NSString *)money;

+(NSString *)notRounding:(double)price afterPoint:(int)position;
//带逗号的钱数 转化 成float
+ (float)stringFormaterToFloat:(NSString *)string;
/**
 *  带逗号的钱数 转化 成double
 *
 *  @param string 数字字符串
 *
 *  @return
 */
+ (float )stringFormaterToDouble:(NSString *)string;
/**
 *  拨打电话
 *
 *  @param phoneNumber 电话号码
 */
+ (void)callPhoneWithNumber:(NSString *)phoneNumber;

/**
 *  从本地获取http server 和 port
 *
 *  @return server,port
 */
+ (NSString *)efGetServerInfo;

/**
 *  获取格式化字体
 *
 *  @param string
 *  @param font
 *  @param color
 *  @param range
 *
 *  @return
 */
+(NSMutableAttributedString *)getAttributedString:(NSString *)string
                                             font:(UIFont *)font
                                            color:(UIColor *)color
                                            range:(NSRange)range;


/**
 *  把UIView对象转换为Image
 *
 *  @param theView 待转换的对象
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView;

/**
 *  获取设备信息
 *
 *  @return 设备信息
 */
+ (NSString *)getDeviceInfo;

/**
 *  获取当前设备可用内存(单位：MB）
 *
 *  @return 获取当前设备可用内存(单位：MB）
 */
+ (double)getAvailableMemory;

/**
 *  获取当前任务所占用的内存（单位：MB）
 *
 *  @return 获取当前任务所占用的内存（单位：MB）
 */
+ (double)getUsedMemory;

/**
 *  Encode Url
 *
 *  @param str
 *
 *  @return
 */
+ (NSString *)URLEncodeString:(NSString *)str;

/**
 *  Decode Url
 *
 *  @param str
 *
 *  @return
 */
+ (NSString *)URLDecodeString:(NSString *)str;
 
@end
