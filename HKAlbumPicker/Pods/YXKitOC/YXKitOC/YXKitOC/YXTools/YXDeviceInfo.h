//
//  YXSystemInfo.h
//  YXKitDemo
//
//  Created by zx on 2018/3/14.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#ifndef YXDeviceInfo_h
#define YXDeviceInfo_h

#pragma mark - 获取屏幕物理高度

/** 屏幕宽度 */
CG_INLINE CGFloat YX_ScreenW() {
    return [UIScreen mainScreen].bounds.size.width;
}

/** 屏幕高度 */
CG_INLINE CGFloat YX_ScreenH() {
    return [UIScreen mainScreen].bounds.size.height;
}

/** 应用frame 宽度 */
CG_INLINE CGFloat YX_AppW() {
    return [UIScreen mainScreen].applicationFrame.size.width;
}

/** 应用frame 高度 */
CG_INLINE CGFloat YX_AppH() {
    return [UIScreen mainScreen].applicationFrame.size.height;
}

/** 状态栏 高度 */
CG_INLINE CGFloat YX_StatusBar_H() {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

/** 安全区域 顶部高度 */
CG_INLINE CGFloat YX_SafeArea_Top() {
    return [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
}

/** 安全区域 底部高度 */
CG_INLINE CGFloat YX_SafeArea_Bottom() {
    return YX_StatusBar_H() > 20 ? 34 : 0;
}

/** 安全区域 UIViewController刨去SafeTop和SafeBottom */
CG_INLINE CGFloat YX_SafeArea_Body() {
    return YX_ScreenH() - YX_SafeArea_Top() - YX_SafeArea_Bottom();
}

/** 安全区域 UIViewController减去SafeTop和SafeBottom */
CG_INLINE CGRect YX_SafeFrame() {
    return CGRectMake(0, YX_SafeArea_Top(), YX_ScreenW(), YX_ScreenH() - YX_SafeArea_Top() - YX_SafeArea_Bottom());
}

#pragma mark - 屏幕

/** 是否是retina屏幕 */
CG_INLINE CGFloat YX_ScreenScale() {
    return [UIScreen mainScreen].scale;
}

/** 是否是(3.5寸屏幕，iPhone4、4s的屏幕大小) */
CG_INLINE BOOL YX_Screen3_5() {
    return ((YX_ScreenW() == 320.0) && (YX_ScreenH() == 480.0)) ? true : false;
}

/** 是否是最小屏幕(4寸屏幕，iPhone5、5S、SE的屏幕大小) */
CG_INLINE BOOL YX_Screen4_0() {
    return ((YX_ScreenW() == 320.0) && (YX_ScreenH() == 568.0)) ? true : false;
}

/** 是否是最小屏幕(4.7寸屏幕，iPhone6、6s、7、8的屏幕大小) */
CG_INLINE BOOL YX_Screen4_7() {
    return ((YX_ScreenW() == 375.0) && (YX_ScreenH() == 667.0)) ? true : false;
}

/** 是否是最小屏幕(5.5寸屏幕，iPhone6sp、7p、8p的屏幕大小) */
CG_INLINE BOOL YX_Screen5_5() {
    return ((YX_ScreenW() == 414.0) && (YX_ScreenH() == 736.0)) ? true : false;
}

/** 是否是最小屏幕(5.8寸屏幕，iPhoneX、Xs、11Pro的屏幕大小) */
CG_INLINE BOOL YX_Screen5_8() {
    return ((YX_ScreenW() == 375.0) && (YX_ScreenH() == 812.0)) ? true : false;
}

CG_INLINE BOOL YX_Screen6_1() {
    return ((YX_ScreenW() == 414) && (YX_ScreenH() == 896)) ? true : false;
}

/** 是否是最小屏幕(6.5寸屏幕，iPhoneXSMax、11、11ProMax的屏幕大小) */
CG_INLINE BOOL YX_Screen6_5() {
    return ((YX_ScreenW() == 414) && (YX_ScreenH() == 896)) ? true : false;
}

#pragma mark - 版本号

/** App_infoDictionary */
CG_INLINE NSDictionary* YX_AppInfo() {
    return [NSDictionary dictionaryWithDictionary:[NSBundle mainBundle].infoDictionary];
}

/** App_Version */
CG_INLINE NSString* YX_AppVersion() {
    return [NSString stringWithFormat:@"%@", YX_AppInfo()[@"CFBundleShortVersionString"]];
}

/** App_BundleVersion */
CG_INLINE NSString* YX_AppBuild() {
    return [NSString stringWithFormat:@"%@", YX_AppInfo()[@"CFBundleVersion"]];
}

/** IOS_Version */
CG_INLINE NSString* YX_iOSVersion() {
    return [UIDevice currentDevice].systemVersion;
}

/** 是否是iOS指定系统 */
CG_INLINE BOOL YX_iOS(float version) {
    return (([YX_iOSVersion() floatValue] >= version) && ([YX_iOSVersion() floatValue] < (version + 1))) ? true : false;
}

/** IOS_Or_Later */
CG_INLINE BOOL YX_iOSOrLater(float version) {
    return ([YX_iOSVersion() floatValue] >= version) ? true : false;
}

/** Document路径 */
CG_INLINE NSString *YX_Document_Path() {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

/** Library路径 */
CG_INLINE NSString *YX_Library_Path() {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

/** Cache路径 */
CG_INLINE NSString *YX_Cache_Path() {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

/** Tmp路径 */
CG_INLINE NSString *YX_Tmp_Path() {
    return NSTemporaryDirectory();
}

#endif /* YXSystemInfo_h */
