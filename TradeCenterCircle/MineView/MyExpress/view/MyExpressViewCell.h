//
//  MyExpressViewCell.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/16.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyExpressModel.h"

@interface MyExpressViewCell : UITableViewCell

@property(nonatomic,strong)UIView     *bgView;        //背景
@property(nonatomic,strong) UIView * lineView ;       //cell分割线
@property(nonatomic,strong)UILabel    *orderNum;      //订单号
@property(nonatomic,strong)UILabel    *orderStatis;   //订单状态
@property(nonatomic,strong)UILabel    *nameLab;    //姓名
@property(nonatomic,strong)UILabel    *addressLab;     //地址
@property(nonatomic,strong)UILabel    *typeLab;     //类别
@property(nonatomic,strong)UILabel    *commentsLab;      //备注

@property(nonatomic,strong) UIView *  senderLineView ;//分割线

@property(nonatomic,strong) MyExpressModel * model  ;


-(CGFloat)cellHeightWithModel:(MyExpressModel *)model;
-(void)setModel:(MyExpressModel *)model ;

@end
