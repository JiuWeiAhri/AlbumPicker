//
//  YXBaseCell.m
//  YXKitOC
//
//  Created by zhxin on 2020/8/19.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXBaseCell.h"
#import "YXColor.h"

@implementation YXBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBaseCellBackgroundView];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBaseCellBackgroundView];
    }
    return self;
}

#pragma mark - Private Func

- (void)setBaseCellBackgroundView {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = YX_GroupTableViewBackgroundColor();
    self.selectedBackgroundView = bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
