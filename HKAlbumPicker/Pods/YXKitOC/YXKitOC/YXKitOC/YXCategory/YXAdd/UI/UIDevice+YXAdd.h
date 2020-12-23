//
//  UIDevice+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (YXAdd)

/**
 获取通用 - 关于本机 - 名称
 */
+ (NSString *)yx_getDeviceUserName;
/**
 获取设备类型
 
 @return iPhone/iTouch/iPad
 */
+ (NSString *)yx_getDeviceModel;
/**
 获取系统名称
 */
+ (NSString *)yx_getDeviceSystemName;
/**
 获取设备系统版本
 */
+ (NSString *)yx_getDeviceSystemVersion;

/**
 获取设备电量
 */
+ (CGFloat)yx_getDeviceBattery;

/**
 获取当前连接的WifiName
 */
+ (NSString *)yx_getWifiName;

/**
 获取当前连接 WiFi的ip地址
 */
+ (NSString *)yx_getIPAddress;

/**
 获取手机本地语言
 */
+ (NSString *)yx_getCurrentLocalLanguage;

/**
 获取 WiFi 信号强度
 */
+ (NSInteger)yx_getSignalStrength;

//获取IDFV（常用，同一个证书下的App都被删除后，会变）
+ (NSString *)yx_getIDFV;

//获取UUID
+ (NSString *)yx_getUUID;

//获得设备型号
+ (NSString *)yx_getCurrentDeviceModel;

//获取设备的物理ip地址
+ (NSString *)yx_getIpAddresses;

@end

NS_ASSUME_NONNULL_END
