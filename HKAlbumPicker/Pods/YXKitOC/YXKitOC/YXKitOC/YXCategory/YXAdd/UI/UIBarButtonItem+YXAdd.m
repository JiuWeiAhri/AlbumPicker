//
//  UIBarButtonItem+YXAdd.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/10.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "UIBarButtonItem+YXAdd.h"
#import <BlocksKit/UIBarButtonItem+BlocksKit.h>
#import <YYCategories/UIBarButtonItem+YYAdd.h>

@implementation UIBarButtonItem (YXAdd)

- (id)yx_initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(void (^)(id sender))action {
    return [self bk_initWithBarButtonSystemItem:systemItem handler:action];
}

- (id)yx_initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(void (^)(id sender))action {
    return [self bk_initWithImage:image style:style handler:action];
}

- (id)yx_initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style handler:(void (^)(id sender))action {
    return [self bk_initWithImage:image landscapeImagePhone:landscapeImagePhone style:style handler:action];
}

- (id)yx_initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(void (^)(id sender))action {
    return [self bk_initWithTitle:title style:style handler:action];
}

- (void)setYX_AddActionBlock:(void (^)(id sender))block {
    self.actionBlock = block;
}

-  (void (^)(id _Nonnull))YX_AddActionBlock {
    return self.actionBlock;
}

@end
