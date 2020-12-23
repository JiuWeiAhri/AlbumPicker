//
//  YXHUD.m
//  YXKitDemo
//
//  Created by zx on 2018/3/30.
//  Copyright © 2018年 a186f13. All rights reserved.
//

#import "YXHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <pthread.h>

@interface YXHUD()

@property (nonatomic, strong) MBProgressHUD *hud; /**< YXHUD */

@end

@implementation YXHUD

+ (YXHUD *)share {
    static YXHUD *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[YXHUD alloc] init];
    });
    return manager;
}

+ (YXHUD *)shareMessage {
    static YXHUD *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[YXHUD alloc] init];
    });
    return manager;
}

- (YXHUD *)showLoading {
    if (!pthread_main_np()) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoadingFunc];
        });
    } else {
        [self showLoadingFunc];
    }
    return self;
}

- (YXHUD *)showLoadingFunc {
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self.hud];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.minSize = CGSizeMake(100, 100);
    self.hud_wait(NO);
    self.hud.label.text = nil;
    [self.hud showAnimated:YES];
    return self;
}

- (YXHUD *)showMessage:(NSString *)message {
    if (!pthread_main_np()) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessageFunc:message];
        });
    } else {
        [self showMessageFunc:message];
    }
    
    return self;
}

- (YXHUD *)showMessageFunc:(NSString *)message {
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self.hud];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = message;
    self.hud.minSize = CGSizeZero;
    self.hud_wait(NO);
    [self.hud showAnimated:YES];
    self.hud_time(YXHUD_NormalTime);
    
    return self;
}

- (void)hide {
    if (!pthread_main_np()) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hideAnimated:YES];
        });
    } else {
        [self.hud hideAnimated:YES];
    }
}

+ (void)hideInView:(UIView *)view {
    if (!pthread_main_np()) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MBProgressHUD HUDForView:view] hideAnimated:YES];
        });
    } else {
        [[MBProgressHUD HUDForView:view] hideAnimated:YES];
    }
}

#pragma mark - 链式

- (YXHUD * (^)(UIView *))hud_showInView {
    return ^id(UIView *hud_showInView) {
        [hud_showInView addSubview:self.hud];
        return self;
    };
}

- (YXHUD * (^)(BOOL))hud_wait {
    return ^id(BOOL hud_wait) {
        self.hud.userInteractionEnabled = hud_wait;
        self.hud.backgroundView.backgroundColor = hud_wait ? [UIColor colorWithWhite:0 alpha:0.4] : [UIColor clearColor];
        return self;
    };
}

- (YXHUD * (^)(NSTimeInterval))hud_time {
    return ^id(NSTimeInterval hud_time) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.hud hideAnimated:YES afterDelay:hud_time];
        });
        return self;
    };
}

- (YXHUD * (^)(NSString *))hud_title {
    return ^id(NSString *hud_title) {
        self.hud.label.text = hud_title;
        return self;
    };
}

- (YXHUD * (^)(NSString *))hud_descript {
    return ^id(NSString *hud_descript) {
        self.hud.detailsLabel.text = hud_descript;
        return self;
    };
}

#pragma mark - Getter

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
        _hud.removeFromSuperViewOnHide = YES;
        _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _hud.label.textColor = [UIColor whiteColor];
        _hud.minSize = CGSizeMake(100, 100);
        _hud.margin = 12;
        _hud.contentColor = [UIColor whiteColor];
        _hud.label.font = [UIFont systemFontOfSize:16];
        _hud.label.numberOfLines = 0;
    }
    return _hud;
}


@end
