//
//  YXRegex.h
//  YXKitOC
//
//  Created by zhxin on 2020/8/20.
//  Copyright © 2020 张鑫. All rights reserved.
//  -常用正则表达式

#ifndef YXRegex_h
#define YXRegex_h

NS_ASSUME_NONNULL_BEGIN

/** 手机号（11位，1开头） */
static NSString *YXRegex_isPhoneNumber11 = @"^[1][0-9]{10}$"; /**< 是否为手机号 */
static NSString *YXRegex_canInputPhoneNumber11 = @"^[1][0-9]{0,10}$"; /**< 手机号输入范围 */

/** 身份证（18位，只能输入数字，和x,且X应该在第18位） */
static NSString *YXRRegex_isID = @"^[0-9]{18}||[0-9]{17}(?i)x"; /// 是否为身份证
static NSString *YXRegex_canInputID = @"^[0-9]{0,18}||[0-9]{17}(?i)x"; /// 身份证输入范围

/** 短信验证码（4-6位数字） */
static NSString *YXRegex_isMsgCode = @"[0-9]{4,6}"; /**< 是否为短信验证码 */
static NSString *YXRegex_canInputMsgCode = @"[0-9]{0,6}"; /**< 短信验证码输入范围 */

/** 行驶里程（0-99.99万公里，纯数字） */
static NSString *YXRegex_isMeliage = @"^(([0]|(0[.]\\d{0,2}))|([1-9]{0,1}[0-9]{0,1}(([.]\\d{0,2})?)))?"; /**< 是否为行驶里程 */
static NSString *YXRegex_canInputMeliage = @"^(([0]|(0[.]\\d{0,2}))|([1-9]{0,1}[0-9]{0,1}(([.]\\d{0,2})?)))?"; /**< 行驶里程输入范围 */

/** VIN码（不能输入I、O、Q） */
static NSString *YXRegex_isVIN = @"[A-HJ-NPR-Za-hj-npr-z\\d]{17}"; /**< 是否是VIN码 */
static NSString *YXRegex_canInputVIN = @"[A-HJ-NPR-Za-hj-npr-z\\d]{0,17}"; /**< VIN码输入范围 */

/** 正则表达式 */
CG_INLINE BOOL YXRegex(NSString * _Nullable text, NSString * _Nullable regex) {
    if (!text || !regex) {
        return NO;
    }
    NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPass = [prd evaluateWithObject:text];
    return isPass;
}

NS_ASSUME_NONNULL_END

#endif /* Regular_h */
