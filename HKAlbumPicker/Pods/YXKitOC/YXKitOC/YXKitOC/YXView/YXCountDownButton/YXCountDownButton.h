//
//  QMCountDownButton.h
//  AppFrame
//
//  Created by edz on 2019/8/30.
//  Copyright © 2019 Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCountDownButton : UIButton
/**
 倒计时结束按钮名称
 */
@property (nonatomic, strong) NSString *finishTitleString;
/**
 是否在倒计时
 */
@property (nonatomic, assign, readonly) BOOL isCountDowning;
/**
 开始倒计时
 */
- (void)startCountDownWith:(int)second;

/**
 停止倒计时，显示结束时按钮名称
 */
- (void)stopCountDown;

@end

NS_ASSUME_NONNULL_END
