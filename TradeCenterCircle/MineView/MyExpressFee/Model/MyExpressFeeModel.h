//
//  MyExpressFeeModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/26.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface MyExpressFeeModel : GMQBasicModel

@property(nonatomic,copy)NSString     *Order_id;           //订单号
@property(nonatomic,copy)NSString     *Pay_status;         //支付状态
@property(nonatomic,copy)NSString     *Create_time;        //下单时间
@property(nonatomic,copy)NSString     *Pay_money;          //支付金额
@property(nonatomic,copy)NSString     *Pay_name;           //姓名

@end
