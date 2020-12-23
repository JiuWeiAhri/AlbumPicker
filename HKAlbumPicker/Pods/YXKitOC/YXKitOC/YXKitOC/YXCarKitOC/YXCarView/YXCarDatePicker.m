//
//  YXCarDatePicker.m
//  YXKitOC
//
//  Created by zhxin on 2020/11/9.
//  Copyright © 2020 张鑫. All rights reserved.
//  淘车专用，和车有关的时间选择器

#import "YXCarDatePicker.h"
#import "NSDate+YXAdd.h"

@implementation YXCarDatePicker

- (void)setCarViewType:(YXCarDatePickerType)carViewType {
    _carViewType = carViewType;
    
    switch (carViewType) {
        case YXCarDatePickerType_ShangPai: /**< 上牌时间 */
            self.maxLimitDate = [NSDate date];
            self.minLimitDate = [[NSDate date] yx_dateByAddingYears:-20];
            break;
            
        case YXCarDatePickerType_ChuChang: /**< 出厂日期 */
            self.maxLimitDate = [NSDate date];
            break;
            
        default:
            break;
    }
}

@end
