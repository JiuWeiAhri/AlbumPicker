//
//  YXFitFont.h
//  YXKitDemo
//
//  Created by zx on 2018/3/14.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#ifndef YXFitFont_h
#define YXFitFont_h
#import <UIKit/UIKit.h>

/*! 自适配字号 DynamicAdapter */
CG_INLINE UIFont* YX_FitFont(int size) {
    return [UIFont systemFontOfSize:size*(([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)/375.0)];
}

/*! 自适配字号 DynamicAdapter */
CG_INLINE UIFont* YX_FitBlodFont(int size) {
    return [UIFont boldSystemFontOfSize:size*(([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)/375.0)];
}

#pragma mark - System Font

/** 系统字体 */
CG_INLINE UIFont* YX_SystemFont(int size) {
    return [UIFont systemFontOfSize:size];
}
/** 系统字体加粗 */
CG_INLINE UIFont* YX_BlodFont(int size) {
    return [UIFont boldSystemFontOfSize:size];
}

/** System font */
CG_INLINE UIFont* YX_Font(int size) {
    return YX_SystemFont(size);
}

/** System font 6 */
CG_INLINE UIFont* YX_Font6() {
    return YX_SystemFont(6);
}

/** System font 7 */
CG_INLINE UIFont* YX_Font7() {
    return YX_SystemFont(7);
}

/** System font 8 */
CG_INLINE UIFont* YX_Font8() {
    return YX_SystemFont(8);
}

/** System font 9 */
CG_INLINE UIFont* YX_Font9() {
    return YX_SystemFont(9);
}

/** System font 10 */
CG_INLINE UIFont* YX_Font10() {
    return YX_SystemFont(10);
}

/** System font 11 */
CG_INLINE UIFont* YX_Font11() {
    return YX_SystemFont(11);
}

/** System font 12 */
CG_INLINE UIFont* YX_Font12() {
    return YX_SystemFont(12);
}

/** System font 13 */
CG_INLINE UIFont* YX_Font13() {
    return YX_SystemFont(13);
}

/** System font 14 */
CG_INLINE UIFont* YX_Font14() {
    return YX_SystemFont(14);
}

/** System font 15 */
CG_INLINE UIFont* YX_Font15() {
    return YX_SystemFont(15);
}

/** System font 16 */
CG_INLINE UIFont* YX_Font16() {
    return YX_SystemFont(16);
}

/** System font 17 */
CG_INLINE UIFont* YX_Font17() {
    return YX_SystemFont(17);
}

/** System font 18 */
CG_INLINE UIFont* YX_Font18() {
    return YX_SystemFont(18);
}

/** System font 19 */
CG_INLINE UIFont* YX_Font19() {
    return YX_SystemFont(19);
}

/** System font 20 */
CG_INLINE UIFont* YX_Font20() {
    return YX_SystemFont(20);
}

/** System font 21 */
CG_INLINE UIFont* YX_Font21() {
    return YX_SystemFont(21);
}

/** System font 22 */
CG_INLINE UIFont* YX_Font22() {
    return YX_SystemFont(22);
}

/** System font 23 */
CG_INLINE UIFont* YX_Font23() {
    return YX_SystemFont(23);
}

/** System font 24 */
CG_INLINE UIFont* YX_Font24() {
    return YX_SystemFont(24);
}

/** System font 25 */
CG_INLINE UIFont* YX_Font25() {
    return YX_SystemFont(25);
}

/** System font 26 */
CG_INLINE UIFont* YX_Font26() {
    return YX_SystemFont(26);
}

/** System font 27 */
CG_INLINE UIFont* YX_Font27() {
    return YX_SystemFont(27);
}

/** System font 28 */
CG_INLINE UIFont* YX_Font28() {
    return YX_SystemFont(28);
}

/** System font 29 */
CG_INLINE UIFont* YX_Font29() {
    return YX_SystemFont(29);
}

/** System font 30 */
CG_INLINE UIFont* YX_Font30() {
    return YX_SystemFont(30);
}

#pragma mark - Fit System Font

/** System font 6 */
CG_INLINE UIFont* YX_FitFont6() {
    return YX_FitFont(6);
}

/** System font 7 */
CG_INLINE UIFont* YX_FitFont7() {
    return YX_FitFont(7);
}

/** System font 8 */
CG_INLINE UIFont* YX_FitFont8() {
    return YX_FitFont(8);
}

/** System font 9 */
CG_INLINE UIFont* YX_FitFont9() {
    return YX_FitFont(9);
}

/** System font 10 */
CG_INLINE UIFont* YX_FitFont10() {
    return YX_FitFont(10);
}

/** System font 11 */
CG_INLINE UIFont* YX_FitFont11() {
    return YX_FitFont(11);
}

/** System font 12 */
CG_INLINE UIFont* YX_FitFont12() {
    return YX_FitFont(12);
}

/** System font 13 */
CG_INLINE UIFont* YX_FitFont13() {
    return YX_FitFont(13);
}

/** System font 14 */
CG_INLINE UIFont* YX_FitFont14() {
    return YX_FitFont(14);
}

/** System font 15 */
CG_INLINE UIFont* YX_FitFont15() {
    return YX_FitFont(15);
}

/** System font 16 */
CG_INLINE UIFont* YX_FitFont16() {
    return YX_FitFont(16);
}

/** System font 17 */
CG_INLINE UIFont* YX_FitFont17() {
    return YX_FitFont(17);
}

/** System font 18 */
CG_INLINE UIFont* YX_FitFont18() {
    return YX_FitFont(18);
}

/** System font 19 */
CG_INLINE UIFont* YX_FitFont19() {
    return YX_FitFont(19);
}

/** System font 20 */
CG_INLINE UIFont* YX_FitFont20() {
    return YX_FitFont(20);
}

/** System font 21 */
CG_INLINE UIFont* YX_FitFont21() {
    return YX_FitFont(21);
}

/** System font 22 */
CG_INLINE UIFont* YX_FitFont22() {
    return YX_FitFont(22);
}

/** System font 23 */
CG_INLINE UIFont* YX_FitFont23() {
    return YX_FitFont(23);
}

/** System font 24 */
CG_INLINE UIFont* YX_FitFont24() {
    return YX_FitFont(24);
}

/** System font 25 */
CG_INLINE UIFont* YX_FitFont25() {
    return YX_FitFont(25);
}

/** System font 26 */
CG_INLINE UIFont* YX_FitFont26() {
    return YX_FitFont(26);
}

/** System font 27 */
CG_INLINE UIFont* YX_FitFont27() {
    return YX_FitFont(27);
}

/** System font 28 */
CG_INLINE UIFont* YX_FitFont28() {
    return YX_FitFont(28);
}

/** System font 29 */
CG_INLINE UIFont* YX_FitFont29() {
    return YX_FitFont(29);
}

/** System font 30 */
CG_INLINE UIFont* YX_FitFont30() {
    return YX_FitFont(30);
}

/** Medium font 30 */
CG_INLINE UIFont* YX_MediumFont(int size) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    } else {
        return [UIFont boldSystemFontOfSize:size];
    }
    
}

#endif /* YXFitFont_h */
