//
//  UIAlertController+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "UIAlertController+YXAdd.h"
#import "UIViewController+YXAdd.h"
#import "NSString+YXAdd.h"
#import "NSArray+YXAdd.h"
#import "YXDeviceInfo.h"

@interface UIViewController (UACB_Topmost)

- (UIViewController *)uacb_topmost;

@end

@implementation UIAlertController (Blocks)

+ (instancetype)yx_showInViewController:(UIViewController *)viewController
                              withTitle:(NSString *)title
                                message:(NSString *)message
                         preferredStyle:(UIAlertControllerStyle)preferredStyle
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                      otherButtonTitles:(NSArray *)otherButtonTitles
     popoverPresentationControllerBlock:(void(^)(UIPopoverPresentationController *popover))popoverPresentationControllerBlock
                               tapBlock:(YX_ClickBtnBlock)tapBlock
                          customUIBlock:(nullable YX_CustomUIBlock)customUIBlock {
    UIAlertController *strongController = [self alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:preferredStyle];
    
    __weak UIAlertController *controller = strongController;
    
    NSInteger tag = 0;
    
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        NSString *otherButtonTitle = otherButtonTitles[i];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
            if (tapBlock) {
                tapBlock(action.title, i, NO, NO);
            }
        }];
        [controller addAction:otherAction];
        tag++;
    }
    
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
            if (tapBlock) {
                tapBlock(action.title, -1, YES, NO);
            }
        }];
        [controller addAction:cancelAction];
        tag++;
    }
    
    if (destructiveButtonTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction *action){
            if (tapBlock) {
                tapBlock(action.title, -2, NO, YES);
            }
        }];
        [controller addAction:destructiveAction];
        tag++;
    }
    
    if (popoverPresentationControllerBlock) {
        popoverPresentationControllerBlock(controller.popoverPresentationController);
    }
    
    /// 自定义UI
    if (customUIBlock) {
        customUIBlock(controller);
    }
    
    [viewController.uacb_topmost presentViewController:controller animated:YES completion:nil];
    
    return controller;
}

+ (instancetype)yx_showAlertWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                               cancel:(nullable NSString *)cancel
                          destructive:(nullable NSString *)destructive
                               others:(nullable NSArray *)others
                             tapBlock:(nullable YX_ClickBtnBlock)tapBlock
                        customUIBlock:(nullable YX_CustomUIBlock)customUIBlock {
    return [self yx_showInViewController:[UIViewController yx_currentVC]
                               withTitle:title
                                 message:message
                          preferredStyle:UIAlertControllerStyleAlert
                       cancelButtonTitle:cancel
                  destructiveButtonTitle:destructive
                       otherButtonTitles:others
      popoverPresentationControllerBlock:nil
                                tapBlock:tapBlock
                           customUIBlock:customUIBlock];
}

+ (instancetype)yx_showActionSheetWithTitle:(nullable NSString *)title
                                    message:(nullable NSString *)message
                                     cancel:(nullable NSString *)cancel
                                destructive:(nullable NSString *)destructive
                                     others:(nullable NSArray *)others
                                   tapBlock:(nullable YX_ClickBtnBlock)tapBlock
                              customUIBlock:(nullable YX_CustomUIBlock)customUIBlock {
    return [self yx_showInViewController:[UIViewController yx_currentVC]
                               withTitle:title
                                 message:message
                          preferredStyle:UIAlertControllerStyleActionSheet
                       cancelButtonTitle:cancel
                  destructiveButtonTitle:destructive
                       otherButtonTitles:others
      popoverPresentationControllerBlock:nil
                                tapBlock:tapBlock
                           customUIBlock:customUIBlock];
}

/** 显示编辑提示框 */
+ (void)showTextFieldAlertWithTitle:(NSString *)title complete:(void(^)(NSString *inputText))complete {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [@"请输入" stringByAppendingString:title];
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        if (complete) {
            complete([textField.text yx_trimWhitespace].length > 0 ? [textField.text yx_trimWhitespace] : nil);
        }
    }]];
    [[UIViewController yx_currentVC] presentViewController:alertController animated:YES completion:nil];
}

- (void)setYx_titleColor:(UIColor *)yx_titleColor {
    if (!self.title) {
        return;
    }
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:self.title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, self.title.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, self.title.length)];
    [self setValue:alertControllerStr forKey:@"attributedTitle"];
}

- (void)setYx_messageColor:(UIColor *)yx_messageColor {
    if (!self.message) {
        return;
    }
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:self.message];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:yx_messageColor range:NSMakeRange(0, self.message.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, self.message.length)];
    [self setValue:alertControllerMessageStr forKey:@"attributedMessage"];
}

- (void)setYx_cancelColor:(UIColor *)yx_cancelColor {
    [self yx_setButtonColor:yx_cancelColor index:0];
}

- (void)yx_setButtonColor:(UIColor *)color index:(NSInteger)index {
    UIAlertAction *action = [self.actions yx_objectAtSafeIndex:index];
    if (YX_iOSOrLater(8.3)) {
        [action setValue:color forKey:@"titleTextColor"];
    }
}

#pragma mark - Getter & Setter

- (BOOL)visible {
    return self.view.superview != nil;
}

@end

@implementation UIViewController (UACB_Topmost)

- (UIViewController *)uacb_topmost {
    UIViewController *topmost = self;
    
    UIViewController *above;
    while ((above = topmost.presentedViewController)) {
        topmost = above;
    }
    
    return topmost;
}

@end
