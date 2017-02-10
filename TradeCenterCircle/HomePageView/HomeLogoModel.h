//
//  HomeLogoModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/17.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface HomeLogoModel : GMQBasicModel

@property(nonatomic,copy)NSString *i_id;      //ID
@property(nonatomic,copy)NSString *icon;      //图标
@property(nonatomic,copy)NSString *name;      //名字
@property(nonatomic,copy)NSString *sort;      //排序
@property(nonatomic,copy)NSString *c_time;    //创建时间
@property(nonatomic,copy)NSString *status;    //发布状态  1发布 2 未发布
@property(nonatomic,copy)NSString *url;       //外链地址/描述
@property(nonatomic,copy)NSString *out_link;  //是否为外链 1 是 2 否
@property(nonatomic,copy)NSString *parent_id; //种类名称

@end
