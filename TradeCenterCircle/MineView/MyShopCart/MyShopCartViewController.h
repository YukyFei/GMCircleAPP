//
//  MyShopCartViewController.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQViewController.h"

@interface MyShopCartViewController : GMQViewController

@property (nonatomic,copy) NSString *signStr;
@property (nonatomic,copy) NSString *differentStr;   //用于区分是从哪个页面过来的

-(void)gmqTohome ;

@end
