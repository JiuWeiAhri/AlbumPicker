//
//  YXTextView.h
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/2/2.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager/IQTextView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXTextView : IQTextView

@property(nullable, nonatomic,copy) IBInspectable NSString *placeholder;

@property(nullable, nonatomic,copy) IBInspectable NSAttributedString *attributedPlaceholder;

@property(nullable, nonatomic,copy) IBInspectable UIColor *placeholderTextColor;

@end

NS_ASSUME_NONNULL_END
