//
//  DeliciousFoodListModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/19.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface DeliciousFoodListModel : GMQBasicModel

@property(nonatomic,copy)NSString *Product_id;        //商品id
@property(nonatomic,copy)NSString *Product_pic;       //商品封面
@property(nonatomic,copy)NSString *Product_name;      //商品名称
@property(nonatomic,copy)NSString *Product_mktprice;  //市场价
@property(nonatomic,copy)NSString *Product_sale;      //是否售罄1是2否
@property(nonatomic,copy)NSString *Product_hot;       //是否热卖1是2否
@property(nonatomic,copy)NSString *Product_price;     //商品价格
@property(nonatomic,copy)NSString *Product_store;     //剩余库存
@property(nonatomic,copy)NSString *Product_point;     //商品卖点
@property(nonatomic,copy)NSString *Product_note;      //保洁服务(文字说明)
@property(nonatomic,copy)NSString *Product_url ;      //保洁服务(文字说明)


@end
