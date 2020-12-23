//
//  UIControl+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (YXAdd)

- (void)yx_addEventBlock:(void (^)(id sender))handler;

- (void)yx_addEventBlock:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
