//
//  NSTimer+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "NSTimer+YXAdd.h"
#import <YYCategories/NSTimer+YYAdd.h>

@implementation NSTimer (YXAdd)

/// 定时器（Block）
+ (NSTimer *)yx_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds block:block repeats:repeats];
}

+ (void)yx_countDown:(NSTimeInterval)second completeBlock:(void(^)(void))complete progressBlock:(void(^)(id time))progress {
    
    __block int timeout = second;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                complete();
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            if(timeout == second) {
                strTime = [NSString stringWithFormat:@"%.2d", timeout];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(strTime);
            });
            
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

@end
