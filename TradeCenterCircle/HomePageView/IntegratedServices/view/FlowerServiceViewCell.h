//
//  FlowerServiceViewCell.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/16.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlowerSeverModel.h"

@interface FlowerServiceViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView     *titleImage;          //标题图片
@property(nonatomic,strong)UIView          *lineView;            //分割线
@property(nonatomic,strong)UILabel         *titleLab;            //标题
@property(nonatomic,strong)UILabel         *priceLab;        //价格

@property(nonatomic,strong)UILabel         *specialLab;          //特殊标记
@property(nonatomic,strong)UIImageView     *hotImageView;        //热销标记

@property(nonatomic,strong)UILabel         *selloutLab;          //已售罄


@property(nonatomic,strong) FlowerSeverModel * model ;

-(void)setModel:(FlowerSeverModel *)model ;


@end
