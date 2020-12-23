//
//  YXCarDatePicker.h
//  YXKitOC
//
//  Created by zhxin on 2020/11/9.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXDatePicker.h"


typedef NS_ENUM(NSUInteger, YXCarDatePickerType) {
    YXCarDatePickerType_ShangPai, /**< 上牌时间 */
    YXCarDatePickerType_ChuChang, /**< 出厂日期 */
};

@interface YXCarDatePicker : YXDatePicker

@property (nonatomic, assign) YXCarDatePickerType carViewType; /**< 页面类别 */

@end
