//
//  FlowerServiceView.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/16.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "FlowerServiceView.h"
CGFloat btnWidth,btnHei,btnfont ;
@implementation FlowerServiceView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    
    return self ;
}

-(void)createUI
{
    NSArray *arr = @[@"综合",@"销量",@"新品上架",@"价格"] ;
    if (SCREENWIDTH == 320) {
        btnWidth = 60 ;
        
        if (self.statis) {
            btnHei = 25 ;
        }else {
            btnHei = 45;
        }
        btnfont = 15 ;
    }else if (SCREENWIDTH == 375){
        btnfont = 16 ;
        if (self.statis){
            btnHei = 30 ;
        }else{
            btnHei = 45;
        }
        
        btnWidth = 80 ;
    }else if (SCREENWIDTH >375){
        
        btnWidth = 100 ;
        if (self.statis){
            btnHei = 35;
        }else{
            btnHei = 45;
        }
        
        btnfont = 17 ;
    }
    
    _allBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(10, 0, btnWidth/2, btnHei) andTag:@"100" andTitle:arr[0]] ;
    [_allBtn setTitleColor:[UIColor colorWithHexString:@"#b6001b"] forState:UIControlStateNormal];
    _allBtn.titleLabel.font = [UIFont systemFontOfSize:btnfont] ;
    [self addSubview:_allBtn];
    _volumeBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(_allBtn)+btnHei-10, VIEW_TY(_allBtn), btnWidth/2, btnHei) andTag:@"101" andTitle:arr[1]] ;
    [self addSubview:_volumeBtn] ;
    [_volumeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _volumeBtn.titleLabel.font = [UIFont systemFontOfSize:btnfont] ;
    _NewProductBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(_volumeBtn)+btnHei-10, VIEW_TY(_allBtn), btnWidth, btnHei) andTag:@"102" andTitle:arr[2]] ;
    [self addSubview:_NewProductBtn] ;
    _NewProductBtn.titleLabel.font = [UIFont systemFontOfSize:btnfont] ;
    [_NewProductBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(_NewProductBtn)+btnHei-10, VIEW_TY(_allBtn), btnWidth/2, btnHei) andTag:@"103" andTitle:arr[3]] ;
    [_priceBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _priceBtn.titleLabel.font = [UIFont systemFontOfSize:btnfont] ;
    //    [_priceBtn setImage:[UIImage imageNamed:@"common_tab_business_n"] forState:UIControlStateNormal];
    //    _priceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 50);
    //    _priceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [self addSubview:_priceBtn];
    _jiantouBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(_priceBtn)-5, (btnHei-28)/2, 31, 28) andTag:@"104" andTitle:Nil] ;
    [_jiantouBtn setImage:[UIImage imageNamed:@"common_btn_descending"] forState:UIControlStateNormal];
    [self addSubview:_jiantouBtn] ;
    
}


@end
