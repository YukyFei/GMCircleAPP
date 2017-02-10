//
//  MyCouponsCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/25.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyCouponsCell.h"

@interface MyCouponsCell ()

@end

@implementation MyCouponsCell

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
    UIImageView *_bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 100)];
    _bgImage.tag = 10;
    [self.contentView addSubview:_bgImage];
    
    //优惠券金额
    UILabel *_priceLab = [[UILabel alloc] init];
    _priceLab.numberOfLines = 1;
    _priceLab.textColor = [UIColor colorWithHexString:@"#770b18"];
    _priceLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Price_size]];
    _priceLab.textAlignment = NSTextAlignmentLeft;
    _priceLab.tag = 20;
    [_bgImage addSubview:_priceLab];

    //分割线
    UIView *_lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    _lineView.tag = 30;
    [_bgImage addSubview:_lineView];

    //优惠券名称
    UILabel *_nameLab = [[UILabel alloc] init];
    _nameLab.numberOfLines = 0;
    _nameLab.textColor = [UIColor colorWithHexString:@"#770b18"];
    _nameLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Title_size]];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    _nameLab.tag = 40;
    [_bgImage addSubview:_nameLab];

    //使用范围
    UILabel *_rangeLab = [[UILabel alloc] init];
    _rangeLab.numberOfLines = 0;
    _rangeLab.textColor = [UIColor colorWithHexString:@"#770b18"];
    _rangeLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_SubTitle_size]];
    _rangeLab.textAlignment = NSTextAlignmentLeft;
    _rangeLab.tag = 50;
    [_bgImage addSubview:_rangeLab];

    //日期
    UILabel *_dateLab = [[UILabel alloc] init];
    _dateLab.numberOfLines = 0;
    _dateLab.textColor = [UIColor colorWithHexString:@"#770b18"];
    _dateLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_SubTitle_size]];
    _dateLab.textAlignment = NSTextAlignmentLeft;
    _dateLab.tag = 60;
    [_bgImage addSubview:_dateLab];
    
    //是否过期
    UIImageView *_overdueImage = [[UIImageView alloc] init];
    _overdueImage.tag = 70;
    _overdueImage.hidden = YES;
    [_bgImage addSubview:_overdueImage];
}
-(void)refreshCellWithModel:(MyCouponsModel *)model
{
    UIImageView *_bgImage = (UIImageView *)[self viewWithTag:10];
    UILabel     *_priceLab = (UILabel *)[self viewWithTag:20];
    UIView      *_lineView = (UIView *)[self viewWithTag:30];
    UILabel     *_nameLab = (UILabel *)[self viewWithTag:40];
    UILabel     *_rangeLab = (UILabel *)[self viewWithTag:50];
    UILabel     *_dateLab = (UILabel *)[self viewWithTag:60];
    UIImageView *_overdueImage = (UIImageView *)[self viewWithTag:70];
    
    _priceLab.text = [NSString stringWithFormat:@"￥ %@",model.money];
    _priceLab.frame = CGRectMake(10, (110-[self lableTextHeightWithSting:_priceLab.text and:[SizeUtility textFontSize:default_Price_size]].height)/2, 110, [self lableTextHeightWithSting:_priceLab.text and:[SizeUtility textFontSize:default_Price_size]].height);
    
    NSMutableAttributedString *attStra = [[NSMutableAttributedString alloc]initWithString:_priceLab.text];
    
    [attStra addAttribute:NSFontAttributeName
     
                    value:[UIFont systemFontOfSize:14.0]
     
                    range:NSMakeRange(0, 1)];
    
    [attStra addAttribute:NSFontAttributeName
     
                    value:[UIFont systemFontOfSize:14.0]
     
                    range:NSMakeRange(_priceLab.text.length-1, 1)];
    
    _priceLab.attributedText = attStra;
    
    _nameLab.text = [NSString stringWithFormat:@"%@",model.name];
    _nameLab.frame = CGRectMake(_priceLab.right + 20, 10, SCREENWIDTH-160, [self lableTextHeightWithSting:_nameLab.text and:[SizeUtility textFontSize:default_Title_size]].height);
    
    _rangeLab.text = [NSString stringWithFormat:@"%@",model.shop_name];
    _rangeLab.frame = CGRectMake(_priceLab.right + 20, _nameLab.bottom + 12,SCREENWIDTH-160, [self lableTextHeightWithSting:_rangeLab.text and:[SizeUtility textFontSize:default_SubTitle_size]].height);
    
    _dateLab.text = [NSString stringWithFormat:@"%@",model.valid_date];
    _dateLab.frame = CGRectMake(_priceLab.right + 20, _rangeLab.bottom + 8, SCREENWIDTH-160, [self lableTextHeightWithSting:_dateLab.text and:[SizeUtility textFontSize:default_SubTitle_size]].height);
    
    CGFloat height = 10 + [self lableTextHeightWithSting:_nameLab.text and:[SizeUtility textFontSize:default_Title_size]].height + 12 + [self lableTextHeightWithSting:_rangeLab.text and:[SizeUtility textFontSize:default_SubTitle_size]].height + 8 + [self lableTextHeightWithSting:_dateLab.text and:[SizeUtility textFontSize:default_SubTitle_size]].height + 10;
    
    _lineView.frame = CGRectMake(110, 10, 0.5, height-20);
    
    _priceLab.frame = CGRectMake(10, (height-[self lableTextHeightWithSting:_priceLab.text and:[SizeUtility textFontSize:default_Price_size]].height)/2, 110, [self lableTextHeightWithSting:_priceLab.text and:[SizeUtility textFontSize:default_Price_size]].height);

    if ([model.status isEqualToString:@"已过期"]) {
         _bgImage.image = [UIImage imageNamed:@"coupon_bg_alreayreceived"];
        _overdueImage.hidden = NO;
        _overdueImage.frame = CGRectMake(SCREENWIDTH-54-20, 0, 54, 45);
        _overdueImage.image = [UIImage imageNamed:@"coupon_tag_alreayoverdue"];
    }else{
        _overdueImage.hidden = YES;
        _bgImage.image = [UIImage imageNamed:@"coupon_bg_receive"];
    }
    
    _bgImage.frame = CGRectMake(10, 0, SCREENWIDTH-20, height);
}

-(CGFloat)cellHeight:(MyCouponsModel *)model
{
    UILabel     *_nameLab = (UILabel *)[self viewWithTag:40];
    UILabel     *_rangeLab = (UILabel *)[self viewWithTag:50];
    UILabel     *_dateLab = (UILabel *)[self viewWithTag:60];
    
    _nameLab.text = [NSString stringWithFormat:@"%@",model.name];
    _rangeLab.text = [NSString stringWithFormat:@"%@",model.shop_name];
    _dateLab.text = [NSString stringWithFormat:@"%@",model.valid_date];
    
    CGFloat height = 10 + [self lableTextHeightWithSting:_nameLab.text and:[SizeUtility textFontSize:default_Title_size]].height + 12 + [self lableTextHeightWithSting:_rangeLab.text and:[SizeUtility textFontSize:default_SubTitle_size]].height + 8 + [self lableTextHeightWithSting:_dateLab.text and:[SizeUtility textFontSize:default_SubTitle_size]].height + 10;
    
    return height;
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-160, 999);
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
