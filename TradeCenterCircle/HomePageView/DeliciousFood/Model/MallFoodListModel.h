//
//  MallFoodListModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface MallFoodListModel : GMQBasicModel

@property (nonatomic,copy) NSString *S_logo;       //图片地址
@property (nonatomic,copy) NSString *Shop_id;      //商铺id
@property (nonatomic,copy) NSString *Shop_name;    //商铺名称
@property (nonatomic,copy) NSString *Shop_out;     //是否是外链
@property (nonatomic,copy) NSString *Shop_url;     //外链地址

@end
