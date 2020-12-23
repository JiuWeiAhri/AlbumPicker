//
//  CA_NoDataView.m
//  ChongAi
//
//  Created by GreatTree on 16/8/15.
//  Copyright © 2016年 GreatTree. All rights reserved.
//

#import "YXNoDataView.h"
#import "UIView+YXAdd.h"
#import "YXColor.h"
#import "YXFont.h"
#import <Masonry/Masonry.h>

@implementation YXNoDataViewConfig

YX_ShareInstance_m(YXNoDataViewConfig)

@end


@interface YXNoDataView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation YXNoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatView];
    }
    return self;
}

- (void)creatView {
    
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textLabel.mas_top).offset(-15);
        make.centerX.equalTo(self);
    }];
    
    self.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Public Func

- (void)handleClick:(ClickBlock)block {
    self.block = block;
}

#pragma mark - TabGestureRecognizer

- (void)tapHandle:(id)sender {
    
    if (self.block) {
        self.block();
    }
}

#pragma mark - Setter

- (void)setType:(YXNoDataViewType)type {
    
    if (_type == type) {
        return;
    }
    
    _type = type;
    
    switch (type) {
        case YXNoDataViewTypeNoData: {
            self.textLabel.text = @"暂无数据";
            self.imageView.image = YXNoDataViewConfig.sharedYXNoDataViewConfig.noDataImage;
            break;
        }
        case YXNoDataViewTypeNoNet: {
            self.textLabel.text = @"请检查您的网络是否开启";
            self.imageView.image = YXNoDataViewConfig.sharedYXNoDataViewConfig.noNetImage;
            break;
        }
        case YXNoDataViewTypeNoService: {
            self.textLabel.text = @"请求失败，请稍后重试";
            self.imageView.image = YXNoDataViewConfig.sharedYXNoDataViewConfig.errorImage;
            break;
        }
    }
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.textLabel.text = message;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    
    [self yx_removeAllSubviews];
    [self addSubview:customView];
    [customView yx_alignmentCenter];
}

#pragma mark - Getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        UIImage *image = YXNoDataViewConfig.sharedYXNoDataViewConfig.noDataImage;
        _imageView.image = image;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(image.size.width));
            make.height.equalTo(@(image.size.height));
        }];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"暂无数据";
        _textLabel.textColor = YX_Color16(0xaaaaaa);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = YX_Font15();
    }
    return _textLabel;
}

@end
