//
//  YXButtonMenuView.m
//  CaiYunXiaoKa
//
//  Created by 张鑫 on 2020/1/11.
//  Copyright © 2020 zhxin. All rights reserved.
//

#import "YXButtonMenuView.h"
#import "FMHorizontalMenuView.h"
#import "YXColor.h"
#import "UIView+YXFrame.h"

@interface YXButtonMenuView () <FMHorizontalMenuViewDelegate, FMHorizontalMenuViewDataSource>

@property (nonatomic, strong) FMHorizontalMenuView *menuView; /**< 菜单视图 */

@end

@implementation YXButtonMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.menuView];
    }
    return self;
}

#pragma mark - Public Func

- (void)reloadData {
    self.menuView.height = self.height;
    [self.menuView reloadData];
}

#pragma mark - FMHorizontalMenuViewDataSource

- (NSInteger)numberOfItemsInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView {
    return self.titles.count;
}

- (NSString *)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView titleForItemAtIndex:(NSInteger )index {
    return self.titles[index];
}

- (NSString *)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView localIconStringForItemAtIndex:(NSInteger)index {
    return self.images[index];
}

- (NSURL *)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView iconURLForItemAtIndex:(NSInteger)index {
    return [NSURL URLWithString:self.imageUrls[index]];
}

#pragma mark - FMHorizontalMenuViewDelegate

- (NSInteger)numOfRowsPerPageInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView {
    return self.rowCount > 0 ? self.rowCount : 2;
}

- (NSInteger)numOfColumnsPerPageInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView {
    return self.columnsCount > 0 ? self.columnsCount : 4;
}

- (CGSize)iconSizeForHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView {
    return CGSizeEqualToSize(self.buttonSize, CGSizeZero) ? CGSizeMake(56, 56) : self.buttonSize;
}

- (UIColor *)colorForCurrentPageControlInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView {
    return self.pageControlColor ? : YX_BlueColor();
}

- (void)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView didSelectItemAtIndex:(NSInteger)index {
    if (self.handleClickButtonBlock) {
        self.handleClickButtonBlock(index, self.titles[index]);
    }
}

#pragma mark - Getter

- (FMHorizontalMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[FMHorizontalMenuView alloc] initWithFrame:self.bounds];
        _menuView.delegate = self;
        _menuView.dataSource = self;
    }
    return _menuView;
}

@end
