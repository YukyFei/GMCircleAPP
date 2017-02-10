//
//  IntegratedServicesCell.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^logoTapVCBlock)(NSInteger indexTag,NSString *titleStr,NSString *shopID,NSString *Shop_out,NSString *Shop_url);

@interface IntegratedServicesCell : UITableViewCell
{
    int index;
}

@property(nonatomic,strong)UIView        *bgView;     //背景图片
@property(nonatomic,strong)UIButton      *titleBtn;   //首页logo按钮
@property(nonatomic,strong)UILabel       *titleLab;   //首页logo标题
@property(nonatomic,strong)UIView        *wlineView;  //横向分割线
@property(nonatomic,strong)UIView        *hlineView;  //竖向分割线

@property(nonatomic,strong) UILabel      *title;//用于区分进入到的是综合服务还是物流快递

@property(nonatomic,strong)NSMutableArray       *logoArr;    //存储logo图片

@property(nonatomic,copy)logoTapVCBlock logoTapVCBlock;

-(void)logoTapVCBlock:(logoTapVCBlock)block;

//数据刷新
-(void)refreshCellWithModel:(NSMutableArray *)model;

//返回cell的高度
-(CGFloat)cellHeight:(NSMutableArray *)dic;

@end
