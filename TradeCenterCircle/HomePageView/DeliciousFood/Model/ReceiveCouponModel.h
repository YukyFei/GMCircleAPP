//
//  ReceiveCouponModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/9/6.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface ReceiveCouponModel : GMQBasicModel

@property(nonatomic,copy) NSString      *Id;          //优惠券ID
@property(nonatomic,copy) NSString      *money;       //减的钱数
@property(nonatomic,copy) NSString      *full_money;  //满多少元可用
@property(nonatomic,copy) NSString      *validate;    //使用期限
@property(nonatomic,copy) NSString      *s_name;      //店铺名称
@property(nonatomic,copy) NSString      *shop_id;     //店铺id
@property(nonatomic,copy) NSString      *status;      //状态 1已经领取 2未领取

@end
