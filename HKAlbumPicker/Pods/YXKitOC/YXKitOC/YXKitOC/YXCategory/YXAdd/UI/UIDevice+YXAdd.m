//
//  UIDevice+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "UIDevice+YXAdd.h"
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/sysctl.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <AdSupport/ASIdentifierManager.h>

@implementation UIDevice (YXAdd)

+ (NSString *)yx_getDeviceUserName {
    UIDevice *dev = [self currentDevice];
    return dev.name;
}

+ (NSString *)yx_getDeviceModel {
    UIDevice *dev = [self currentDevice];
    return dev.model;
}

+ (NSString *)yx_getDeviceSystemName {
    UIDevice *dev = [self currentDevice];
    return dev.systemName;
}

+ (NSString *)yx_getDeviceSystemVersion {
    UIDevice *dev = [self currentDevice];
    
    return dev.systemVersion;
}

+ (CGFloat)yx_getDeviceBattery {
    CGFloat batteryLevel=[[UIDevice currentDevice] batteryLevel];
    return batteryLevel;
}

+ (NSString *)yx_getWifiName {
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            //            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

+ (NSString *)yx_getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)yx_getCurrentLocalLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+ (NSInteger)yx_getSignalStrength {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSInteger signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] integerValue];
    
    return signalStrength;
}

+ (NSString *)yx_getIDFV {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (NSString *)yx_getUUID {
    return [[NSUUID UUID] UUIDString];
}

//获得设备型号
+ (NSString *)yx_getCurrentDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone5(GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone5c(GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone5c(GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone5s(GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone5s(GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone6sPlus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhoneSE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone7Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone7Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhoneX";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhoneX";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhoneXR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhoneXS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhoneXSMax";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhoneXSMax";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPodTouch1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPodTouch2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPodTouch3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPodTouch4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPodTouch(5Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad2(WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad2(CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPadMini(WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPadMini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPadMini(GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad3(GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad4(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad4(GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPadAir(WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPadAir(Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPadMini2(WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPadMini2(Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPadMini2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPadMini3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPadMini3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPadMini3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPadMini4(WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPadMini4(LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPadAir2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPadAir2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPadPro9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPadPro9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPadPro12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPadPro12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"AppleTV2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"AppleTV3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"AppleTV3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"AppleTV4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}

+ (NSString *)yx_getIpAddresses{
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) return nil;
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    NSString *ipAddress = [ips objectAtIndex:ips.count - 1];
    return ipAddress;
}

@end
