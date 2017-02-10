//
//  MyCouponsModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/25.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface MyCouponsModel : GMQBasicModel

@property(nonatomic,copy) NSString      *money;          //优惠券金额
@property(nonatomic,copy) NSString      *name;           //名称
@property(nonatomic,copy) NSString      *shop_name;      //使用范围
@property(nonatomic,copy) NSString      *valid_date;     //使用期限
@property(nonatomic,copy) NSString      *status;         //状态

@end
