//
//  MyCouponsCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/25.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCouponsModel.h"

@interface MyCouponsCell : UITableViewCell

//数据刷新
-(void)refreshCellWithModel:(MyCouponsModel *)model;

-(CGFloat)cellHeight:(MyCouponsModel *)model;

@end
