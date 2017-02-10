//
//  BaoShiDetailViewController.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/11/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQViewController.h"

#import "UIViewController+YM.h"

@interface BaoShiDetailViewController : GMQViewController<GMQSwitchControllerProtocol>

@property(nonatomic,strong)NSString*style;
-(instancetype)initWithObject:(id)object;

@end
