//
//  YXFiltersShowView.m
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/4/3.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXFiltersShowView.h"
#import "YXKitOC.h"

#define kFilterInsertOffSet 5.f
#define kFilterInsertRightOffSet 18.f
#define kFilterHeight 27.f
#define kClearButtonWidth 0.f

#define kFilterSpace 12.f

#define kScrollViewMaxHeight ([UIScreen mainScreen].bounds.size.height / 3.0)

@implementation YXFilterButtonObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filterPageIndex = NSNotFound;
    }
    return self;
}

@end

@interface YXFilter ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy, readwrite) NSString *title;

@end

@implementation YXFilter

#pragma mark - life cycle

- (id)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title              = title;
        self.backgroundColor    = [UIColor whiteColor];
        self.layer.borderColor  = [YX_Color16(0xeeeeee) CGColor];
        self.layer.borderWidth  = 0.5;
        self.layer.cornerRadius = 4.f;
        
        [self addSubview:self.bgImageView];
        [self addSubview:self.titleLabel];
        
        [self loadPage];
    }
    return self;
}

- (void)handleTap {
    
}

- (void)dealloc {
    
}

#pragma mark - loadPage frame

- (void)loadPage {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemMaxWith = screenWidth - kClearButtonWidth - 3 * kFilterSpace;
    
    CGRect titleRect = [self.title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 25.f, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
    
    CGFloat titleLabelWidth = titleRect.size.width;
    CGFloat filterWidth = titleLabelWidth + kFilterInsertOffSet + kFilterInsertRightOffSet;
    
    if (filterWidth >= itemMaxWith) {
        filterWidth = itemMaxWith;
    }
    
    self.titleLabel.frame = CGRectMake(kFilterInsertOffSet, 0, filterWidth - kFilterInsertOffSet - kFilterInsertRightOffSet, kFilterHeight);
    self.titleLabel.text = self.title;
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"YXMenuFilterManager" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:@"image/filtermanager_delete@2x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    self.bgImageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 4, kFilterHeight *0.5 - 4, 8, 8);
    self.bgImageView.image = image;
    self.frame = CGRectMake(0, 0, filterWidth, kFilterHeight);
}

#pragma mark - getter and setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = YX_Color16(0x4c4c4c);
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.backgroundColor = [UIColor clearColor];
    }
    return _bgImageView;
}

@end


@interface YXFiltersShowView ()

@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<YXFilterButtonObject *> *listArray; /**< 数据源 */

@end

@implementation YXFiltersShowView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        {
            self.clipsToBounds = YES;
            self.backgroundColor = [UIColor colorWithRed:241/255.0
                                                   green:241/255.0
                                                    blue:241/255.0
                                                   alpha:1.0];
        }
        {
            [self addSubview:self.scrollView];
        }
    }
    return self;
}

#pragma mark - public method

/// 添加YXFilterButtonObject
- (void)mergeFilterObjects:(NSArray<YXFilterButtonObject *> *)objects {
    //最终添加到showview数据源里面的数据(需要在下面去掉默认选项,例如不限,全部等等 也就是isDefault = YES的)
    NSMutableArray *addObjs = [NSMutableArray array];
    //跟当前选中数组key相同的历史选中的数组
    NSMutableArray *oldObjs = [NSMutableArray array];
    //1.遍历当前选中数组过滤出(去掉默认选项)当前选中数组 2.并且遍历选中历史数组去掉跟当前选中一样key的选项 并且添加当前选中的数组(去掉默认选项后的)
    for (YXFilterButtonObject *selectObj in objects) {
        for (YXFilterButtonObject *oldObj in self.listArray) {
            if ([oldObj.key isEqualToString:selectObj.key] && oldObj.filterPageIndex == selectObj.filterPageIndex) {
                [oldObjs addObject:oldObj];
            }
        }
        //默认选项不参加显示
        if (!selectObj.isDefault && selectObj.title.length > 0) {
            [addObjs addObject:selectObj];
        }
    }
    [self.listArray removeObjectsInArray:oldObjs];
    [self.listArray addObjectsFromArray:addObjs];

}

/// 删除YXFilterObject，并移除关联项
- (void)removeFilterButtonObject:(YXFilterButtonObject *)object {
    
    if (object.relationKeys.count > 0) {
        for (YXFilterButtonObject *temp_object in self.listArray.copy) {
            if ([object.relationKeys containsObject:temp_object.key]) {
                YXFilterButtonObject *key_object = [self filterButtonObjectWithKey:temp_object.key];
                if (key_object.relationKeys.count > 0) {
                    [self removeFilterButtonObject:key_object];
                } else {
                    [self.listArray removeObject:key_object];
                }
            }
        }
        [self.listArray removeObject:object];
    } else {
        [self.listArray removeObject:object];
    }
}

- (YXFilterButtonObject *)filterButtonObjectWithKey:(NSString *)key {
    for (YXFilterButtonObject *object in self.listArray) {
        if ([object.key isEqualToString:key]) {
            return object;
        }
    }
    return nil;
}

- (void)reloadData {
    [self loadData];
}

#pragma mark - re size frame

- (void)loadData {
    
    CGFloat screenWidth = self.frame.size.width;
    CGFloat itemMaxWith = screenWidth - kClearButtonWidth - 3 * kFilterSpace;
    
    self.clearButton.frame = CGRectMake(itemMaxWith + 2 *kFilterSpace, kFilterSpace, kClearButtonWidth, kFilterHeight);
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger filterCount = self.listArray.count;
    
    CGFloat hSpace = kFilterSpace;
    CGFloat vSpace = kFilterSpace;
    
    CGFloat scrollviewHeight = 0;
    
    YXFilter *_preFilter = nil;
    
    for (int i = 0; i < filterCount; i++) {
        
        YXFilterButtonObject *ob = self.listArray[i];
        YXFilter *filter = [[YXFilter alloc] initWithTitle:ob.title];
        
        CGFloat width = filter.frame.size.width;
        CGFloat height = filter.frame.size.height;
        
        if (_preFilter) {
            CGFloat maxOffSetX = CGRectGetMaxX(_preFilter.frame) + width + kFilterSpace;
            if (maxOffSetX > itemMaxWith) {
                hSpace = kFilterSpace;
                vSpace += (kFilterHeight + kFilterSpace);
            }
        }
        
        filter.frame = CGRectMake(hSpace, vSpace, width, height);
        hSpace += (width + kFilterSpace);
        
        if (i == (filterCount - 1)) {
            scrollviewHeight = vSpace + kFilterSpace + kFilterHeight;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didSelectedAtIndex:)];
        filter.userInteractionEnabled = YES;
        filter.tag = i;
        [filter addGestureRecognizer:tap];
        
        [self.scrollView addSubview:filter];
        
        _preFilter = filter;
    }
    
    CGFloat contentHeight = scrollviewHeight;
    
    if (scrollviewHeight > kScrollViewMaxHeight) {
        contentHeight = kScrollViewMaxHeight;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, scrollviewHeight);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, contentHeight);
    self.scrollView.frame = self.bounds;
}

#pragma mark - event handler

- (void)didSelectedAtIndex:(UITapGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    
    NSInteger index = view.tag;
    if ([self.delegate respondsToSelector:@selector(filterDidSelectedAtIndex:)]) {
        [self.delegate filterDidSelectedAtIndex:index];
    }
}

- (void)handleClear {
    if ([self.delegate respondsToSelector:@selector(filterScrollViewClearSelected:)]) {
        [self.delegate filterScrollViewClearSelected:self];
    }
}

#pragma mark - getter and setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.frame = self.bounds;
        _scrollView.showsVerticalScrollIndicator = YES;
    }
    return _scrollView;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.backgroundColor = [UIColor colorWithRed:40/255.0
                                                       green:76/255.0
                                                        blue:133/255.0
                                                       alpha:1.0];
        [_clearButton setTitle:@"清空" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearButton addTarget:self
                         action:@selector(handleClear)
               forControlEvents:UIControlEventTouchUpInside];
        _clearButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _clearButton.layer.cornerRadius = 6.f;
    }
    return _clearButton;
}

- (NSMutableArray<YXFilterButtonObject *> *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

@end
