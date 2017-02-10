//
//  HomeLogoCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "HomeLogoCell.h"

@interface HomeLogoCell ()

@property(nonatomic,strong)NSMutableArray       *logoArr;    //存储logo图片

@property(nonatomic,copy)logoTapVCBlock logoTapVCBlock;

@end

@implementation HomeLogoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    
    return self;
}

-(void)refreshCellWithModel:(NSMutableArray *)model
{
    self.logoArr = model;
    
    if ((float)self.logoArr.count/3<=1 && (float)self.logoArr.count>0) {
        index=2;
    }else if ((float)self.logoArr.count/3<=2 && (float)self.logoArr.count>1) {
        index=3;
    }else{
        index = 4;
    }
    //背景图片
    UIView *_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 105*(index-1))];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    //横向分割线
    for (int i = 0; i < index; i++) {
        UIView *_wlineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*105, SCREENWIDTH, 0.5)];
        _wlineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
        [_bgView addSubview:_wlineView];
    }
    
    //竖向分割线
    for (int i = 0; i < 2; i++) {
        UIView *_hlineView = [[UIView alloc] initWithFrame:CGRectMake(((SCREENWIDTH)/3)*i + ((SCREENWIDTH)/3), 0, 0.5, 105*(index-1))];
        _hlineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
        [_bgView addSubview:_hlineView];
    }
    
    float width=50;
    float widthLab=100;
    
    //首页logo按钮
    for (int i=0; i<self.logoArr.count; i++) {
        UIButton *  _titleBtn = [ButtonControl creatButtonWithFrame:CGRectMake((SCREENWIDTH/3-width)/2+(SCREENWIDTH/3)*(i%3)+(i/self.logoArr.count)*SCREENWIDTH, (16+(210 + width -width*3-5)*(i/3%3)), width, width) Text:nil ImageName:nil bgImageName:nil Target:self Action:@selector(btnClick:)];
        [_titleBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,self.logoArr[i][@"icon"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"moren"]];
        _titleBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0, -80, 0);
        _titleBtn.adjustsImageWhenHighlighted = NO;
        _titleBtn.tag = i;
        [_bgView addSubview:_titleBtn];
        
        //首页logo标题
        UILabel * _titleLab = [ButtonControl creatLableWithFrame:CGRectMake((SCREENWIDTH/3-widthLab)/2+(SCREENWIDTH/3)*(i%3)+(i/self.logoArr.count)*SCREENWIDTH, (20 + width +(210 + width -width*3-5)*(i/3%3)), widthLab, 30) Text:self.logoArr[i][@"name"] font:[SizeUtility textFontSize:default_Logo_title_size] TextColor:[UIColor colorWithHexString:@"#5f3f2a"]];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_titleLab];
    }
}

-(CGFloat)cellHeight:(NSMutableArray *)dic
{
    self.logoArr = dic;
    
//    if ((float)self.logoArr.count/3<=1 && (float)self.logoArr.count>0) {
//        index=2;
//    }else if ((float)self.logoArr.count/3<=2 && (float)self.logoArr.count>1) {
//        index=3;
//    }else{
//        index = 4;
//    }
    if (self.logoArr==0) {
        index = 1 ;
    }else{
        if ((float)self.logoArr.count/3<=1 && (float)self.logoArr.count>0) {
            index=2;
        }else if ((float)self.logoArr.count/3<=2 && (float)self.logoArr.count>1) {
            index=3;
        }else{
            index = 4;
        }

    }
    
    
    CGFloat height = 0.0;
    height = 105*(index-1);
    
    return height;
}

-(void)btnClick:(UIButton *)sender
{
    if (self.logoTapVCBlock) {
        self.logoTapVCBlock(sender.tag,self.logoArr[sender.tag][@"name"],self.logoArr[sender.tag][@"url"],self.logoArr[sender.tag][@"parent_id"],self.logoArr[sender.tag][@"out_link"]);
    }
}
-(void)logoTapVCBlock:(logoTapVCBlock)block
{
    _logoTapVCBlock = block;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
