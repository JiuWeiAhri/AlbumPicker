//
//  YXFilterObject.m
//  YXKitOC
//
//  Created by 李鹏飞 on 2020/6/11.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXFilterObject.h"

@implementation YXFilterObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filterPageIndex = NSNotFound;
    }
    return self;
}

- (NSString *)description {
    return [self yx_modelDescription];
}

@end
