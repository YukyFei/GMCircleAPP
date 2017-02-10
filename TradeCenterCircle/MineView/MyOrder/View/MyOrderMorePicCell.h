//
//  MyOrderMorePicCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderListModel.h"

typedef void(^OrderStatisBlock)(NSString *orderPrice); //用于回传订单状态

@interface MyOrderMorePicCell : UITableViewCell

-(void)OrderStatisBlock:(OrderStatisBlock)block;

//数据刷新
-(void)refreshCellWithModel:(MyOrderListModel *)model;

-(CGFloat)cellHeight;

@end
