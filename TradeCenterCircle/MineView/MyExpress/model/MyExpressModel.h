//
//  MyExpressModel.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/31.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface MyExpressModel : GMQBasicModel

//"User_id": "用户ID",
//"Order_id": "订单号",
//"Status": "状态",
//"Express_name": "姓名",
//"Express_mobile": "手机号",
//"Express_area": "区域",
//"Express_address": "地址",
//"Express_build": "所属楼宇",
//"Express_floor": "所属楼层",
//"Express_type": "物品类型",
//"Express_destination": "目的地",
//"Express_transport": "空运选项",
//"Express_note": "备注"
@property(nonatomic,copy) NSString * User_id ;
@property(nonatomic,copy) NSString * Order_id ;
@property(nonatomic,copy) NSString * Status ;
@property(nonatomic,copy) NSString * Express_name ;
@property(nonatomic,copy) NSString * Express_mobile ;
@property(nonatomic,copy) NSString * Express_area ;
@property(nonatomic,copy) NSString * Express_address ;
@property(nonatomic,copy) NSString * Express_build ;
@property(nonatomic,copy) NSString * Express_floor ;
@property(nonatomic,copy) NSString * Express_type ;
@property(nonatomic,copy) NSString * Express_destination ;
@property(nonatomic,copy) NSString * Express_transport ;
@property(nonatomic,copy) NSString * Express_note ;

@end
