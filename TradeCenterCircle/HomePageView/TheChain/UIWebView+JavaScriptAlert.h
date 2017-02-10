//
//  UIWebView+JavaScriptAlert.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/11/17.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;

@end
