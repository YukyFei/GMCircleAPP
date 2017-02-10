//
//  OrderDetailListCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailListModel.h"
#import "GoodsView.h"

@interface OrderDetailListCell : UITableViewCell

//数据刷新
-(void)refreshCellWithModel:(OrderDetailListModel *)model;

-(CGFloat)cellHeight:(OrderDetailListModel *)model;

@end
