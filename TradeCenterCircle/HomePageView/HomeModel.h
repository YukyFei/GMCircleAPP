//
//  HomeModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/17.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@interface HomeModel : GMQBasicModel

@property(nonatomic,copy)NSString *O_pic;    //图片地址
@property(nonatomic,copy)NSString *O_title;  //标题
@property(nonatomic,copy)NSString *O_url;    //图片外链地址

@end
