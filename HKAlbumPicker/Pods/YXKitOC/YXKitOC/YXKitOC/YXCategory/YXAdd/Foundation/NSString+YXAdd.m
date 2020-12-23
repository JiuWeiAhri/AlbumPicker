//
//  NSString+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "NSString+YXAdd.h"
#import "NSData+YXAdd.h"
#import <YYCategories/NSData+YYAdd.h>
#import <YYCategories/NSString+YYAdd.h>
#import "NSDate+YXAdd.h"
#import <YYCategories/NSDate+YYAdd.h>

#define     LocalStr_None           @""
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (YXAdd)

/// 获取汉字拼音
- (NSString *)yx_transformPinYin {
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [self mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    //返回最近结果
    return pinyin;
}

/// 计算字符串字符长度，一个汉字算两个字符
- (NSInteger)yx_unicodeLength {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

/// 移除首尾换行符
- (NSString *)yx_removeFirstAndLastLineBreak {
    NSString *newStr = self;
    while ([newStr hasPrefix:@"\n"]) {
        newStr = [newStr substringFromIndex:2];
    }
    while ([newStr hasSuffix:@"\n"]) {
        newStr = [newStr substringToIndex:newStr.length-1];
    }
    return newStr;
}

/// 从html string获取图片url 数组
- (NSArray *)yx_getImageurlFromHtmlString {
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    //标签匹配
    NSString *parten = @"<img(.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:self options:0 range:NSMakeRange(0, [self length] - 1)];
    
    for (NSTextCheckingResult * result in match) {
        
        NSRange range = [result range];
        NSString * subString = [self substringWithRange:range];
        
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        
        [imageurlArray addObject:imagekUrl];
    }
    return imageurlArray;
}

/// 银行卡格式化
- (NSString *)yx_creditCardFormat {
    NSString *newString = @"";
    NSString *originalCardNumber = self;
    while (originalCardNumber.length > 0) {
        NSString *subString = [originalCardNumber substringToIndex:MIN(originalCardNumber.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        originalCardNumber = [originalCardNumber substringFromIndex:MIN(originalCardNumber.length, 4)];
    }
    
    return newString;
}

/// 字符串反转
- (NSString *)yx_reverseWords {
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:self.length];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [newString appendString:substring];
    }];
    return newString;
}

/// 去除前后空格
- (NSString *)yx_trimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/// 去除前后空格和空白行
- (NSString *)yx_trimWhitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)yx_moneyStandardFormat {
    NSNumberFormatter *formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    [formater setMinimumFractionDigits:2];
    [formater setMaximumFractionDigits:2];
    formater.currencyGroupingSeparator = @"*";
    return [formater stringFromNumber:[NSNumber numberWithDouble:[[formater numberFromString:self] doubleValue]]];
}

- (NSString *)yx_decimalFormat:(NSInteger)maxDecimalDigits {
    NSNumberFormatter *formater = [[NSNumberFormatter alloc]init];
    formater.numberStyle = NSNumberFormatterNoStyle;
    [formater setMinimumFractionDigits:0];
    [formater setMaximumFractionDigits:maxDecimalDigits];
    NSString *str = [formater stringFromNumber:[NSNumber numberWithDouble:[[formater numberFromString:self] doubleValue]]];
    if ([str hasPrefix:@"."]) return [str stringByReplacingOccurrencesOfString:@"." withString:@"0."];
    return str;
}

/** 时间戳转时间 */
- (NSString *)yx_dateFormat:(NSString *)format {
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSMutableString class]]) {
        return [[NSDate dateWithTimeIntervalSince1970:self.doubleValue] yx_dateToStringWithFormat:format];
    } else {
        return @"";
    }
}

/** 时间戳转时间 */
- (NSString *)yx_dateStringWithFormat:(NSString *)format {
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSMutableString class]]) {
        return [[NSDate dateWithTimeIntervalSince1970:self.doubleValue] yx_dateToStringWithFormat:format];
    } else {
        return @"";
    }
}

/** NSString转NSDate */
- (NSDate *)yx_dateWithFormat:(NSString *)format {
    return [NSDate dateWithString:self format:format];
}

/** 从当前时间格式转换成另一个时间格式 */
- (NSString *)yx_dateToFormat:(NSString *)toFormat fromFormat:(NSString *)fromFormat {
    NSDate *date = [NSDate dateWithString:self format:fromFormat];
    return [date yx_dateToStringWithFormat:toFormat];
}

/** 获取文件内容 */
+ (NSString *)yx_stringWithFileName:(NSString *)fileName ofType:(NSString *)ofType {
    NSError *error;
    NSString *filePath = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:ofType] encoding:NSUTF8StringEncoding error:&error];
    return filePath;
}

#pragma mark - Size

/// 获取一段字符串的高度
- (CGFloat)yx_getHeightWithMaxWidth:(CGFloat)width font:(UIFont *)font {
    return [self yx_getSizeWithMaxSize:CGSizeMake(width, CGFLOAT_MAX) font:font].height;
}

/// 获取一段字符串的size
- (CGSize)yx_getSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font {
    return [self yx_getSizeWithMaxSize:maxSize font:font attributesMaker:nil];
}

- (CGSize)yx_getSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font attributesMaker:(void(^)(YXAttributeMaker *make))block {
    if (block) {
        YXAttributeMaker *maker = [[YXAttributeMaker alloc] init];
        maker.maxSize = maxSize;
        maker.text = self;
        maker.font = font;
        block(maker);
        return [maker size];
    } else {
        return [self boundingRectWithSize:maxSize
                                  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName : font}
                                  context:nil].size;
    }
}

#pragma mark - Parameters

/// 获取URL链接地址的Value
- (NSString *)yx_valueForUrlKey:(NSString *)key {
    NSString *request = self.lowercaseString;
    NSString *queryCopy = key.lowercaseString;
    if ([request containsString:queryCopy]) {
        NSArray *arr = [request componentsSeparatedByString:[NSString stringWithFormat:@"%@=",queryCopy]];
        if (arr.count) {
            NSString *str = [arr lastObject];
            NSArray *queryArr = [str componentsSeparatedByString:@"&"];
            if (queryArr) {
                return [queryArr firstObject];
            }else{
                return @"";
            }
        } else {
            return @"";
        }
    } else {
        return @"";
    }
}

#pragma mark - Encode and decode

/// DES加密
+ (NSString *)yx_DESEncryptWithString:(NSString *)text key:(NSString *)key {
    if (text && ![text isEqualToString:LocalStr_None]) {
        
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        data = [NSData yx_DESEncrypt:data WithKey:key];
        return [self yx_base64StringWithData:data];
    } else {
        return LocalStr_None;
    }
}

/// DES解密
+ (NSString *)DESDecryptWithString:(NSString *)text key:(NSString *)key {
    if (text && ![text isEqualToString:LocalStr_None]) {
        NSData *data = [NSData yx_dataWithBase64String:text];
        data = [NSData yx_DESDecrypt:data WithKey:key];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        return LocalStr_None;
    }
}

+ (NSString *)yx_base64StringWithData:(NSData *)data {
    NSUInteger length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1) {
        return @"";
    }
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) {
            break;
        }
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext) {
                input[i] = raw[ix];
            }
            else {
                input[i] = 0;
            }
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++) {
            [result appendString: [NSString stringWithFormat: @"%c", encodingTable[output[i]]]];
        }
        
        for (i = ctcopy; i < 4; i++) {
            [result appendString: @"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length)) {
            charsonline = 0;
        }
    }
    return result;
}

/// URL编码
- (NSString *)yx_urlEncode {
    return  [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/// URL解码
- (NSString *)yx_urlDecode {
    return [self stringByRemovingPercentEncoding];
}

/// 十六进制编码
- (NSString *)yx_hexString {
    return [self yx_hexString];
}

/// Unicode编码
- (NSString *)yx_unicode {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

/// UTF-8编码
- (NSString *)yx_UTF8Encode {
    return [NSString stringWithString:[self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

/// MD5加密
- (NSString *)yx_md5String {
    return [self md5String];
}

#pragma mark - Object

/// NSString转Json对象
- (id)yx_jsonObject {
    return [self jsonValueDecoded];
}

#pragma mark - Regex

/// 是否字母
- (BOOL)yx_isLetter {
    NSString* regex = @"^[A-Za-z]+$";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [phoneTest evaluateWithObject:self];
}

/// 是否是纯数字
- (BOOL)yx_isNumber {
    NSString* regex = @"^[0-9]+$";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [phoneTest evaluateWithObject:self];
}

/// 是否是手机号码
- (BOOL)yx_isPhoneNumber {
    NSString* phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/// 是否是身份证
- (BOOL)yx_isIDCard {
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

/// 是否合法银行卡号
- (BOOL)yx_isBankCard {
    if (self.length == 0) {
        return NO;
    }
    if (self.length < 15) {
        return NO;
    }
    
    NSString* digitsOnly = @"";
    char c;
    for (int i = 0; i < self.length; i++) {
        c = [self characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly = [digitsOnly stringByAppendingFormat:@"%c", c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

@end
