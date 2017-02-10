//
//  OrderDetailViewController.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQViewController.h"

@interface OrderDetailViewController : GMQViewController

@property(nonatomic,copy) NSString *signStr; //页面跳转标记
@property(nonatomic,copy) NSString *orderId; //订单id

@end
