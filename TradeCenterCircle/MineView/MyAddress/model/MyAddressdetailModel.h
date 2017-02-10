//
//  MyAddressdetailModel.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/29.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface MyAddressdetailModel : GMQBasicModel

//"id": "ID",
//"User_id": "用户ID",
//"User_name": "姓名",
//"User_mobile": "电话",
//"status": "是否是默认地址 1 是 2 否 3 删除",
//"User_bulid": "楼宇",
//"User_floor": "楼层",
//"User_address": "详细地址"


//"User_address" = dddddddddd33;
//"User_area" = "";
//"User_bulid" = "4E0F5726-CB1D-495D-8398-47AF93C7E1FE";
//"User_floor" = "296AEB0B-561E-4D6C-B738-DDA9E5C52308";
//"User_id" = 65;
//"User_mobile" = 15512345678;
//"User_name" = dsds;
//id = "02934B12-72ED-4CAD-A12B-8E3D541F2E9E";
//status = 2;

@property(nonatomic,copy) NSString * ID ;

@property(nonatomic,copy) NSString * User_id ;

@property(nonatomic,copy) NSString * User_name ;

@property(nonatomic,copy) NSString * User_mobile ;

@property(nonatomic,copy) NSString * status ;

@property(nonatomic,copy) NSString * User_bulid ;

@property(nonatomic,copy) NSString * User_floor ;

@property(nonatomic,copy) NSString * User_address ;

@property(nonatomic,copy) NSString * User_area ;

@property(nonatomic,copy) NSString * build_name ;

@property(nonatomic,copy) NSString * floor_name ;

@end
