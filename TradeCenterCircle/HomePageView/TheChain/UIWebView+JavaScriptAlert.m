//
//  UIWebView+JavaScriptAlert.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/11/17.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"

@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame {
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [customAlert show];
}

@end
