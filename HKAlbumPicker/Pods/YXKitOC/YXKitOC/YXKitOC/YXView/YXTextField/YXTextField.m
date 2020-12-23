//
//  YXTextField.m
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/4.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "YXTextField.h"
#import "UITextField+RYNumberKeyboard.h"
#import "YXRegex.h"
#import "YXColor.h"
#import "UIView+YXFrame.h"
#import "UIView+YXAdd.h"

@interface YXTextField () <UITextFieldDelegate> {
    YXCountDownButton *_countDownButton; /**< 验证码倒计时按钮 */
}

@property (nonatomic, copy) void (^handleTextFieldChangedBlock)(NSString *text); /**< 文本内容发生变化Block */

@end

@implementation YXTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [super addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Public Func

/// 输入条件的正则表达式,第一个是可输入范围的正则，第二个是验证输入结果的正则
- (NSString *)regularExpression:(BOOL)isEditing {
    NSArray *regexs = nil;
    
    switch (self.type) {
        case YXTextFieldType_Phone:
            regexs = @[YXRegex_canInputPhoneNumber11, YXRegex_isPhoneNumber11];
            break;
        case YXTextFieldType_Password:
            regexs = @[@"^[a-zA-Z0-9]{0,99}$", @"^[a-zA-Z0-9]\\w{5,99}$"];
            break;
        case YXTextFieldType_MsgCode:
            regexs = @[YXRegex_canInputMsgCode, YXRegex_isMsgCode];
            break;
        case YXTextFieldType_Mileage_Thousand:
            regexs = @[YXRegex_canInputMeliage, YXRegex_isMeliage];
            break;
        case YXTextFieldType_Mileage_VIN:
            regexs = @[YXRegex_canInputVIN, YXRegex_isVIN];
            
        default:
            break;
    }
    
    return isEditing ? regexs[0] : regexs[1];
}

/// 错误提示语
- (BOOL)check {
    NSString *regex = [self regularExpression:NO];
    NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPass = [prd evaluateWithObject:self.text];
    if (!isPass) {
        NSString *msg = self.title ? [NSString stringWithFormat:@"请检查%@是否输入正确", self.title] : @"请检查是否输入正确";
        return msg;
    }
    return isPass;
}

/// 错误提示语
- (NSString *)checkErrorMsg {
    NSString *regex = [self regularExpression:NO];
    NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPass = [prd evaluateWithObject:self.text];
    if (!isPass) {
        NSString *msg = self.title ? [NSString stringWithFormat:@"请检查%@是否输入正确", self.title] : @"请检查是否输入正确";
        return msg;
    }
    return nil;
}

/** 显示左侧标题 */
- (void)showTitleLabel:(void(^)(UILabel *titleLabel))config {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleLabel.textColor = YX_Color16(0x111111);
    titleLabel.text = self.title;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [titleLabel sizeToFit];
    titleLabel.width += 10;
    
    if (config) {
        config(titleLabel);
    }
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:titleLabel];
    view.width = titleLabel.width;
    view.height = titleLabel.height;
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = view;
}

/** 显示验证码倒计时按钮，仅在type==YXTextFieldType_MsgCode生效 */
- (void)showCountDownBtn:(nullable void(^)(YXCountDownButton *countDownButton))config {
    
    if (self.type != YXTextFieldType_MsgCode) {
        return;
    }
    
    YXCountDownButton *countDownBtn = [[YXCountDownButton alloc] initWithFrame:CGRectMake(0, 0, 90, 26)];
    [countDownBtn setTitleColor:YX_Color16(0x3C7EFF) forState:0];
    countDownBtn.layer.borderColor = YX_Color16(0x3C7EFF).CGColor;
    countDownBtn.layer.borderWidth = 0.5f;
    countDownBtn.layer.masksToBounds = YES;
    countDownBtn.layer.cornerRadius = countDownBtn.height / 2.f;
    _countDownButton = countDownBtn;
    
    if (config) {
        config(countDownBtn);
    }
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:countDownBtn];
    view.width = countDownBtn.width;
    view.height = countDownBtn.height;
    
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = view;
}

/** 内容发生变化block */
- (void)handleTextFieldChangedBlock:(nullable void(^)(NSString *text))block {
    self.handleTextFieldChangedBlock = block;
}

#pragma mark - Private Func

- (void)textFieldChanged:(UITextField *)textField {
    
    /** 显示最长字符 */
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        NSString *text = [self substringWithTextField:textField length:self.maxLength];
        if (text.length) {
            textField.text = text;
        }
    }
    
    /** 禁止输入非法字符 */
    NSString *regex = [self regularExpression:YES];
    if (regex) {
        NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (textField.text.length > 0) {
            for (int i = 1; i <= textField.text.length; i++) {
                NSString *text = [textField.text substringToIndex:i];
                BOOL goon = [prd evaluateWithObject:text];
                if (!goon) {
                    textField.text = [textField.text substringToIndex:i - 1];
                    break;
                }
            }
        }
    }
    
    /** VIN码自动大写 */
    if (self.type == YXTextFieldType_Mileage_VIN) {
        textField.text = [textField.text uppercaseString];
    }
    
    if (self.handleTextFieldChangedBlock) {
        self.handleTextFieldChangedBlock(textField.text);
    }
}

/** 限制中文最大字数 */
- (NSString *)substringWithTextField:(UITextField *)textField length:(NSInteger)length {
    NSString *toBeString = textField.text;
    NSString *lang = textField.textInputMode.primaryLanguage;

    // 简体中文输入，包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > length) {
                return [toBeString substringToIndex:length];
            }
        }
    } else {
        if (toBeString.length > length) {
            return [toBeString substringToIndex:length];
        }
    }
    return nil;
}
#pragma mark - Setter

- (void)setType:(YXTextFieldType)type {
    
    _type = type;
    self.maxLength = NSUIntegerMax;
    
    self.secureTextEntry = type == YXTextFieldType_Password;
    
    switch (type) {
        case YXTextFieldType_Phone:
            self.title = @"手机号";
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.maxLength = 11;
            break;
        case YXTextFieldType_Password:
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.title = @"密码";
            break;
        case YXTextFieldType_MsgCode:
            self.title = @"验证码";
            self.keyboardType = UIKeyboardTypeNumberPad;
            self.maxLength = 6;
            break;
        case YXTextFieldType_IDCard:
            self.title = @"身份证";
            self.ry_inputType = RYIDCardInputType;
            self.maxLength = 18;
            break;
        case YXTextFieldType_Name:
            self.title = @"姓名";
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case YXTextFieldType_Mileage_Thousand:
            self.title = @"行驶里程";
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case YXTextFieldType_Mileage_VIN:
            self.title = @"VIN码";
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
            
        default:
            break;
    }
}

#pragma mark - Getter

- (YXCountDownButton *)countDownButton {
    return _countDownButton;
}

/** 禁止外部更改代理，如果想实现代理内容，请自定义Block，在本类实现delegate后调用block去实现 */
- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    self.delegate = self;
}

@end
