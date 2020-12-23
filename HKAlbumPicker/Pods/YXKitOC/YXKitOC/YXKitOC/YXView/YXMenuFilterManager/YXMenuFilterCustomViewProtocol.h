//
//  YXMenuFilterCustomViewProtocol.h
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/4/3.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXFiltersShowView.h"
#import "NSArray+YXFilterObject.h"

@protocol YXMenuFilterDelegate <NSObject>

@required

/// 已获取该筛选数据
/// @param filterPage 筛选视图
/// @param filterObjects 筛选结果数组
- (void)filterPage:(UIView *)filterPage didSelectedObjects:(NSArray<YXFilterObject *> *)filterObjects;

/// 筛选视图关闭
/// @param contentView 当前筛选视图
- (void)didCloseOfContentFilterView:(UIView *)contentView;

@end


@protocol YXMenuFilterCustomViewProtocol <NSObject>

@required

@property (nonatomic, weak) id<YXMenuFilterDelegate> menuFilterDelegate;
@property (nonatomic, strong) NSArray<YXFilterObject *> *selectedFilterObjects; /**< 已选筛选项集合 */
@property (nonatomic, assign) NSInteger pageIndex; /**< 自定义View的index */

/** 刷新数据 */
- (void)reloadData;

@end


