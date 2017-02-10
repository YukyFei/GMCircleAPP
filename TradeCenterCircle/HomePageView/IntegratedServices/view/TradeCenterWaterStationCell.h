//
//  TradeCenterWaterStationCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/17.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeCenterWaterStationCell : UITableViewCell

@property(nonatomic,strong)UIImageView     *titleImage;          //标题图片
@property(nonatomic,strong)UIView          *lineView;            //分割线
@property(nonatomic,strong)UILabel         *titleLab;            //标题
@property(nonatomic,strong)UILabel         *salePriceLab;        //减价
@property(nonatomic,strong)UILabel         *specialLab;          //特殊标记
@property(nonatomic,strong)UIImageView     *hotImageView;        //热销标记

@end
