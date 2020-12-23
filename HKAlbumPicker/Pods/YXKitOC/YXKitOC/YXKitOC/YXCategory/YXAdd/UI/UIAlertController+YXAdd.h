//
//  UIAlertController+YXAdd.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YX_CustomUIBlock) (UIAlertController *alertVC);

typedef void (^YX_ClickBlock) (void);
typedef void (^YX_ClickPopBtnBlock) (NSString *selectedTitle, NSInteger selectedIndex);
typedef void (^YX_ClickBtnBlock) (NSString *selectedTitle, NSInteger selectedIndex, BOOL isCancel, BOOL isDestructive);
typedef void (^YX_MenuBtnBlock) (NSInteger selectedIndex);

@interface UIAlertController (YXAdd)

@property (nonatomic, strong) UIColor *yx_titleColor; /**< 标题颜色 */
@property (nonatomic, strong) UIColor *yx_messageColor; /**< 描述颜色 */
@property (nonatomic, strong) UIColor *yx_cancelColor; /**< 取消按钮颜色（iOS8.3及以上） */
@property (readonly, nonatomic) BOOL yx_visible; /**< 是否正在显示 */

+ (instancetype)yx_showMenuWithSourceView:(UIView *)sourceView
                               sourceRect:(NSString *)sourceRect
                                  buttons:(NSArray *)buttons
                                 tapBlock:(YX_MenuBtnBlock)tapBlock;

+ (instancetype)yx_showAlertWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                               cancel:(nullable NSString *)cancel
                          destructive:(nullable NSString *)destructive
                               others:(nullable NSArray *)others
                             tapBlock:(nullable YX_ClickBtnBlock)tapBlock
                        customUIBlock:(nullable YX_CustomUIBlock)customUIBlock;

+ (instancetype)yx_showActionSheetWithTitle:(nullable NSString *)title
                                    message:(nullable NSString *)message
                                     cancel:(nullable NSString *)cancel
                                destructive:(nullable NSString *)destructive
                                     others:(nullable NSArray *)others
                                   tapBlock:(nullable YX_ClickBtnBlock)tapBlock
                              customUIBlock:(nullable YX_CustomUIBlock)customUIBlock;

/** 显示编辑提示框，自动去除前后空格，不能输入纯空格 */
+ (void)showTextFieldAlertWithTitle:(NSString *)title complete:(void(^)(NSString *inputText))complete;


/// 设置按钮颜色（iOS8.3及以上）
- (void)yx_setButtonColor:(UIColor *)color index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
