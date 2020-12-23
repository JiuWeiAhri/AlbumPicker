//
//  UIImageView+YXAdd.m
//  CaiYunXiaoKa
//
//  Created by zx on 2020/1/4.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "UIImageView+YXAdd.h"
#import "UIImage+YXAdd.m"
#import "UIView+YXAdd.h"

@implementation UIImageView (YXAdd)

+ (instancetype)yx_creatWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.size_yx = image.size;
    return imageView;
}



@end
