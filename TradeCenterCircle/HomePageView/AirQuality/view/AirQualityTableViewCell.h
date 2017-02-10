//
//  AirQualityTableViewCell.h
//  TradeCenterCircle
//
//  Created by 李阳 on 17/1/4.
//  Copyright © 2017年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirQualityModel.h"

@interface AirQualityTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * addressLab ;

@property(nonatomic,strong) UILabel * degreeLab ;

@property(nonatomic,strong) UILabel * numberLab ;

@property(nonatomic,strong) AirQualityModel * model ;

-(void)setModel:(AirQualityModel *)model ;

@end
