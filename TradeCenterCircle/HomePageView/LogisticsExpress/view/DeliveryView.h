//
//  DeliveryView.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicView.h"
#import "PlaceholderTextView.h"


@interface DeliveryView : GMQBasicView

@property(nonatomic,strong) UITextField * nameTF ;

@property(nonatomic,strong) UITextField * telTF ;

//楼宇
@property(nonatomic,strong) UIButton * buildBtn ;
@property(nonatomic,strong) UIButton * buiBtn ;
//楼层
@property(nonatomic,strong) UIButton * floorBtn ;
@property(nonatomic,strong) UIButton * flrBtn ;
//详细地址
@property(nonatomic,strong) PlaceholderTextView * detailTF ;
@property(nonatomic,strong) UILabel * placeLab ;

//快递类别
@property(nonatomic,strong) UIButton * typeBtn ;
@property(nonatomic,strong) UIButton * tyBtn ;

//目的地
@property(nonatomic,strong) UIButton * destatBtn ;
@property(nonatomic,strong) UIButton * destBtn ;

//快递方式
@property(nonatomic,strong) UIButton * transportBtn ;
@property(nonatomic,strong) UIButton * tranBtn ;

@property (nonatomic,strong) UILabel * addressLab ;
//想说的
@property(nonatomic,strong) UITextView * sayTF ;
@property(nonatomic,strong) UILabel * saylab ;


@property(nonatomic,strong) UILabel * downcolab ;

-(instancetype)initWithFrame:(CGRect)frame ;

@property(nonatomic,strong) UIButton * submitBtn ;

@end
