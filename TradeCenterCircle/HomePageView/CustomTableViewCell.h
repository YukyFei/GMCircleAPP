//
//  CustomTableViewCell.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel * titleLab ;

+ (instancetype)customTableViewCellWithTableView:(GGCMTView *)cmtView ;
@end
