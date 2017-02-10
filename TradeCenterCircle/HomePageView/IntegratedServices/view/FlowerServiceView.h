//
//  FlowerServiceView.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/16.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicView.h"

@interface FlowerServiceView : GMQBasicView

//综合
@property(nonatomic,strong) UIButton * allBtn ;
//销量
@property(nonatomic,strong) UIButton * volumeBtn ;
//新品上架
@property(nonatomic,strong) UIButton * NewProductBtn ;
//价格
@property(nonatomic,strong) UIButton * priceBtn ;
//箭头
@property(nonatomic,strong) UIButton * jiantouBtn ;

//用于标记在哪个视图加载它
@property(nonatomic)BOOL   statis;

-(void)createUI;

@end
