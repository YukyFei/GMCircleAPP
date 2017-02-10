//
//  DeliciousFoodIndexCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliciousFoodListModel.h"

@interface DeliciousFoodIndexCell : UITableViewCell

//数据刷新
-(void)refreshCellWithModel:(DeliciousFoodListModel *)model;

@end
