//
//  DeliciousFoodCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明block，用于传递按钮tag标识indexTag   与按钮标题文字titleStr
typedef void(^logoTapVCBlock)(NSInteger indexTag,NSString *titleStr);

@interface DeliciousFoodCell : UITableViewCell

-(void)logoTapVCBlock:(logoTapVCBlock)block;

//数据刷新
-(void)refreshCellWithModel:(NSMutableArray *)model;

//返回cell的高度
-(CGFloat)cellHeight:(NSMutableArray *)dic;

@end
