//
//  MyAddresseViewCell.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/29.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAddressModel.h"

@interface MyAddresseViewCell : UITableViewCell

@property(nonatomic,strong) UIView * bgView ;

@property(nonatomic,strong) UIImageView * bgImg ;

@property(nonatomic,strong) UILabel * nameLab ;

@property(nonatomic,strong) UILabel * buildLab ;

//编辑
@property(nonatomic,strong) UIButton * editBtn ;
//删除
@property(nonatomic,strong) UIButton * deleteBtn ;
//默认地址
@property(nonatomic,strong) UIButton * defaultBtn ;

@property(nonatomic,strong) MyAddressModel * addressmodel ;

-(void)setAddressmodel:(MyAddressModel *)addressmodel ;

-(CGFloat)returnCellHei ;
@end
