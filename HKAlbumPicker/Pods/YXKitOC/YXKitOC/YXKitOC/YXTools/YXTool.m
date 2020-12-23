//
//  YXTool.m
//  YXKitOC
//
//  Created by 张鑫 on 2020/7/6.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import "YXTool.h"

@implementation YXTool

/** 拨打电话 */
+ (void)callPhone:(NSString *)phone {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", phone];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

@end
