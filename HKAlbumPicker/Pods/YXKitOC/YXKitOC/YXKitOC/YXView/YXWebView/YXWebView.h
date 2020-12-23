//
//  YXWebView.h
//  YXKitOC
//
//  Created by 张鑫 on 2020/7/8.
//  Copyright © 2020 张鑫. All rights reserved.
//

#import <KKJSBridge/KKJSBridge.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXWebView : KKWebView

- (instancetype)initWithFrame:(CGRect)frame cookie:(NSDictionary *)cookie;

@end

NS_ASSUME_NONNULL_END
