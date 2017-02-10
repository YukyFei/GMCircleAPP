//
//  CommunityList.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface CommunityList : GMQBasicModel

@property(nonatomic,copy)NSString *Address;
@property(nonatomic,copy)NSString *Community_id;
@property(nonatomic,copy)NSString *Community_name;
@property(nonatomic,copy)NSString *Is_standard_community;
@property(nonatomic,copy)NSString *Lat;
@property(nonatomic,copy)NSString *Lng;

@end
