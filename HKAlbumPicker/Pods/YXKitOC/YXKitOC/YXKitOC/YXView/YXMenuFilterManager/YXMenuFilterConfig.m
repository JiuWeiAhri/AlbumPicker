//
//  YXMenuFilterConfig.m
//  YXKitOC
//
//  Created by zhxin on 2020/8/12.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXMenuFilterConfig.h"
#import "YXColor.h"

@implementation YXMenuFilterConfig

YX_ShareInstance_m(YXMenuFilterConfig)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedTextColor = YX_Color16(0x377DFF);
        self.normalTextColor = YX_Color16(0x111111);
    }
    return self;
}

@end
