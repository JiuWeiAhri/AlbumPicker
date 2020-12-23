//
//  YXButtonMenuView.h
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/1/11.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXButtonMenuView : UIView

@property (nonatomic, strong) NSArray *titles; /**< 标题集合 */
@property (nonatomic, strong) NSArray *images; /**< 图片集合 */
@property (nonatomic, strong) NSArray *imageUrls; /**< 网络图片列表集合 */
@property (nonatomic, assign) NSUInteger rowCount; /**< 每页行数 */
@property (nonatomic, assign) NSUInteger columnsCount; /**< 每页列数 */
@property (nonatomic, strong) UIColor *pageControlColor; /**< 选中页颜色 */
@property (nonatomic, assign) CGSize buttonSize; /**< 按钮Size */

@property (nonatomic, copy) void (^handleClickButtonBlock)(NSInteger index, NSString *title); /**< 点击按钮Block */

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
