//
//  NSTimer+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (YXAdd)

/// 定时器，设计时间后执行（Block）
#pragma mark - GCD实现，防止不释放
+ (NSTimer *)yx_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

/// 倒计时
+ (void)yx_countDown:(NSTimeInterval)second completeBlock:(void(^)(void))complete progressBlock:(void(^)(id time))complete;

@end

NS_ASSUME_NONNULL_END
