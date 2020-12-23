//
//  YXDatePicker.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/6/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXDatePicker.h"
#import "WSDatePickerView.h"

@interface YXDatePicker ()

@property (nonatomic, strong) WSDatePickerView *datePickerView; /**< 时间选择器 */

@property (nonatomic, assign) YXDatePickerViewType viewType; /**< 时间UI样式 */

@end

@implementation YXDatePicker

+ (instancetype)shared {
    static YXDatePicker *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        shared.sureButtonColor = [UIColor darkTextColor];
        shared.dateLabelColor = [UIColor darkTextColor];
    });
    return shared;
}

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(YXDatePickerViewType)datePickerStyle scrollToDate:(NSDate *)scrollToDate completeBlock:(void(^)(NSDate *))completeBlock {
    self = [super init];
    if (self) {
        self.viewType = datePickerStyle;
        self.datePickerView = [[WSDatePickerView alloc] initWithDateStyle:(WSDateStyle)datePickerStyle scrollToDate:scrollToDate CompleteBlock:completeBlock];
        [self config];
    }
    return self;
}

- (instancetype)initWithDateStyle:(YXDatePickerViewType)datePickerStyle completeBlock:(void(^)(NSDate *))completeBlock {
    self = [super init];
    if (self) {
        self.viewType = datePickerStyle;
        self.datePickerView = [[WSDatePickerView alloc] initWithDateStyle:(WSDateStyle)datePickerStyle CompleteBlock:completeBlock];
        [self config];
    }
    return self;
}

- (void)config {
    self.datePickerView.hideBackgroundYearLabel = YES;
    self.datePickerView.doneButtonColor = [YXDatePicker shared].sureButtonColor;
    self.datePickerView.dateLabelColor = [YXDatePicker shared].dateLabelColor;
}

- (void)show {
    [self.datePickerView show];
}

#pragma mark - Getter

- (void)setDateLabelColor:(UIColor *)dateLabelColor {
    _dateLabelColor = dateLabelColor;
    self.datePickerView.dateLabelColor = dateLabelColor;
}

- (void)setSureButtonColor:(UIColor *)sureButtonColor {
    _sureButtonColor = sureButtonColor;
    self.datePickerView.doneButtonColor = sureButtonColor;
}

- (void)setDatePickerColor:(UIColor *)datePickerColor {
    _datePickerColor = datePickerColor;
    self.datePickerView.datePickerColor = datePickerColor;
}

- (void)setMaxLimitDate:(NSDate *)maxLimitDate {
    _maxLimitDate = maxLimitDate;
    self.datePickerView.maxLimitDate = maxLimitDate;
}

- (void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    self.datePickerView.minLimitDate = minLimitDate;
}

@end
