//
//  NSDate+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (YXAdd)

@property (readonly) NSInteger yx_halfHour; // 半个小时后的小时
@property (readonly) NSInteger yx_hour; // 当前小时
@property (readonly) NSInteger yx_minute; // 当前分钟
@property (readonly) NSInteger yx_seconds; // 当前秒
@property (readonly) NSInteger yx_day; // 当前天
@property (readonly) NSInteger yx_month; // 当前月份
@property (readonly) NSInteger yx_week; // 月包含的周数。
@property (readonly) NSInteger yx_weekday; // 当前周几（注意！1-7对应日-六，周日为第一天），，
@property (readonly) NSInteger yx_nthWeekday; // 以7天为单位，范围为1-5 （1-7号为第1个7天，8-14号为第2个7天...）
@property (readonly) NSInteger yx_year; // 当前年

#pragma mark - 类方法

/**
 Date转String
 */
- (NSString *)yx_dateToStringWithFormat:(NSString *)format;
/**
 获取当前时间
 */
+ (NSString *)yx_getCurrenTimeWithFormat:(NSString *)format;
/**
 格式UTC时间
 */
+ (NSString *)yx_formatUTCString:(NSString *)utc format:(NSString *)format;
/**
 获取年，例2019
 */
+ (NSString *)yx_getCurrentYear;
/**
 获取月，例07
 */
+ (NSString *)yx_getCurrentMonth;
/**
 获取日，例23
 */
+ (NSString *)yx_getCurrentDay;
/**
 获取当前星期，例星期一
 */
+ (NSString *)yx_getCurrentWeek;
/**
 获取星期，例星期一，周一
 */
- (NSString *)yx_getWeek:(NSString *)prefixString;
/**
 获取中国日期，例 正月初一
 */
+ (NSString *)yx_getCurrentchineseDate;
/**
 明天日期date
 */
+ (NSDate *)yx_dateTomorrow;
/**
 昨天日期date
 */
+ (NSDate *)yx_dateYesterday;
/**
 当天日期后的几天日期date
 */
+ (NSDate *)yx_dateWithDaysFromNow:(NSInteger)days;
/**
 当天日期前的几天日期date
 */
+ (NSDate *)yx_dateWithDaysBeforeNow:(NSInteger)days;
/**
 当天日期后的几小时日期date
 */
+ (NSDate *)yx_dateWithHoursFromNow:(NSInteger)hour;
/**
 当天日期前的几小时日期date
 */
+ (NSDate *)yx_dateWithHoursBeforeNow:(NSInteger)hour;
/**
 当天日期后的几分钟日期date
 */
+ (NSDate *)yx_dateWithMinutesFromNow:(NSInteger)minute;
/**
 当天日期前的几分钟日期date
 */
+ (NSDate *)yx_dateWithMinutesBeforeNow:(NSInteger)minute;

#pragma mark - 实例方法
/**
 标准时，毫秒
 */
- (double)yx_timeIntervalSince1970InMilliSecond;
/**
 当前日期对比另一日期是否相同，对比年月日
 */
- (BOOL)yx_isEqualToDateIgnoringTime:(NSDate *)date;
/**
 当前日期是否为今天
 */
- (BOOL)yx_isToday;
/**
 当前日期是否为明天
 */
- (BOOL)yx_isTomorrow;
/**
 当前日期是否为昨天
 */
- (BOOL)yx_isYesterday;
/**
 当前日期和另一日期是否有相同的周数
 */
- (BOOL)yx_isSameWeekAsDate:(NSDate *)date;
/**
 当前日期是否为本周
 */
- (BOOL)yx_isThisWeek;
/**
 当前日期是否为下一周
 */
- (BOOL)yx_isNextWeek;
/**
 当前日期是否为上一周
 */
- (BOOL)yx_isLastWeek;
/**
 当前日期和另一日期的年月是否有相同
 */
- (BOOL)yx_isSameMonthAsDate:(NSDate *)date;
/**
 当前日期是否为本月
 */
- (BOOL)yx_isThisMonth;
/**
 当前日期和另一日期的年是否相同
 */
- (BOOL)yx_isSameYearAsDate:(NSDate *)date;
/**
 当前日期是否为本年
 */
- (BOOL)yx_isThisYear;
/**
 当前日期是否为下一年
 */
- (BOOL)yx_isNextYear;
/**
 当前日期是否为上一年
 */
- (BOOL)yx_isLastYear;
/**
 当前日期是否在另一日期之前
 */
- (BOOL)yx_isEarlierThanDate:(NSDate *)date;
/**
 当前日期是否在另一日期之后
 */
- (BOOL)yx_isLaterThanDate:(NSDate *)date;
/**
 当前日期是否为未来
 */
- (BOOL)yx_isInFuture;
/**
 当前日期是否为以前
 */
- (BOOL)yx_isInPast;

/**
 当前日期是否是工作日
 */
- (BOOL)yx_isTypicallyWorkday;
/**
 当前日期是否是休息日
 */
- (BOOL)yx_isTypicallyWeekend;

/** 日期计算 */
- (NSDate *)yx_dateByAddingYears:(NSInteger)year;
- (NSDate *)yx_dateByAddingDays:(NSInteger)day;
- (NSDate *)yx_dateBySubtractingDays:(NSInteger)day;
- (NSDate *)yx_dateByAddingHours:(NSInteger)hour;
- (NSDate *)yx_dateBySubtractingHours:(NSInteger)hour;
- (NSDate *)yx_dateByAddingMinutes:(NSInteger)minute;
- (NSDate *)yx_dateBySubtractingMinutes:(NSInteger)minute;
- (NSDate *)yx_dateAtStartOfDay;

- (NSInteger)yx_minutesAfterDate:(NSDate *)date;
- (NSInteger)yx_minutesBeforeDate:(NSDate *)date;
- (NSInteger)yx_hoursAfterDate:(NSDate *)date;
- (NSInteger)yx_hoursBeforeDate:(NSDate *)date;
- (NSInteger)yx_daysAfterDate:(NSDate *)date;
- (NSInteger)yx_daysBeforeDate:(NSDate *)date;
- (NSInteger)yx_distanceInDaysToDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
