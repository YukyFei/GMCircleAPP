//
//  AddressManager.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface AddressManager : GMQBasicModel

//全名
@property(nonatomic,copy)NSString *Space_name;
//小区名
@property(nonatomic,copy)NSString *Community_name;
//(1,默认住址，2非默认地址)
@property(nonatomic,copy)NSString *Is_default_space;
//@property(nonatomic,assign)NSInteger is_default_space;
@property(nonatomic,copy)NSString *Space_id;
@property(nonatomic,copy)NSString *Community_id;
//(1,验证通过 2，验证拒绝，3验证中,4;未提交资料)
@property(nonatomic,copy)NSString *Community_valid_status;
@property(nonatomic,copy)NSString * is_default_community;

@property(nonatomic,copy)NSString *Address_valid_status;
@property(nonatomic,copy)NSString *Community_status;


@end
