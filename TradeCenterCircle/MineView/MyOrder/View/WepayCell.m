//
//  WepayCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "WepayCell.h"

@interface WepayCell ()

@end

@implementation WepayCell

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
    //上分割线
    UIView *_uplineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    _uplineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.contentView addSubview:_uplineView];

    //微信图标
    UIImageView *_logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, (50-20)/2, 20, 20)];
    _logoImage.image = [UIImage imageNamed:@"order_icon_wechat"];
    [self.contentView addSubview:_logoImage];

    //标题
    UILabel *_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10 + _logoImage.right, 0, SCREENWIDTH-20, 50)];
    _titleLab.text = @"微信支付";
    _titleLab.font = [UIFont systemFontOfSize:14.0];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_titleLab];

    //微信支付是否选择
    UIButton * _selectBtn = [ButtonControl creatButtonWithFrame:CGRectMake(SCREENWIDTH - 10 - 20, (50-20)/2, 20, 20) Text:nil ImageName:nil bgImageName:nil Target:self Action:nil];
    [_selectBtn setImage:[UIImage imageNamed:@"order_selected"] forState:UIControlStateNormal];
    [self.contentView addSubview:_selectBtn];
    _selectBtn.adjustsImageWhenHighlighted = NO;

    //下分割线
    UIView *_downlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREENWIDTH, 0.5)];
    _downlineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.contentView addSubview:_downlineView];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
