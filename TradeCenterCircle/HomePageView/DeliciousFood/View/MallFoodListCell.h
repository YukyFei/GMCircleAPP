//
//  MallFoodListCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MallFoodListModel.h"

@interface MallFoodListCell : UITableViewCell

//数据刷新
-(void)refreshCellWithModel:(MallFoodListModel *)model;

@end
