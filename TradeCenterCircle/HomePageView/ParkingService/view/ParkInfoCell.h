//
//  ParkInfoCell.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkInfoModel.h"


@interface ParkInfoCell : UITableViewCell


@property(nonatomic,strong) UIView * bgView ;
@property(nonatomic,strong) UIView * lineview ;

@property(nonatomic,strong) UIImageView * iconImageView  ;
@property(nonatomic,strong) UILabel * nameLab ;
@property(nonatomic,strong) UILabel * engNameLab ;
@property(nonatomic,strong) UILabel * subNameLab ;

@property(nonatomic,strong) UIImageView * rightImageView  ;
@property(nonatomic,strong) UIView * orline ;
@property(nonatomic,strong) ParkInfoModel * parkInModel ;


-(CGFloat)cellHeight;
-(void)setParkInModel:(ParkInfoModel *)parkInModel ;

@end
