//
//  MyOrderListModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface MyOrderListModel : GMQBasicModel

@property(nonatomic,copy) NSString  *order_id;       //订单号
@property(nonatomic,copy) NSString  *status;         //订单状态
@property(nonatomic,copy) NSString  *actmoney;       //实付款
@property(nonatomic,copy) NSArray   *goods;          //图片数组
@property(nonatomic,copy) NSArray   *pay_status;     //支付状态   0是未支付  1是已支付 2是已支付待确认

@end
