//
//  PlatformConcessCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "PlatformConcessCell.h"

@interface PlatformConcessCell ()

@end

@implementation PlatformConcessCell

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
    _uplineView.tag = 10;
    [self.contentView addSubview:_uplineView];

    //平台优惠
    UILabel *_titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:16.0];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleLab.tag = 20;
    [self.contentView addSubview:_titleLab];

    //满减优惠
    UILabel *_subtitleLab = [[UILabel alloc] init];
    _subtitleLab.font = [UIFont systemFontOfSize:16.0];
    _subtitleLab.textAlignment = NSTextAlignmentLeft;
    _subtitleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _subtitleLab.tag = 30;
    [self.contentView addSubview:_subtitleLab];

    //优惠券优惠
    UILabel *_couponDiscountLab = [[UILabel alloc] init];
    _couponDiscountLab.font = [UIFont systemFontOfSize:16.0];
    _couponDiscountLab.textAlignment = NSTextAlignmentLeft;
    _couponDiscountLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _couponDiscountLab.tag = 40;
    [self.contentView addSubview:_couponDiscountLab];

    //中分割线
    UIView *_centerlineView = [[UIView alloc] init];
    _centerlineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _centerlineView.tag = 50;
    [self.contentView addSubview:_centerlineView];

    //总价和实际支付
    UILabel *_totalAndPayLab = [[UILabel alloc] init];
    _totalAndPayLab.font = [UIFont systemFontOfSize:16.0];
    _totalAndPayLab.textAlignment = NSTextAlignmentLeft;
    _totalAndPayLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _totalAndPayLab.tag = 60;
    [self.contentView addSubview:_totalAndPayLab];

    //下分割线
    UIView *_downlineView = [[UIView alloc] init];
    _downlineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _downlineView.tag = 70;
    [self.contentView addSubview:_downlineView];
}

-(void)refreshCellWithData:(NSDictionary *)model
{
    UILabel *_titleLab = (UILabel *)[self viewWithTag:20];
    UILabel *_subtitleLab = (UILabel *)[self viewWithTag:30];
    UILabel *_couponDiscountLab = (UILabel *)[self viewWithTag:40];
    UIView *_centerlineView = (UIView *)[self viewWithTag:50];
    UILabel *_totalAndPayLab = (UILabel *)[self viewWithTag:60];
    UIView *_downlineView = (UIView *)[self viewWithTag:70];
    
    _titleLab.text = @"平台优惠";
    _titleLab.frame = CGRectMake(10, 10, SCREENWIDTH-20, [self lableTextHeightWithSting:_titleLab.text and:16.0].height);
    
    _subtitleLab.text = [NSString stringWithFormat:@"满减优惠：%@元",model[@"discount"]];
    _subtitleLab.frame = CGRectMake(10, _titleLab.bottom + 10, SCREENWIDTH-20, [self lableTextHeightWithSting:_subtitleLab.text and:16.0].height);
    
    NSString *discount = [NSString stringWithFormat:@"%@",model[@"cash_coupon_csq_amount"]];

    if ([discount isEqualToString:@"0.00"]) {
       _centerlineView.frame = CGRectMake(0, _subtitleLab.bottom + 10, SCREENWIDTH, 0.5);
    }else{
        _couponDiscountLab.text = [NSString stringWithFormat:@"优惠券优惠：%@元",discount];
        _couponDiscountLab.frame = CGRectMake(10, _subtitleLab.bottom + 10, SCREENWIDTH-20, [self lableTextHeightWithSting:_couponDiscountLab.text and:16.0].height);
        _centerlineView.frame = CGRectMake(0, _couponDiscountLab.bottom + 10, SCREENWIDTH, 0.5);
    }

    _totalAndPayLab.text = [NSString stringWithFormat:@"总价：%@元     实际支付：%@元",model[@"total_amount"],model[@"payed"]];
    _totalAndPayLab.frame = CGRectMake(10, _centerlineView.bottom + 10, SCREENWIDTH-20, [self lableTextHeightWithSting:_totalAndPayLab.text and:16.0].height);
    
    _downlineView.frame = CGRectMake(0, _totalAndPayLab.bottom + 10, SCREENWIDTH, 0.5);
}

-(CGFloat)cellHeight:(NSDictionary *)model
{
    UILabel *_titleLab = (UILabel *)[self viewWithTag:20];
    UILabel *_subtitleLab = (UILabel *)[self viewWithTag:30];
    UILabel *_couponDiscountLab = (UILabel *)[self viewWithTag:40];
    UILabel *_totalAndPayLab = (UILabel *)[self viewWithTag:60];
    
     _titleLab.text = @"平台优惠";
    _subtitleLab.text = [NSString stringWithFormat:@"满减优惠：%@元",model[@"discount"]];
    _couponDiscountLab.text = [NSString stringWithFormat:@"优惠券优惠：%@元",model[@"cash_coupon_csq_amount"]];
    _totalAndPayLab.text = [NSString stringWithFormat:@"总价：%@元     实际支付：%@元",model[@"total_amount"],model[@"payed"]];
    
    CGFloat m_Height = 0.0;
    NSString *discount = [NSString stringWithFormat:@"%@",model[@"cash_coupon_csq_amount"]];
    
    if ([discount isEqualToString:@"0.00"]){
        m_Height = 0;
    }else{
        m_Height = [self lableTextHeightWithSting:_couponDiscountLab.text and:16.0].height + 10;
    }
    
    CGFloat height = 10 + [self lableTextHeightWithSting:_titleLab.text and:16.0].height + 10 + [self lableTextHeightWithSting:_subtitleLab.text and:16.0].height + 10 + 10 + [self lableTextHeightWithSting:_totalAndPayLab.text and:16.0].height + 10 + m_Height;
    
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
