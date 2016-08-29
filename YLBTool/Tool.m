//
//  Tool.m
//  CourseCenter
//
//  Created by jian on 15/5/13.
//  Copyright (c) 2015年 line0.com. All rights reserved.
//

#import "Tool.h"
#import "EncryptUtil.h"
#import <objc/runtime.h>
#import "YLBInfo.h"
#import "CocoaSecurity.h"
#import "sys/utsname.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

@implementation Tool


+ (NSString *)getToday
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)getTheDayThirtyDaysAgo{
    NSDate *date               = [NSDate dateWithTimeIntervalSinceNow:-(30 * 24 * 3600)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr          = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getNowTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
//将时间转换为时间戳
+ (NSTimeInterval)timeToTimestamp:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:timeStr];
    NSTimeInterval timesp = [date timeIntervalSince1970];
    formatter = nil;
    return timesp;
}

//时间戳转换为时间
+ (NSString *)timestampToTime:(NSTimeInterval)timestamp
{
    //    NSString *longOftimesTamp = [NSString stringWithFormat:@"%.0lf", timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = nil;
    //    if (longOftimesTamp.length > 10) {
    date  = [NSDate dateWithTimeIntervalSince1970:timestamp];
    //    }else{
    //        date  = [NSDate dateWithTimeIntervalSince1970:timestamp];
    //    }
    NSString *timeStr = [formatter stringFromDate:date];
    formatter = nil;
    return timeStr;
}

//时间戳转换为时间
+ (NSString *)tampToTime:(NSTimeInterval)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = nil;
    date  = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *timeStr = [formatter stringFromDate:date];
    formatter = nil;
    return timeStr;
}

//时间戳转换为时间
+ (NSString *)timestampToTimeWithWord:(NSTimeInterval)timestamp
{
    //    NSString *longOftimesTamp = [NSString stringWithFormat:@"%.0lf", timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate *date = nil;
    //    if (longOftimesTamp.length > 10) {
    date  = [NSDate dateWithTimeIntervalSince1970:timestamp];
    //    }else{
    //        date  = [NSDate dateWithTimeIntervalSince1970:timestamp];
    //    }
    NSString *timeStr = [formatter stringFromDate:date];
    formatter = nil;
    return timeStr;
}

+ (NSMutableDictionary *)dictFromObject:(id)object
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [object valueForKey:(NSString *)propertyName];
        if ([propertyValue isKindOfClass:[NSArray class]] || [propertyValue isKindOfClass:[NSMutableArray class]]) {
            propertyValue = [self arrayFormObjectArray:propertyValue];
        } else if ([propertyValue isKindOfClass:[YLBInfo class]]) {
            propertyValue = [self dictFromObject:propertyValue];
        }
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
    
}

+ (NSString *)jsonFromArray:(NSArray *)array
{
    NSMutableArray *dics = [[NSMutableArray alloc] initWithCapacity:0];
    for (id object in array) {
        NSDictionary *dic = [self dictFromObject:object];
        [dics addObject:dic];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
    
}

+ (NSArray *)arrayFormObjectArray:(NSArray *)array
{
    NSMutableArray *dics = [[NSMutableArray alloc] initWithCapacity:0];
    for (id object in array) {
        NSDictionary *dic = [self dictFromObject:object];
        [dics addObject:dic];
    }
    return dics;
}

//判断字典是否有某key值
+(BOOL)dicContainsKey:(NSDictionary *)dic keyValue:(NSString *)key
{
    
    if ([self objectIsEmpty:dic]) {
        return NO;
    }
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSArray *keyArray = [dic allKeys];
        
        if ([keyArray containsObject:key]) {
            
            return YES;
        }
    }
    
    return NO;
}

//判断对象是否为空
+(BOOL)objectIsEmpty:(id)object
{
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (nil == object){
        return YES;
    }
    return NO;
}

+(NSString *)EmptyObjectContainEmptyString:(id)object
{
    if ([self objectIsEmpty:object]) {
        return @"";
    }
    else
    {
        return object;
    }
}
//判断密码格式是否正确
+ (BOOL)isRightPassworld:(NSString *)passWorld
{
    BOOL one = NO;
    BOOL two = NO;
    BOOL three = NO;
    //判断长度
    if ([passWorld length] >= 6 && [passWorld length] <= 16) {
        one = YES;
    }
    //判断是否含有字母和数字
    for (int i = 0;i < [passWorld length]; i++) {
        char a = [passWorld characterAtIndex:i];
        if (a >= '0' && a <= '9' ) {
            two = YES;
        }
        if (a >= 'A' && a <= 'z') {
            three = YES;
        }
    }
    
    if (one && two && three) {
        return YES;
    }else{
        return NO;
    }
}


//判断邀请码是否正确;
+ (BOOL)isNumberOrNil:(NSString *)recommendedTelStr
{
    BOOL result = NO;
    
    if (recommendedTelStr == nil || [recommendedTelStr isEqualToString:@""]) {
        result = YES;
    }else{
        
        if ([recommendedTelStr hasPrefix:@"800"]) {
            if ([recommendedTelStr length] >= 4 && [recommendedTelStr length] <= 11) {
                if ([self isNumber:recommendedTelStr]) {
                    result = YES;
                }
            }
        }else if ([recommendedTelStr hasPrefix:@"1"]){
            if ([self isMobileNumber:recommendedTelStr]) {
                result = YES;
            }
        }
    }
    return result;
}

//判断是否是纯数字;
+ (BOOL)isNumber:(NSString *)recommendedTelStr
{ BOOL result = YES;
    for (int i = 0; i < [recommendedTelStr length];i++) {
        if ([recommendedTelStr characterAtIndex:i] < '0'
            || [recommendedTelStr characterAtIndex:i] > '9') {
            result = NO;
            
        }
    }
    return result;
}


//判断手机号是否有效
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,147,183
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0-9]|8[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，183
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
// 校验银行卡卡号
+ (BOOL)isBankNumber:(NSString *)cardNo
{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}
// 校验身份证号
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}
// 校验是否为中文
+ (BOOL)isChinese:(NSString *)str {
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

//得到加密后的参数
+ (NSDictionary *)getParameters:(id)params withUrl:(NSString *)url token:(NSString *)token
{
    
    return @{@"i": [self getEncryptStringWithParameters:params withurl:url token:token]};
}

//对json格式数据进行加密
+ (NSString *)getEncryptStringWithParameters:(id)params withurl:(NSString *)url token:(NSString *)token{
    if (token.length >0 && url.length >0) {
        NSDate *date = [NSDate date];
        NSTimeInterval timeinterval = [date timeIntervalSince1970];
        NSString *timeStr = [NSString stringWithFormat:@"%.0lf",timeinterval];
        
        NSMutableString *tmpStr = [NSMutableString stringWithFormat:@"POST&%@&",url];
        
        NSMutableDictionary * newDic = [[NSMutableDictionary alloc]initWithDictionary:params];
        [newDic setObject:@"yonglibao" forKey:@"auth_key"];
        [newDic setObject:[NSString stringWithFormat:@"%.0lf",timeinterval] forKey:@"auth_timestamp"];
        [newDic setObject:@"1.0.0" forKey:@"auth_version"];
        
        NSArray * array = newDic.allKeys;
        NSArray * newArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSMutableString * Str1 = [[NSMutableString alloc]init];
        
        for (int i = 0 ; i < newArray.count; i++) {
            [Str1 appendString:[NSString stringWithFormat:@"&%@=%@", newArray[i], newDic[newArray[i]]]];
            
        }
        [Str1 deleteCharactersInRange:NSMakeRange(0, 1)];
        [tmpStr appendString:Str1];
        
        CocoaSecurityResult *signature = [CocoaSecurity hmacSha256:tmpStr hmacKey:token];
        
        // 字典
        NSMutableDictionary *dic;
        if (params == nil) {
            dic = [NSMutableDictionary new];
        }else{
            dic = [params mutableCopy];
        }
        NSString * newSign = [signature.hex lowercaseString];
        [dic addEntriesFromDictionary:@{
                                        @"auth_key": @"yonglibao",
                                        @"auth_version": @"1.0.0",
                                        @"auth_timestamp": timeStr,
                                        @"auth_signature": newSign,
                                        }];
        NSError *error = nil;
        NSString *jsonString;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if (!jsonData) {
            NSLog(@"[net]GotParams: %@", error);
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSString *encValues = [EncryptUtil encryptWithText:jsonString];
        
        return encValues;
    }
    
    NSError *error = nil;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"[net]GotParams: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString *encValues = [EncryptUtil encryptWithText:jsonString];
    
    return encValues;
}


//将加密后的数据解密后转换为字符串
+ (NSString *)dataToStringwithdata:(NSData*)data {
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *jsonStr = [EncryptUtil decryptWithText:str];
    return jsonStr;
}
//将加密后的数据解密后转换为字典
+ (NSDictionary *)dataToDictionary:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *jsonStr = [EncryptUtil decryptWithText:str];
    return [self jsonToDictionary:jsonStr];
}

+ (NSDictionary *)jsonToDictionary:(NSString *)jsonString
{
    NSDictionary *JSON;
    if (jsonString && ![jsonString isEqual:[NSNull null]]) {
        NSError *error;
        JSON = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    }
    return JSON;
}

+ (NSString *)numFormaterWithNUmber:(NSNumber *)number {
    NSString *formaterStr = nil;
    if (number) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        //        formatter.formatterBehavior = NSDateFormatterBehavior10_4;
        formaterStr = [formatter stringFromNumber:number];
    }
    return formaterStr;
    
}
+ (NSString *)floatFormaterWithNUmber:(NSNumber *)number {
    if (number) {
       return [self strmethodComma:[NSString stringWithFormat:@"%.2f",[number doubleValue]]];
    }
    return @"0.00";
    
}

+ (NSString *)stringByAppendZero:(NSString *)str{
    NSString *result = str;
    NSArray *arr = [str componentsSeparatedByString:@"."];
    if (arr.count == 1) {
        result = [NSString stringWithFormat:@"%@.00",str];
    }else if(arr.count == 2){
        NSString *decimalString = [arr objectAtIndex:1];
        if (decimalString.length ==1) {
            result = [NSString stringWithFormat:@"%@0",str];
        }
    }
    
    return result;
}

+(NSString*)strmethodComma:(NSString*)string
{
    NSString *sign = nil;
    if ([string hasPrefix:@"-"]||[string hasPrefix:@"+"]) {
        sign = [string substringToIndex:1];
        string = [string substringFromIndex:1];
    }
    
    NSString *pointLast = [string substringFromIndex:[string length]-3];
    NSString *pointFront = [string substringToIndex:[string length]-3];
    
    int commaNum = (int)([pointFront length]-1)/3;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < commaNum+1; i++) {
        int index = (int)[pointFront length] - (i+1)*3;
        int leng = 3;
        if(index < 0)
        {
            leng = 3+index;
            index = 0;
            
        }
        NSRange range = {index,leng};
        NSString *stq = [pointFront substringWithRange:range];
        [arr addObject:stq];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (int i = (int)[arr count]-1; i>=0; i--) {
        
        [arr2 addObject:arr[i]];
    }
    NSString *commaString = [[arr2 componentsJoinedByString:@","] stringByAppendingString:pointLast];
    if (sign) {
        commaString = [sign stringByAppendingString:commaString];
    }
    return commaString;
    
}

+ (float )stringFormaterToFloat:(NSString *)string
{
    float floatMoney = 0.;
    if (![string isEqualToString:@""] && ![string isEqual:[NSNull null]])
    {
        floatMoney = [[NSString stringWithFormat:@"%.2f",[[string stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]] floatValue];
    }
    return floatMoney;
}


+ (float )stringFormaterToDouble:(NSString *)string
{
    float floatMoney = 0.;
    if (![string isEqualToString:@""] && ![string isEqual:[NSNull null]])
    {
        floatMoney = [[NSString stringWithFormat:@"%.2f",[[string stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]] doubleValue];
    }
    return floatMoney;
}

+ (NSString *)stringByAppendComma:(NSString *)money{
    NSString *result = money;
    
    if (money.length < 3){
        return result;
    }
    
    NSArray *array = [money componentsSeparatedByString:@"."];
    NSString *numInt = [array objectAtIndex:0];
    if (numInt.length <= 3){
        return result;
    }
    NSString *suffixStr = @"";
    if ([array count] > 1){
        suffixStr = [NSString stringWithFormat:@".%@",[array objectAtIndex:1]];
    }
    
    NSMutableArray *numArr = [[NSMutableArray alloc] init];
    while (numInt.length > 3)
    {
        NSString *temp = [numInt substringFromIndex:numInt.length - 3];
        numInt = [numInt substringToIndex:numInt.length - 3];
        [numArr addObject:[NSString stringWithFormat:@",%@",temp]];//得到的倒序的数据
    }
    
    for (int i = 0; i < numArr.count; i++)
    {
        numInt = [numInt stringByAppendingFormat:@"%@",[numArr objectAtIndex:(numArr.count -1 -i)]];
    }
    
    result = [NSString stringWithFormat:@"%@%@",numInt,suffixStr];
    
    return result;
}

+(NSString *)notRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%.2f",[roundedOunces doubleValue]];
}

+ (void)callPhoneWithNumber:(NSString *)phoneNumber{
    if (phoneNumber.length >0) {
        //方法1
        //        UIWebView * callWebview = [[UIWebView alloc] init];
        //        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]]];
        
        //方法2
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]]];
    }
}

#pragma mark - 获取Http请求IP及端口号

+ (NSString *)efGetServerInfo{
    NSArray *server ;
#ifdef DEBUG
    server = [self efGetDebugServerForKey:@"debug_Test3"];
#else
    server = [self efGetRelseaseServerForKey:@"release"];
#endif
    return [server componentsJoinedByString:@""];
}


+(NSArray *)efGetRelseaseServerForKey:(NSString *)key{
    NSDictionary *dic = [self efGetDicFromConfig];
    NSDictionary *tmpDic = [dic valueForKeyPath:[NSString stringWithFormat:@"release.%@",key]];
    
    return @[[tmpDic objectForKey:@"server"],[tmpDic objectForKey:@"port"]] ;
}

+(NSArray *)efGetDebugServerForKey:(NSString *)key{
    NSDictionary *dic = [self efGetDicFromConfig];
    NSDictionary *tmpDic = [dic valueForKeyPath:[NSString stringWithFormat:@"debug.%@",key]];
    
    return @[[tmpDic objectForKey:@"server"],[tmpDic objectForKey:@"port"]];
}


+(NSDictionary *)efGetDicFromConfig{
    NSDictionary *dictionary = @{@"debug":@{@"debug_Test":@{@"server":@"http://114.215.133.153",
                                                            @"port":@":680"},
                                            @"debug_Test1":@{@"server":@"http://121.42.216.197",
                                                             @"port":@":9998"},
                                            @"debug_Test2":@{@"server":@"http://42.96.187.123",
                                                             @"port":@":9001"},
                                            @"debug_Test3":@{@"server":@"http://test134.yonglibao.com",
                                                             @"port":@""},
                                            @"debug_Test4":@{@"server":@"http://114.215.133.153",
                                                             @"port":@":480"},
                                            @"debug_Test5":@{@"server":@"http://172.16.10.126",
                                                             @"port":@":8088"},
                                            @"debug_Test6":@{@"server":@"http://114.215.133.153",
                                                             @"port":@":680"},
                                            @"debug_PreRelease":@{@"server":@"http://115.28.62.121",
                                                                  @"port":@":80"},
                                            @"debug_Release":@{@"server":@"http://api.yonglibao.com",
                                                               @"port":@":80"}},
                                 @"release":@{@"release":@{@"server":@"http://api.yonglibao.com",
                                                           @"port":@":80"},
                                              @"PreRelease":@{@"server":@"http://115.28.62.121",
                                                              @"port":@":80"},
                                              @"PreRelease2":@{@"server":@"http://42.96.187.123",
                                                               @"port":@":8701"},
                                              @"Release_old":@{@"server":@"http://mo.yonglibao.com",
                                                               @"port":@""},}};
    
    return dictionary;
}

+(NSMutableAttributedString *)getAttributedString:(NSString *)string
                                             font:(UIFont *)font
                                            color:(UIColor *)color
                                            range:(NSRange)range{
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    if (font) {
        [attributedString addAttribute:NSFontAttributeName value:font range:range];
    }else{
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    }
    if (color) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }else{
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    }
    
    return attributedString;
}

+ (UIImage *)getImageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)getDeviceInfo{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //CLog(@"%@",deviceString);
    if ([platform hasPrefix:@"iPhone"]) {
        if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
        if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
        if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
        if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
        if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
        if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
        if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
        if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
        if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
        if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
        if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
        if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
        if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
        if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    }else if ([platform hasPrefix:@"iPod"]){
        if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G (A1574)";
        if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
        if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
        if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
        if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
        
    }else if ([platform hasPrefix:@"iPad"]){
        if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
        if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
        if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
        if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
        if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
        if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
        if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
        if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
        if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
        if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
        if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
        if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
        
        if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
        if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
        if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
        if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
        if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
        if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
        if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    }else{
        if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
        if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    }
    
    return platform;
}

+ (double)getAvailableMemory{
    vm_statistics_data_t vmStats;
    
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               
                                               HOST_VM_INFO,
                                               
                                               (host_info_t)&vmStats,
                                               
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        
        return NSNotFound;
        
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

+ (double)getUsedMemory{
    
    task_basic_info_data_t taskInfo;
    
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         
                                         TASK_BASIC_INFO,
                                         
                                         (task_info_t)&taskInfo,
                                         
                                         &infoCount);
    
    
    if (kernReturn != KERN_SUCCESS) {
        
        return NSNotFound;
        
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+ (NSString *)URLEncodeString:(NSString *)str{
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[str UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
+ (NSString *)URLDecodeString:(NSString *)str{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    return result;
}
 
@end
