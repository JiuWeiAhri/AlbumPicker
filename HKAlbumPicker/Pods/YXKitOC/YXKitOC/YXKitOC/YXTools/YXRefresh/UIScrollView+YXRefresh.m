//
//  UIScrollView+YXRefresh.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/1/13.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "UIScrollView+YXRefresh.h"
#import <MJRefresh/MJRefresh.h>
#import "YXColor.h"

@implementation UIScrollView (YXRefresh)

#pragma mark - Setter

- (void)setYx_headerRefresh:(void (^)(void))yx_headerRefresh {
    if (yx_headerRefresh) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:yx_headerRefresh];
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header.automaticallyChangeAlpha = YES;
        self.mj_header = header;
    } else {
        self.mj_header = nil;
    }
    
    
}

- (void (^)(void))yx_headerRefresh {
    return self.mj_header.refreshingBlock;
}

- (void)setYx_footerRefresh:(void (^)(void))yx_footerRefresh {
    if (yx_footerRefresh) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:yx_footerRefresh];
        footer.hidden = YES;
        footer.stateLabel.textColor = YX_Color16(0x999999);
        [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
        [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
        self.mj_footer = footer;
    } else {
        self.mj_footer = nil;
    }
}

- (void (^)(void))yx_footerRefresh {
    return self.mj_footer.refreshingBlock;
}

- (BOOL)yx_isRefreshing {
    return [self.mj_header isRefreshing] || [self.mj_footer isRefreshing];
}

- (void)yx_beginRefreshing {
    [self setContentOffset:CGPointZero animated:YES];
    [self.mj_header beginRefreshing];
}

- (void)yx_endRefreshing {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    self.mj_footer.hidden = NO;
}

- (void)yx_endRefreshingWithNoMoreData {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - Setter

- (void)setYx_hideFooterRefresh:(BOOL)yx_hideFooterRefresh {
    self.mj_footer.hidden = yx_hideFooterRefresh;
}

- (void)setYx_hideHeaderRefresh:(BOOL)yx_hideHeaderRefresh {
    self.mj_header.hidden = yx_hideHeaderRefresh;
}

@end
