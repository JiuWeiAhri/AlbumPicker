//
//  NSString+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXAttributeMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YXAdd)

#pragma mark - YXAdd

/// 获取汉字拼音
- (NSString *)yx_transformPinYin;

/// 计算字符串字符长度，一个汉字算两个字符
- (NSInteger)yx_unicodeLength;

/// 移除首尾换行符
- (NSString *)yx_removeFirstAndLastLineBreak;

/// 从html string获取图片url 数组
- (NSArray *)yx_getImageurlFromHtmlString;

/// 银行卡格式化
- (NSString *)yx_creditCardFormat;

/// 字符串反转
- (NSString *)yx_reverseWords;

/// 去除前后空格
- (NSString *)yx_trimWhitespace;

/// 去除前后空格和空白行
- (NSString *)yx_trimWhitespaceAndNewline;

/**
 货币标准格式转换工具，四舍五入（例：13123453.23   ->   13,123,453.23）

 @return 货币标准格式
 */
- (NSString *)yx_moneyStandardFormat;

/**
 字符串小数处理，四舍五入；指定保留小数的最大位数，自动去除小数末位0

 @param maxDecimalDigits 最多保留的小数位数，若小数末位是0 则自动去除
 @return return value description
 */
- (NSString *)yx_decimalFormat:(NSInteger)maxDecimalDigits;

/** 时间戳转时间 */
- (NSString *)yx_dateFormat:(NSString *)format __attribute__((deprecated("方法名更换为yx_dateStringWithFormat")));

/** 时间戳转时间 */
- (NSString *)yx_dateStringWithFormat:(NSString *)format;

/** NSString转NSDate */
- (NSDate *)yx_dateWithFormat:(NSString *)format;

/** 从当前时间格式转换成另一个时间格式 */
- (NSString *)yx_dateToFormat:(NSString *)toFormat fromFormat:(NSString *)fromFormat;

/** 获取文件内容 */
+ (NSString *)yx_stringWithFileName:(NSString *)fileName ofType:(NSString *)ofType;

#pragma mark - Size

/// 获取一段字符串的高度
- (CGFloat)yx_getHeightWithMaxWidth:(CGFloat)width font:(UIFont *)font;

/// 获取一段字符串的size
- (CGSize)yx_getSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font;

/** 获取一段字符串的size， */
- (CGSize)yx_getSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font attributesMaker:(nullable void(^)(YXAttributeMaker *make))block;

#pragma mark - Parameters

/// 获取URL链接地址的Value
- (NSString *)yx_valueForUrlKey:(NSString *)key;

#pragma mark - Encode and decode

/// DES加密
+ (NSString *)yx_DESEncryptWithString:(NSString *)text key:(NSString *)key;

/// DES解密
+ (NSString *)DESDecryptWithString:(NSString *)text key:(NSString *)key;

/// URL编码
- (NSString *)yx_urlEncode;

/// URL解码
- (NSString *)yx_urlDecode;

/// 十六进制编码
- (NSString*)yx_hexString;

/// Unicode编码
- (NSString *)yx_unicode;

/// UTF-8编码
- (NSString *)yx_UTF8Encode;

/// MD5加密
- (NSString *)yx_md5String;

#pragma mark - Object

/// NSString转Json对象
- (id)yx_jsonObject;

#pragma mark - Regex

/// 是否字母
- (BOOL)yx_isLetter;

/// 是否是数字
- (BOOL)yx_isNumber;

/// 是否是手机号码
- (BOOL)yx_isPhoneNumber;

/// 是否是身份证
- (BOOL)yx_isIDCard;

/// 是否合法银行卡号
- (BOOL)yx_isBankCard;

@end

NS_ASSUME_NONNULL_END
