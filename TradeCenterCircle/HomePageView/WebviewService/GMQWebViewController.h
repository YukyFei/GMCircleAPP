//
//  GMQWebViewController.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/16.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQViewController.h"

@class GMQWebView ;
@interface GMQWebViewController : GMQViewController<UIWebViewDelegate>

@property(nonatomic,copy)NSString * webUrl;
@property(nonatomic,strong)GMQWebView *mWebView;

@property(nonatomic,copy) NSString * Webtitle ;
@property(nonatomic,copy) NSString * InPutUrl ;

@property(nonatomic,copy) NSString * wailianURL ;

//交互方法
-(void)csqPay:(NSString *)orderId :(int)type ;

-(void)gmqDataShowError ;

-(void)gmqTohome ;
@end
