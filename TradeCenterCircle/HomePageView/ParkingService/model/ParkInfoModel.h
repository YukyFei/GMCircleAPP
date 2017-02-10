//
//  ParkInfoModel.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/18.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface ParkInfoModel : GMQBasicModel


@property(nonatomic,copy) NSString * car_id ;
//服务列表id
@property(nonatomic,copy) NSString * s_id ;
//停车图标
@property(nonatomic,copy) NSString * park_pic ;
//汽车图标
@property(nonatomic,copy) NSString * car_pic ;
//停车场名称
@property(nonatomic,copy) NSString * park_name ;
//停车场区域
@property(nonatomic,copy) NSString * park_area ;
//停车场描述
@property(nonatomic,copy) NSString * park_describe ;
@property(nonatomic,copy) NSString * maintitle ;
@property(nonatomic,copy) NSString * subtitle ;

@property(nonatomic,copy) NSString * info_status ;
@property(nonatomic,copy) NSString * sort ;
@property(nonatomic,copy) NSString * ctime ;
@property(nonatomic,copy) NSString * update_time ;



@end
