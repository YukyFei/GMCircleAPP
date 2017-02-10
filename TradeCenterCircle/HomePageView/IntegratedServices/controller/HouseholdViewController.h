//
//  HouseholdViewController.h
//  TradeCenterCircle
//
//  Created by 张广义 on 2016/11/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMQViewController.h"
@interface HouseholdViewController : GMQViewController

@property(nonatomic,copy)NSString *titleName;


@property(nonatomic,copy)NSString *cellTitle;
@property(nonatomic,copy)NSString *Is_standard_community;
@property(nonatomic,copy)NSString *Community_id;
@property(nonatomic,copy)NSString *user_id;

@property(nonatomic,assign) BOOL isFromSelected ;

@end
