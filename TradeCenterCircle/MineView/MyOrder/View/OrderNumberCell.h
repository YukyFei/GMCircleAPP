//
//  OrderNumberCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/24.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^weiPayBlock)();

@interface OrderNumberCell : UITableViewCell

-(void)weiPayBlock:(weiPayBlock)block;

//数据刷新
-(void)refreshCellWithData:(NSDictionary *)model;

-(CGFloat)cellHeight:(NSDictionary *)model;

@end
