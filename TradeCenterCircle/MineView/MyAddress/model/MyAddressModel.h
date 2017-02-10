//
//  MyAddressModel.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/26.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface MyAddressModel : GMQBasicModel
//
//"id": "ID",
//"User_id": "用户ID",
//"User_name": "姓名",
//"User_mobile": "电话",
//"status": "是否是默认地址 1 是 2 否 3 删除",
//"address": "地址"
@property(nonatomic,copy) NSString * ID ;
@property(nonatomic,copy) NSString * User_id ;
@property(nonatomic,copy) NSString * User_name ;
@property(nonatomic,copy) NSString * User_mobile ;
@property(nonatomic,copy) NSString * status ;
@property(nonatomic,copy) NSString * address ;
@end
