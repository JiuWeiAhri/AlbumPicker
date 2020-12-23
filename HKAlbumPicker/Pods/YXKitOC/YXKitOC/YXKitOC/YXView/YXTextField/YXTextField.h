//
//  YXTextField.h
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/4.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCountDownButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YXTextFieldType) {
    YXTextFieldType_Custom,
    YXTextFieldType_Phone, /**< 手机号 */
    YXTextFieldType_Password, /**< 密码 */
    YXTextFieldType_MsgCode, /**< 短信验证码 */
    YXTextFieldType_IDCard, /**< 身份证号 */
    YXTextFieldType_Name, /**< 姓名 */
    YXTextFieldType_Mileage_Thousand, /**< 里程万公里 */
    YXTextFieldType_Mileage_VIN, /**< VIN码 */
};

@interface YXTextField : UITextField

@property (nonatomic, copy) NSString *title; /**< 标题名称，例如“手机”、“验证码”、“密码” */
@property (nonatomic, assign) NSUInteger maxLength; /**< 最大长度 */
@property (nonatomic, assign) YXTextFieldType type; /**< 页面类别 */
@property (nonatomic, assign, readonly) YXCountDownButton *countDownButton; /**< 倒计时按钮，仅YXTextFieldType_MsgCode生效 */

/// 输入条件的正则表达式 isEditing编辑中，否是验证条件是否满足
- (NSString *)regularExpression:(BOOL)isEditing;

/// 是否验证通过
- (BOOL)check;

/// 验证不通过错误提示语
- (NSString *)checkErrorMsg;

/** 显示左侧标题 */
- (void)showTitleLabel:(nullable void(^)(UILabel *titleLabel))config;

/** 显示验证码倒计时按钮，仅在type==YXTextFieldType_MsgCode生效 */
- (void)showCountDownBtn:(nullable void(^)(YXCountDownButton *countDownButton))config;

/** 内容发生变化block */
- (void)handleTextFieldChangedBlock:(nullable void(^)(NSString *text))block;

@end

NS_ASSUME_NONNULL_END
