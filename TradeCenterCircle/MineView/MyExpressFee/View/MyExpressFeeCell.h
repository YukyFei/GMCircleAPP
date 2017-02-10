//
//  MyExpressFeeCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyExpressFeeModel.h"

@interface MyExpressFeeCell : UITableViewCell

//数据刷新
-(void)refreshCellWithModel:(MyExpressFeeModel *)model;

-(CGFloat)cellHeight;

@end
