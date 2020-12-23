//
//  YXLocation.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/6/11.
//  Copyright © 2020 张鑫. All rights reserved.
//  -定位经纬度，采用GCJ02(火星坐标-中国国家测绘局)

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXLocationErrorCode) {
    YXLocationErrorCode_Error = 0,
    YXLocationErrorCode_iPhoneDenied = 1,
    YXLocationErrorCode_AppDenied = 2,
};

@interface YXLocation : NSObject

typedef void (^YXLocationSuccessBlock)(CLLocationCoordinate2D locationCoordinate2D);
typedef void (^YXLocationErrorBlock)(NSError *error);

@property (nonatomic, assign) BOOL isShowAlertAuthorization; /**< 是否自动提示未授权，去授权的提示框，默认YES */

@property (nullable, nonatomic, copy) YXLocationSuccessBlock locationSuccessBlock; /**< 定位成功，获取到经纬度Block */
@property (nullable, nonatomic, copy) YXLocationErrorBlock locationErrorBlock; /**< 定位失败Block */

+ (instancetype)shared;

- (void)startWithSuccessBlock:(YXLocationSuccessBlock)successBlock errorBlock:(YXLocationErrorBlock)errorBlock;

@end

NS_ASSUME_NONNULL_END
