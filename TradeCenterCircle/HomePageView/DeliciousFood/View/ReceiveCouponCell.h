//
//  ReceiveCouponCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/9/6.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveCouponModel.h"

/**
 * 用于回传领取优惠券按钮响应事件
 **/
typedef void(^receiveCouponBlock)(NSString *ID);

@interface ReceiveCouponCell : UITableViewCell

-(void)receiveCouponBlock:(receiveCouponBlock)block;

//数据刷新
-(void)refreshCellWithModel:(ReceiveCouponModel *)model;

-(CGFloat)cellHeight:(ReceiveCouponModel *)model;

@end
