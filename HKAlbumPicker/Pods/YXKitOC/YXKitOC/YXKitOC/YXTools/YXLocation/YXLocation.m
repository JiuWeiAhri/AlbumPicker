//
//  YXLocation.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/6/11.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXLocation.h"
#import "UIViewController+YXAdd.h"

@interface YXLocation () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager; /**< 定位服务 */

@end

@implementation YXLocation

+ (instancetype)shared {
    static YXLocation *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShowAlertAuthorization = YES;
    }
    return self;
}

#pragma mark - Private Func

/** 1:iPhone未开启定位 2:app未开启定位 */
- (void)showErrorAlert:(YXLocationErrorCode)code {
    
    NSDictionary *alertInfo = @{@(YXLocationErrorCode_iPhoneDenied): @"请在设置中打开定位功能",
                              @(YXLocationErrorCode_AppDenied): @"请开启定位服务"};
    NSDictionary *msgInfo = @{@(YXLocationErrorCode_iPhoneDenied): @"iPhone未开启定位功能",
                              @(YXLocationErrorCode_AppDenied): @"App未开启定位服务"};
    
    /** 自动提示去设置更改权限 */
    if (self.isShowAlertAuthorization) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertInfo[@(code)] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (code == 2) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        }];
        [alertController addAction:action];
        [[UIViewController yx_currentVC] presentViewController:alertController animated:YES completion:nil];
    }
    
    if (self.locationErrorBlock) {
        self.locationErrorBlock([NSError errorWithDomain:msgInfo[@(code)] code:code userInfo:nil]);
        self.locationManager.delegate = nil;
        self.locationErrorBlock = nil;
    }
}

- (void)startWithSuccessBlock:(YXLocationSuccessBlock)successBlock errorBlock:(YXLocationErrorBlock)errorBlock {
    
    self.locationSuccessBlock = successBlock;
    self.locationErrorBlock = errorBlock;
    
    /// 判断iPhone定位总开关是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        /// 判断app定位开关是否打开
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            [self showErrorAlert:YXLocationErrorCode_AppDenied];
        } else {
            [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        }
    } else {
        [self showErrorAlert:YXLocationErrorCode_iPhoneDenied];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [manager stopUpdatingLocation];
    if (self.locationSuccessBlock) {
        self.locationSuccessBlock(locations.firstObject.coordinate);
        self.locationManager.delegate = nil;
        self.locationSuccessBlock = nil;
    }
}

/** 代理方法中监听授权的改变,被拒绝有两种情况,一是真正被拒绝,二是服务关闭了 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [manager stopUpdatingLocation];
    if (self.locationErrorBlock) {
        self.locationErrorBlock([NSError errorWithDomain:@"定位失败" code:0 userInfo:nil]);
        self.locationManager.delegate = nil;
        self.locationErrorBlock = nil;
    }
}

#pragma mark - Getter

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0;
    }
    return _locationManager;
}

@end
