//
//  ListCellView.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/11/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicView.h"
typedef void (^listCellBlock)() ;

@interface ListCellView : GMQBasicView


@property(nonatomic,copy)listCellBlock mBlock;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel * subTitle ;
+(instancetype)viewWithFrame:(CGRect)frame andImage:(NSString *)imageName andTitle:(NSString *)title andBlock:(listCellBlock)block;
-(instancetype)initWithViewFrame:(CGRect)frame andImage:(NSString *)imageName andTitle:(NSString *)title andBlock:(listCellBlock)block;

+(instancetype)headViewWithFrame:(CGRect)frame andTitle:(NSString *)title amdSubTitle:(NSString *)subtitle andBlock:(listCellBlock)block ;
-(instancetype)initWithHeadViewFrame:(CGRect)frame andTitle:(NSString *)title andSubTitle:(NSString *)subtitle andBlock:(listCellBlock)block ;


+(instancetype)headViewWithFrame:(CGRect)frame andTitle:(NSString *)title  andBlock:(listCellBlock)block ;
-(instancetype)initWithHeadViewFrame:(CGRect)frame andTitle:(NSString *)title andBlock:(listCellBlock)block ;

+(instancetype)viewWithFramea:(CGRect)frame andImagea:(NSString *)imageName andTitlea:(NSString *)title andBlocka:(listCellBlock)block;
-(instancetype)initWithViewFramea:(CGRect)frame andImagea:(NSString *)imageName andTitlea:(NSString *)title andBlocka:(listCellBlock)block;


@end
