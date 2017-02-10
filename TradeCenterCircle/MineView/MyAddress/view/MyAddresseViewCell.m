//
//  MyAddresseViewCell.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/29.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyAddresseViewCell.h"

@implementation MyAddresseViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor whiteColor] ;
    self.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100*SCREENHEIGHT/667)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
    }

    
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(_bgView), 50)];
               _bgImg.image = [UIImage imageNamed:@"order_bg_address"] ;
        //        - (void)sendSubviewToBack:(UIView *)view;将一个UIView层推送到背后
        //        - (void)bringSubviewToFront:(UIView *)view;将一个UIView显示在最前面
        [self.contentView addSubview:_bgImg];
//        [_bgImg sendSubviewToBack:_buildLab] ;
//        [_buildLab bringSubviewToFront: _bgImg];
//        [_nameLab bringSubviewToFront: _bgImg] ;
    }

    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10*SCREENWIDTH/375, 15*SCREENHEIGHT/667, VIEW_W(_bgView)-30, 20*SCREENHEIGHT/667)];
        _nameLab.numberOfLines = 1;
        _nameLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.textColor = [UIColor colorWithHexString:@"#666666"];
        [_bgImg addSubview:_nameLab];
    }
    
    if (!_buildLab) {
        _buildLab = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_TX(_nameLab), VIEW_BY(_nameLab)+5, VIEW_W(_nameLab), VIEW_H(_nameLab)*2)];
        _buildLab.numberOfLines = 0;
        _buildLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]];
        _buildLab.textAlignment = NSTextAlignmentLeft;
        _buildLab.textColor = [UIColor lightGrayColor];
        [_bgImg addSubview:_buildLab];
        [_bgImg setFrame:CGRectMake(0, 0, VIEW_W(_bgView), VIEW_BY(_buildLab)+10)];
    }
    
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, VIEW_BY(_bgImg)+10, 50*SCREENWIDTH/375, VIEW_H(_nameLab)+5*SCREENHEIGHT/667)];
        _editBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor ;
        _editBtn.layer.borderWidth = 1.0f ;
        _editBtn.titleLabel.textAlignment = NSTextAlignmentCenter ;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal] ;
        _editBtn.tag = 100 ;
         _editBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-1];
        [_bgView addSubview:_editBtn];
    }
    
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_BX(_editBtn)+20, VIEW_TY(_editBtn), VIEW_W(_editBtn), VIEW_H(_editBtn))];
        _deleteBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _deleteBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor ;
        _deleteBtn.layer.borderWidth = 1.0f ;
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
         [_deleteBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal] ;
        _deleteBtn.tag = 101 ;
       _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-1];
        [_bgView addSubview:_deleteBtn];
        
    }
    
    if (!_defaultBtn) {
        _defaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_BX(_deleteBtn)+20, VIEW_TY(_editBtn), VIEW_W(_editBtn)*2, VIEW_H(_editBtn))];
        _defaultBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _defaultBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor ;
        _defaultBtn.layer.borderWidth = 1.0f ;
        _defaultBtn.tag = 102 ;
        _defaultBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-1];
        [_bgView addSubview:_defaultBtn];
    }
    
//    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_BY(_deleteBtn)+12*SCREENHEIGHT/667, SCREENWIDTH, 1)];
//    line.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
//    [_bgView addSubview:line];
    UIView * bootomLine = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_BY(_defaultBtn)+10, SCREENWIDTH, 12*SCREENHEIGHT/667)] ;
    bootomLine.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [_bgView addSubview:bootomLine];
    [_bgView setFrame:CGRectMake(0, 0, SCREENWIDTH, _nameLab.height+_buildLab.height+_editBtn.height+(10+5+1+12+15+5+10)*SCREENHEIGHT/667)];

}

-(CGFloat)returnCellHei
{
    CGFloat cellHei = _nameLab.height+_buildLab.height+_editBtn.height+(10+5+1+12+15+5+10+5)*SCREENHEIGHT/667 ;
    return cellHei ;
}


-(void)setAddressmodel:(MyAddressModel *)addressmodel
{
    _addressmodel = addressmodel ;
    self.nameLab.text = [NSString stringWithFormat:@"%@    %@",addressmodel.User_name ,addressmodel.User_mobile] ;
    self.buildLab.text = addressmodel.address ;
    if ([addressmodel.status isEqualToString:@"1"]) {
        [self.defaultBtn setBackgroundColor:[UIColor redColor]];
        [self.defaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
        self.defaultBtn.layer.cornerRadius = 5 ;
        [self.defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        self.defaultBtn.enabled = NO ;
    }else{
        [self.defaultBtn setBackgroundColor:[UIColor whiteColor]];
        [self.defaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
        [self.defaultBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal] ;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
