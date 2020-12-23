//
//  UIGestureRecognizer+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (YXAdd)

- (instancetype)yx_initWithActionBlock:(void (^)(id sender))block;

- (void)yx_addActionBlock:(void (^)(id sender))block;

- (void)yx_removeAllActionBlocks;

@end

NS_ASSUME_NONNULL_END
