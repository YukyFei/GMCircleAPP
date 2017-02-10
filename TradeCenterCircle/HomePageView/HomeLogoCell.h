//
//  HomeLogoCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeLogoModel.h"

//indexTag-图标tag  titleStr-标题  url-外链地址  parentID-种类名称  outLink-是否为外链
typedef void(^logoTapVCBlock)(NSInteger indexTag ,NSString *titleStr,NSString *url,NSString *parentID,NSString *outLink);

@interface HomeLogoCell : UITableViewCell
{
    int index;
}

-(void)logoTapVCBlock:(logoTapVCBlock)block;

//数据刷新
-(void)refreshCellWithModel:(NSMutableArray *)model;

//返回cell的高度
-(CGFloat)cellHeight:(NSMutableArray *)dic;

@end
