//
//  OrderDetailAddressCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "OrderDetailAddressCell.h"

@interface OrderDetailAddressCell ()

@end

@implementation OrderDetailAddressCell

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
    //背景图片
    UIImageView *_bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    _bgImageView.image = [UIImage imageNamed:@"order_bg_address"];
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.tag = 10;
    [self.contentView addSubview:_bgImageView];

    //收货人姓名
    UILabel *_nameLab = [[UILabel alloc] init];
    _nameLab.font = [UIFont systemFontOfSize:14.0];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    _nameLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _nameLab.tag = 20;
    [_bgImageView addSubview:_nameLab];

    //收货人电话
    UILabel *_phoneLab = [[UILabel alloc] init];
    _phoneLab.font = [UIFont systemFontOfSize:14.0];
    _phoneLab.textAlignment = NSTextAlignmentLeft;
    _phoneLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _phoneLab.tag = 30;
    [_bgImageView addSubview:_phoneLab];

    //收货人地址
    UILabel *_addressLab = [[UILabel alloc] init];
    _addressLab.font = [UIFont systemFontOfSize:14.0];
    _addressLab.textAlignment = NSTextAlignmentLeft;
    _addressLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _addressLab.tag = 40;
    [_bgImageView addSubview:_addressLab];

    //分割线
    UIView *_lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _lineView.tag = 50;
    [_bgImageView addSubview:_lineView];
}

-(void)refreshCellWithData:(NSDictionary *)model
{
    UIImageView *_bgImageView = (UIImageView *)[self viewWithTag:10];
    UILabel *_nameLab = (UILabel *)[self viewWithTag:20];
    UILabel *_phoneLab = (UILabel *)[self viewWithTag:30];
    UILabel *_addressLab = (UILabel *)[self viewWithTag:40];
    UIView *_lineView = (UIView *)[self viewWithTag:50];
    
    _nameLab.text = [NSString stringWithFormat:@"%@",model[@"ship_name"]];
    _nameLab.frame = CGRectMake(10, 10, [self lableTextHeightWithSting:_nameLab.text and:14.0].width, [self lableTextHeightWithSting:_nameLab.text and:14.0].height);
    
    _phoneLab.text = [NSString stringWithFormat:@"%@",model[@"ship_tel"]];
    _phoneLab.frame = CGRectMake(_nameLab.right + 10, 10, [self lableTextHeightWithSting:_phoneLab.text and:14.0].width, [self lableTextHeightWithSting:_phoneLab.text and:14.0].height);
    
    _addressLab.text = [NSString stringWithFormat:@"%@",model[@"ship_area"]];
    _addressLab.frame = CGRectMake(10, _nameLab.bottom + 5, [self lableTextHeightWithSting:_addressLab.text and:14.0].width, [self lableTextHeightWithSting:_addressLab.text and:14.0].height);
    
    CGFloat height = 10 + [self lableTextHeightWithSting:_nameLab.text and:14.0].height + 5 + [self lableTextHeightWithSting:_addressLab.text and:14.0].height + 10 + 0.5;
    
    _bgImageView.frame = CGRectMake(0, 0, SCREENWIDTH, height);
    
    _lineView.frame = CGRectMake(0, _addressLab.bottom + 10, SCREENWIDTH, 0.5);
}

-(CGFloat)cellHeight:(NSDictionary *)dic
{
    UILabel *_nameLab = (UILabel *)[self viewWithTag:20];
    UILabel *_addressLab = (UILabel *)[self viewWithTag:40];
    
    _nameLab.text = [NSString stringWithFormat:@"%@",dic[@"ship_name"]];
    _addressLab.text = [NSString stringWithFormat:@"%@",dic[@"ship_area"]];
    
    CGFloat height = 10 + [self lableTextHeightWithSting:_nameLab.text and:14.0].height + 5 + [self lableTextHeightWithSting:_addressLab.text and:14.0].height + 10 + 0.5;
    
    return height;
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-20, 999);
    CGSize user_newSize;
    user_newSize = [text boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return user_newSize;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
