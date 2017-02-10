//
//  OrderDetailListCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "OrderDetailListCell.h"

@interface OrderDetailListCell ()

@property(nonatomic,strong)OrderDetailListModel *m_model;

@end

@implementation OrderDetailListCell

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
    //平台标题
    UILabel *_titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:16.0];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleLab.tag = 10;
    [self.contentView addSubview:_titleLab];

    //分割线
    UIView *_uplineView = [[UIView alloc] init];
    _uplineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _uplineView.tag = 20;
    [self.contentView addSubview:_uplineView];

    //分割线
    UIView *_uplineViewa = [[UIView alloc] init];
    _uplineViewa.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _uplineViewa.tag = 30;
    [self.contentView addSubview:_uplineViewa];

    //满减
    UILabel *_subtitleLab = [[UILabel alloc] init];
    _subtitleLab.font = [UIFont systemFontOfSize:16.0];
    _subtitleLab.textAlignment = NSTextAlignmentLeft;
    _subtitleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _subtitleLab.tag = 40;
    [self.contentView addSubview:_subtitleLab];

    //分割线
    UIView *_uplineViewb = [[UIView alloc] init];
    _uplineViewb.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _uplineViewb.tag = 50;
    [self.contentView addSubview:_uplineViewb];

    //优惠券优惠
    UILabel *_couponDiscountLab = [[UILabel alloc] init];
    _couponDiscountLab.font = [UIFont systemFontOfSize:16.0];
    _couponDiscountLab.textAlignment = NSTextAlignmentLeft;
    _couponDiscountLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _couponDiscountLab.tag = 60;
    [self.contentView addSubview:_couponDiscountLab];

    //分割线
    UIView *_uplineViewd = [[UIView alloc] init];
    _uplineViewd.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _uplineViewd.tag = 70;
    [self.contentView addSubview:_uplineViewd];

    //运费
    UILabel *_freightLab = [[UILabel alloc] init];
    _freightLab.font = [UIFont systemFontOfSize:16.0];
    _freightLab.textAlignment = NSTextAlignmentLeft;
    _freightLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _freightLab.tag = 80;
    [self.contentView addSubview:_freightLab];

    UIView *_uplineViewc = [[UIView alloc] init];
    _uplineViewc.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _uplineViewc.tag = 90;
    //分割线
    [self.contentView addSubview:_uplineViewc];
}

-(void)refreshCellWithModel:(OrderDetailListModel *)model
{
    UILabel *_titleLab = (UILabel *)[self viewWithTag:10];
    UIView *_uplineView = (UIView *)[self viewWithTag:20];
    UIView *_uplineViewa = (UIView *)[self viewWithTag:30];
    UILabel *_subtitleLab = (UILabel *)[self viewWithTag:40];
    UIView *_uplineViewb = (UIView *)[self viewWithTag:50];
    UILabel *_couponDiscountLab = (UILabel *)[self viewWithTag:60];
    UIView *_uplineViewd = (UIView *)[self viewWithTag:70];
    UILabel *_freightLab = (UILabel *)[self viewWithTag:80];
    UIView *_uplineViewc = (UIView *)[self viewWithTag:90];
    
    self.m_model = model;
    _titleLab.text = [NSString stringWithFormat:@"%@",model.shop_name];
    _titleLab.frame = CGRectMake(10, 0, SCREENWIDTH-20, 50);
    
    _uplineView.frame = CGRectMake(0, 49.5, SCREENWIDTH, 0.5);
    
    CGFloat height = 0;
    
    for (NSInteger i=0; i<model.goods_list.count; i++) {
        
        GoodsView *_goodView = [[GoodsView alloc] initWithFrame:CGRectMake(0, _titleLab.bottom + i*(80), SCREENWIDTH, 80) withDict:model.goods_list[i]];
        _goodView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_goodView];
        
        if (i>=1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLab.bottom + i*(80), SCREENWIDTH, 0.5)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            [self.contentView addSubview:lineView];
        }
        
        
        height = (i+1)*80;
    }
    
    _uplineViewa.frame = CGRectMake(0, _uplineView.bottom + height, SCREENWIDTH, 0.5);
    
    _subtitleLab.text = [NSString stringWithFormat:@"满减优惠：%@元",model.discount];
    _subtitleLab.frame = CGRectMake(10, _uplineView.bottom + height, SCREENWIDTH-20, 50);
    
    _uplineViewb.frame = CGRectMake(0, _subtitleLab.bottom, SCREENWIDTH, 0.5);
    
    _freightLab.text = [NSString stringWithFormat:@"运费：%@元",model.cost_freight];
    
    NSString *discount = [NSString stringWithFormat:@"%@",model.cash_coupon_csq_amount];
    if ([discount isEqualToString:@"0.00"]){
        _freightLab.frame = CGRectMake(10, _subtitleLab.bottom, SCREENWIDTH-20, 50);
        
    }else{
        _couponDiscountLab.text = [NSString stringWithFormat:@"优惠券优惠：%@元",discount];
        _couponDiscountLab.frame = CGRectMake(10, _subtitleLab.bottom, SCREENWIDTH-20, 50);
        
        _uplineViewd.frame = CGRectMake(0, _couponDiscountLab.bottom, SCREENWIDTH, 0.5);
        
        _freightLab.frame = CGRectMake(10, _couponDiscountLab.bottom, SCREENWIDTH-20, 50);
    }
    
    _uplineViewc.frame = CGRectMake(0, _freightLab.bottom - 0.5, SCREENWIDTH, 0.5);
}

-(CGFloat)cellHeight:(OrderDetailListModel *)model
{
    CGFloat m_Height = 0.0;
    NSString *discount = [NSString stringWithFormat:@"%@",model.cash_coupon_csq_amount];
    if ([discount isEqualToString:@"0.00"]){
        m_Height = 0;
    }else{
        m_Height = 50;
    }
    
    CGFloat height = 50 + 80*model.goods_list.count + 50 + 50 + m_Height;
    
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
