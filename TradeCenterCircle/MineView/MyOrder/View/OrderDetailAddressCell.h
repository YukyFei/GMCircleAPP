//
//  OrderDetailAddressCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailAddressCell : UITableViewCell

//数据刷新
-(void)refreshCellWithData:(NSDictionary *)model;

-(CGFloat)cellHeight:(NSDictionary *)dic;

@end
