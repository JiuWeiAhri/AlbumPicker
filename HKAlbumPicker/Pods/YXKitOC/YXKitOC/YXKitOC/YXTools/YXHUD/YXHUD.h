//
//  YXHUD.h
//  YXKitDemo
//
//  Created by zx on 2018/3/30.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXHUD_Time) {
    YXHUD_ShortTime = 1,
    YXHUD_NormalTime = 2,
    YXHUD_LongTime = 5,
};

@interface YXHUD : NSObject

+ (YXHUD *)share;
+ (YXHUD *)shareMessage;
+ (void)hideInView:(UIView *)view;
- (void)hide;
- (YXHUD *)showLoading;
- (YXHUD *)showMessage:(NSString *)message;

- (YXHUD * (^)(UIView *))hud_showInView;
- (YXHUD * (^)(BOOL isNeedWait))hud_wait;
- (YXHUD * (^)(NSTimeInterval duration))hud_time;
- (YXHUD * (^)(NSString *))hud_title;
- (YXHUD * (^)(NSString *))hud_descript;

@end
