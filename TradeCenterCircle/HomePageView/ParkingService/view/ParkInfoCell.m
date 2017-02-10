//
//  ParkInfoCell.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "ParkInfoCell.h"
CGFloat parkcellFont ;
@implementation ParkInfoCell

- (void)awakeFromNib {
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI] ;
    }
    return  self ;
}



-(void)createUI
{
    if (SCREENWIDTH<375) {
        parkcellFont =11 ;
    }else if (SCREENWIDTH==375){
        parkcellFont = 12 ;
    }else if(SCREENWIDTH ==414){
        parkcellFont = 13 ;
    }
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
    }

    if (!_lineview) {
        _lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(_bgView), 14*SCREENHEIGHT/667)];
        _lineview.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
        [_bgView addSubview:_lineview];

    }
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, VIEW_BY(_lineview)+15*SCREENHEIGHT/568, 60*SCREENWIDTH/320, 60*SCREENWIDTH/320)];
        _iconImageView.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
        [_bgView addSubview:_iconImageView];

    }
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_BX(_iconImageView)+5, VIEW_TY(_iconImageView)+15, 150*SCREENWIDTH/320, 15*SCREENHEIGHT/568)];
        _nameLab.textAlignment = NSTextAlignmentLeft ;
        _nameLab.font = [UIFont systemFontOfSize:parkcellFont] ;
        [_bgView addSubview:_nameLab] ;

    }if (!_subNameLab) {
        _subNameLab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(_nameLab), VIEW_BY(_nameLab)+2, VIEW_W(self.nameLab), VIEW_H(_nameLab))];
        _subNameLab.font = [UIFont systemFontOfSize:parkcellFont-1] ;
        _subNameLab.textAlignment = NSTextAlignmentLeft ;
        [_bgView addSubview:_subNameLab] ;
    }
    if (!_engNameLab) {
        _engNameLab = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_TX(_nameLab), VIEW_BY(_subNameLab)+2, VIEW_W(_nameLab), VIEW_H(_nameLab))];
        _engNameLab.textAlignment = NSTextAlignmentLeft ;
        _engNameLab.font = [UIFont systemFontOfSize:parkcellFont-1] ;
        [_bgView addSubview:_engNameLab] ;

    }if (!_rightImageView) {
          _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_W(_bgView)-VIEW_W(_iconImageView)-10, VIEW_TY(_subNameLab), VIEW_W(_iconImageView), VIEW_H(_nameLab)*2)];
            _rightImageView.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
            [_bgView addSubview:_rightImageView] ;
    }
    if (!_orline) {
        _orline = [[UIView alloc]initWithFrame:CGRectMake(VIEW_TX(_rightImageView)-50*SCREENWIDTH/320, VIEW_BY(_rightImageView), 40*SCREENWIDTH/320, 1)];
            _orline.backgroundColor = [UIColor orangeColor] ;
            [_bgView addSubview:_orline];
        }
    CGFloat height = _lineview.height +30*SCREENHEIGHT/568+_iconImageView.height ;
    
    _bgView.frame = CGRectMake(0, 0, SCREENWIDTH, height);
    

}


-(CGFloat)cellHeight
{
    CGFloat height = 0.0;

    height = _lineview.height +30*SCREENHEIGHT/568+_iconImageView.height ;
    

    return height;
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-20, 999);
    CGSize user_newSize;
    user_newSize = [text boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return user_newSize;
}

-(void)setParkInModel:(ParkInfoModel *)parkInModel
{

//    @property(nonatomic,strong) UILabel * nameLab ;
//    @property(nonatomic,strong) UILabel * engNameLab ;
//    @property(nonatomic,strong) UILabel * subNameLab ;
    

    _parkInModel = parkInModel ;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,parkInModel.park_pic]]];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,parkInModel.car_pic]]] ;
    self.nameLab.text = parkInModel.park_name ;
    self.subNameLab.text = parkInModel.park_area ;
    self.engNameLab .text = parkInModel.park_describe ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
