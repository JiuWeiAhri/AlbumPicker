//
//  ColorConfig.h
//  FastDevelopKit
//
//  Created by zhao on 2/2/16.
//  Copyright © 2016 zmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef YXColor_h
#define YXColor_h

#pragma mark - 16进制生成颜色

/** 根据16进制数、透明度(0.0-1.0)，生成对应的UIColor颜色 */
CG_INLINE UIColor* YX_Color16A(int RGB_Value, float alpha) {
    return [UIColor colorWithRed:((float)((RGB_Value & 0xFF0000) >> 16))/255.0 green:((float)((RGB_Value & 0xFF00) >> 8))/255.0 blue:((float)(RGB_Value & 0xFF))/255.0 alpha:alpha];
}

/** 示例：YX_Color16(0x000000)，根据16进制数，生成对应的UIColor颜色，透明度为1.0 */
CG_INLINE UIColor* YX_Color16(int RGB_Value) {
    return YX_Color16A(RGB_Value, 1.0);
}

/** 示例：YX_ColorHexString(@"000000")，根据16进制数，生成对应的UIColor颜色，透明度为1.0,不需要加#前缀,默认黑色 */
CG_INLINE UIColor* YX_Color16Named_A(NSString *hexName, float alpha) {
    
    if (![hexName isKindOfClass:[NSString class]]) {
        return YX_Color16(0x000000);
    } else if (hexName.length == 0) {
        return YX_Color16(0x000000);
    }
    
    if ([hexName hasPrefix:@"#"]) {
        hexName = [hexName substringFromIndex:1];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:hexName];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return YX_Color16A(hexNum, alpha);
}

/** 示例：YX_ColorHexString(@"000000")，根据16进制数，生成对应的UIColor颜色，透明度为1.0,不需要加#前缀,默认黑色 */
CG_INLINE UIColor* YX_Color16Named(NSString *hexName) {
    return YX_Color16Named_A(hexName, 1);
}

/** RGB，生成对应的UIColor颜色 */
CG_INLINE UIColor* YX_RGBColor_A(int R, int G, int B, float alpha) {
    return [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:alpha];
}

/** RGB，生成对应的UIColor颜色 */
CG_INLINE UIColor* YX_RGBColor(int R, int G, int B) {
    return [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1];
}

/** 随机颜色 */
CG_INLINE UIColor* YX_RandomColor() {
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}

#pragma mark - System Color

/** System Clear Color */
CG_INLINE UIColor* YX_ClearColor() {
    return [UIColor clearColor];
}

/** System Red Color */
CG_INLINE UIColor* YX_RedColor() {
    return [UIColor redColor];
}

/** System Yellow Color */
CG_INLINE UIColor* YX_YellowColor() {
    return [UIColor yellowColor];
}

/** System Green Color */
CG_INLINE UIColor* YX_GreenColor() {
    return [UIColor greenColor];
}

/** System Blue Color */
CG_INLINE UIColor* YX_BlueColor() {
    return [UIColor blueColor];
}

/** System White Color */
CG_INLINE UIColor* YX_WhiteColor() {
    return [UIColor whiteColor];
}

/** System Black Color */
CG_INLINE UIColor* YX_BlackColor() {
    return [UIColor blackColor];
}

/** System Purple Color */
CG_INLINE UIColor* YX_PurpleColor() {
    return [UIColor purpleColor];
}

/** System DarkGray Color */
CG_INLINE UIColor* YX_DarkGrayColor() {
    return [UIColor darkGrayColor];
}

/** System LightGray Color */
CG_INLINE UIColor* YX_LightGrayColor() {
    return [UIColor lightGrayColor];
}

/** System LightGray Color */
CG_INLINE UIColor* YX_DarkTextColor() {
    return [UIColor darkTextColor];
}

/** System LightGray Color */
CG_INLINE UIColor* YX_GroupTableViewBackgroundColor() {
    return [UIColor groupTableViewBackgroundColor];
}

/** 333333 灰色 */
CG_INLINE UIColor* YX_Color333333() {
    return YX_Color16(0x333333);
}

/** 666666 灰色 */
CG_INLINE UIColor* YX_Color666666() {
    return YX_Color16(0x666666);
}

/** 999999 灰色 */
CG_INLINE UIColor* YX_Color999999() {
    return YX_Color16(0x999999);
}

/** #Line Color */
CG_INLINE UIColor* YX_LineColor() {
    return YX_Color16(0xcecece);
}

#endif /* YX_ColorConfig_h */

NS_ASSUME_NONNULL_END
