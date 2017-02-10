//
//  MineCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCell : UITableViewCell

@property(nonatomic,strong)UIImageView   *arrowImage; //箭头
@property(nonatomic,strong)UILabel       *titleLab;   //标题
@property(nonatomic,strong)UIView        *lineView;   //分割线

@end
