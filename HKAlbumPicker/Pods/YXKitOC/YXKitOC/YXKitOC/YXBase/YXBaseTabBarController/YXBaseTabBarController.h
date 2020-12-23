//
//  YXBaseTabBarController.h
//  CaiYunXiaoKa
//
//  Created by zx on 2019/12/29.
//  Copyright © 2019 zhxin. All rights reserved.
//

//自定义图片  title  跳到哪个界面  红色泡泡未读

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXBaseTabBarController : UITabBarController

/** 设置指定tabar 小红点的值 */
- (void)setBadgeValue:(NSString *)badgeValue index:(NSInteger)index;

/** 数组中字典格式@{@"title":@"title1",@"image":@"image1.png",@"selectedImage":@"simage1.png",@"class":xxxVC}
 注:xxxVC是示例对象
 */
- (instancetype)initWithItems:(NSArray *)items;

@end

NS_ASSUME_NONNULL_END
