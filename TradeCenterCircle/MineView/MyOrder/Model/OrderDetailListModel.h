//
//  OrderDetailListModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/23.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface OrderDetailListModel : GMQBasicModel

@property(nonatomic,copy) NSString              *shop_id;                    //订单号
@property(nonatomic,copy) NSString              *shop_name;                  //美食名称
@property(nonatomic,copy) NSString              *total_amount;               //总金额
@property(nonatomic,copy) NSString              *payed;                      //实际支付金额
@property(nonatomic,copy) NSString              *discount;                   //满减优惠
@property(nonatomic,copy) NSString              *cost_freight;               //运费
@property(nonatomic,copy) NSString              *cash_coupon_csq_amount;     //优惠券优惠
@property(nonatomic,copy) NSArray               *goods_list;                 //数组

@end
