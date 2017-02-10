//
//  DeliciousFoodIndexDetailView.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQViewController.h"

@interface DeliciousFoodIndexDetailView : GMQViewController

@property(nonatomic,copy) NSString *productName;
@property(nonatomic,copy) NSString *productId;
@property(nonatomic,copy) NSString *signStr;

@property(nonatomic,copy) NSString * wailianURL ;


//交互方法
-(void)csqPay:(NSString *)orderId :(int)type ;

-(void)gmqTohome ;

@end
