//
//  HomeCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeCell : UITableViewCell

//数据刷新
-(void)refreshCellWithModel:(HomeModel *)model;

@end
