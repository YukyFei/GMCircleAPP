//
//  FlowerSeverModel.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/24.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface FlowerSeverModel : GMQBasicModel

//"Product_id":"6",
//"Product_name":"元宵",
//"Product_pic":"/upload/mall/goods/20160812/5f14615696649541a025d3d0f8e0447f_2016_08_12_135629.jpg",
//"Product_sale":"1",
//"Product_hot":2,
//"Product_price":"50.00",
//"Product_store":"500",
//"Product_point":"",
//"Product_note":""

//"Product_id": "商品id",
//"Product_pic": "商品封面",
//"Product_name": "商品名称",
//"Product_sale": "是否售罄1是2否",
//"Product_hot": "是否热卖1是2否",
//"Product_price": "商品价格",
//"Product_store": "剩余库存",
//"Product_point": "商品卖点",
//"Product_note": "保洁服务(文字说明)"
//商品id
@property(nonatomic,copy) NSString * Product_id ;
//商品名称
@property(nonatomic,copy) NSString * Product_name ;
//商品封面
@property(nonatomic,copy) NSString * Product_pic ;
//是否售罄1是2否
@property(nonatomic,copy) NSString * Product_sale ;
//是否热卖1是2否
@property(nonatomic,copy) NSString * Product_hot ;
//商品价格
@property(nonatomic,copy) NSString * Product_price ;
//剩余库存
@property(nonatomic,copy) NSString * Product_store ;
//商品卖点
@property(nonatomic,copy) NSString * Product_point ;
//保洁服务(文字说明)
@property(nonatomic,copy) NSString * Product_note ;


@property(nonatomic,copy) NSString * Product_mktprice ;

//外链
@property(nonatomic,copy) NSString * Product_url ;


@end
