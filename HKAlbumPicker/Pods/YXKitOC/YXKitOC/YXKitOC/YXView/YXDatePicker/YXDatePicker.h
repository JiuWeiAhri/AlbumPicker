//
//  YXDatePicker.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/6/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXDatePickerViewType) {
    YXDatePickerViewType_yyyyMMddHHmm, /**< 年月日时分 */
    YXDatePickerViewType_MMddHHmm, /**< 月日时分 */
    YXDatePickerViewType_yyyyMMdd, /**< 年月日 */
    YXDatePickerViewType_yyyyMM, /**< 年月 */
    YXDatePickerViewType_MMdd, /**< 月日 */
    YXDatePickerViewType_HHmm, /**< 时分 */
    YXDatePickerViewType_yyyy, /**< 年 */
    YXDatePickerViewType_MM, /**< 月 */
    YXDatePickerViewType_ddHHmm, /**< 日时分 */
};

@interface YXDatePicker : NSObject

+ (instancetype)shared;

/**
 *  确定按钮颜色
 */
@property (nonatomic,strong) UIColor *sureButtonColor;
/**
 *  年-月-日-时-分 文字颜色(默认橙色)
 */
@property (nonatomic,strong) UIColor *dateLabelColor;
/**
 *  滚轮日期颜色(默认黑色)
 */
@property (nonatomic,strong) UIColor *datePickerColor;

/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
@property (nonatomic, retain) NSDate *maxLimitDate;
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
@property (nonatomic, retain) NSDate *minLimitDate;

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(YXDatePickerViewType)datePickerStyle completeBlock:(void(^)(NSDate *date))completeBlock;

/**
 滚动到指定的的日期
 */
- (instancetype)initWithDateStyle:(YXDatePickerViewType)datePickerStyle scrollToDate:(NSDate *)scrollToDate completeBlock:(void(^)(NSDate *date))completeBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
