//
//  DeliciousFoodIndexCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "DeliciousFoodIndexCell.h"

@interface DeliciousFoodIndexCell ()

@end

@implementation DeliciousFoodIndexCell

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
    //标题图片
    UIImageView *_titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 75)];
    _titleImage.tag = 10;
    [self.contentView addSubview:_titleImage];
 
    //热点标识
    UIImageView *_hotImageView = [[UIImageView alloc] init];
    _hotImageView.frame = CGRectMake(0, 0, 20, 20);
    _hotImageView.image = [UIImage imageNamed:@"common_icon_hot"];
    _hotImageView.tag = 20;
    [_titleImage addSubview:_hotImageView];
    _hotImageView.hidden = YES;

    //分割线
    UIView *_lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 94.5, SCREENWIDTH, 0.5)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.contentView addSubview:_lineView];

    //标题
    UILabel *_titleLab = [[UILabel alloc] init];
    _titleLab.numberOfLines = 0;
    _titleLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_FoodIndex_title_size]];
    _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleLab.tag = 30;
    [self.contentView addSubview:_titleLab];

    //打折后的价钱
    UILabel *_salePriceLab = [[UILabel alloc] init];
    _salePriceLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_FoodIndex_title_size]];
    _salePriceLab.textColor = [UIColor colorWithHexString:@"#f15353"];
    _salePriceLab.tag = 40;
    [self.contentView addSubview:_salePriceLab];

    //原价
    UILabel *_normalPriceLab = [[UILabel alloc] init];
    _normalPriceLab.font = [UIFont systemFontOfSize:10.0];
    _normalPriceLab.textColor = [UIColor lightGrayColor];
    _normalPriceLab.tag = 50;
    [self.contentView addSubview:_normalPriceLab];
    _normalPriceLab.hidden = YES;

    UIView *_normallineView = [[UIView alloc] init];
    _normallineView.backgroundColor = [UIColor lightGrayColor];
    _normallineView.tag = 60;
    [self.contentView addSubview:_normallineView];
    _normallineView.hidden = YES;

    //商品卖点标识
    UILabel *_specialLab = [[UILabel alloc] init];
    _specialLab.font = [UIFont boldSystemFontOfSize:10.0];
    _specialLab.textColor = [UIColor whiteColor];
    _specialLab.textAlignment = NSTextAlignmentCenter;
    _specialLab.backgroundColor = [UIColor redColor];
    _specialLab.layer.cornerRadius = 2.0;
    _specialLab.layer.masksToBounds = YES;
    _specialLab.tag = 70;
    [self.contentView addSubview:_specialLab];
    _specialLab.hidden = YES;

    //是否售罄
    UILabel *_selloutLab = [[UILabel alloc] init];
    _selloutLab.font = [UIFont boldSystemFontOfSize:10.0];
    _selloutLab.textColor = [UIColor redColor];
    _selloutLab.textAlignment = NSTextAlignmentCenter;
    _selloutLab.backgroundColor = [UIColor whiteColor];
    _selloutLab.layer.cornerRadius = 3.0;
    _selloutLab.layer.masksToBounds = YES;
    _selloutLab.layer.borderColor = [UIColor redColor].CGColor;
    _selloutLab.layer.borderWidth = 0.5;
    _selloutLab.tag = 80;
    [self.contentView addSubview:_selloutLab];
    _selloutLab.hidden = YES;
}

-(void)refreshCellWithModel:(DeliciousFoodListModel *)model
{
    UIImageView *_titleImage = (UIImageView *)[self viewWithTag:10];
    UIImageView *_hotImageView = (UIImageView *)[self viewWithTag:20];
    UILabel     *_titleLab = (UILabel *)[self viewWithTag:30];
    UILabel     *_salePriceLab = (UILabel *)[self viewWithTag:40];
    UILabel     *_normalPriceLab = (UILabel *)[self viewWithTag:50];
    UIView      *_normallineView = (UIView *)[self viewWithTag:60];
    UILabel     *_specialLab = (UILabel *)[self viewWithTag:70];
    UILabel     *_selloutLab = (UILabel *)[self viewWithTag:80];
    
    [_titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,model.Product_pic]] placeholderImage:[UIImage imageNamed:@"moren"]];

    NSString *hotStr = [NSString stringWithFormat:@"%@",model.Product_hot];
    if ([hotStr isEqualToString:@"1"]) {
        _hotImageView.hidden = NO;
    }else{
        _hotImageView.hidden = YES;
    }
    
    _titleLab.text = [NSString stringWithFormat:@"%@",model.Product_name];
    _titleLab.frame = CGRectMake(_titleImage.right + 10, 20, SCREENWIDTH - 20 - 100, [self lableTextHeightWithSting:_titleLab.text and:[SizeUtility textFontSize:default_FoodIndex_title_size]].height);
    
    _salePriceLab.text = [NSString stringWithFormat:@"￥%@",model.Product_price];
    _salePriceLab.frame = CGRectMake(_titleImage.right + 10, 95 - 20 - [self lableTextHeightWithSting:_salePriceLab.text and:[SizeUtility textFontSize:default_FoodIndex_title_size]].height, [self lableTextHeightWithSting:_salePriceLab.text and:[SizeUtility textFontSize:default_FoodIndex_title_size]].width, [self lableTextHeightWithSting:_salePriceLab.text and:[SizeUtility textFontSize:default_FoodIndex_title_size]].height);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_salePriceLab.text];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(0, 1)];
    _salePriceLab.attributedText = attStr;
    
    NSString *normalStr = [NSString stringWithFormat:@"%@",model.Product_mktprice];
    if ([normalStr isEqualToString:@"0.00"]) {
        _normalPriceLab.hidden = YES;
        _normallineView.hidden = YES;
    }else{
        _normalPriceLab.hidden = NO;
        _normallineView.hidden = NO;
        _normalPriceLab.text = [NSString stringWithFormat:@"￥%@",normalStr];
        _normalPriceLab.frame = CGRectMake(_salePriceLab.right, 95 - 20 - [self lableTextHeightWithSting:_normalPriceLab.text and:10.0].height, [self lableTextHeightWithSting:_normalPriceLab.text and:10.0].width, [self lableTextHeightWithSting:_normalPriceLab.text and:10.0].height);
        
        _normallineView.frame = CGRectMake(0, 0, [self lableTextHeightWithSting:_normalPriceLab.text and:10.0].width, 0.5);
        _normallineView.center = _normalPriceLab.center;
    }
    
    NSString *specialStr = [NSString stringWithFormat:@"%@",model.Product_point];
    if ([specialStr isEqualToString:@""]) {
        _specialLab.hidden = YES;
    }else{
        _specialLab.hidden = NO;
        _specialLab.text = specialStr;
        _specialLab.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_specialLab.text and:10.0].width - 2, 95 - 20 - [self lableTextHeightWithSting:_specialLab.text and:10.0].height - 2, [self lableTextHeightWithSting:_specialLab.text and:10.0].width + 2, [self lableTextHeightWithSting:_specialLab.text and:10.0].height + 2);
    }
    
    NSString *saleStr = [NSString stringWithFormat:@"%@",model.Product_sale];
    if ([saleStr isEqualToString:@"1"]) {
        
        _selloutLab.hidden = NO;
        //售罄
        _selloutLab.text = @"已售罄";
        
        if ([specialStr isEqualToString:@""]){
            _selloutLab.frame = CGRectMake(SCREENWIDTH - 10 - 2-[self lableTextHeightWithSting:_selloutLab.text and:10.0].width , 95 - 20 - [self lableTextHeightWithSting:_selloutLab.text and:10.0].height - 2, [self lableTextHeightWithSting:_selloutLab.text and:10.0].width + 2, [self lableTextHeightWithSting:_selloutLab.text and:10.0].height + 2);
        }else{
            _selloutLab.frame = CGRectMake(SCREENWIDTH - 10 - 2-[self lableTextHeightWithSting:_selloutLab.text and:10.0].width - 10 - [self lableTextHeightWithSting:_specialLab.text and:10.0].width , 95 - 20 - [self lableTextHeightWithSting:_selloutLab.text and:10.0].height - 2, [self lableTextHeightWithSting:_selloutLab.text and:10.0].width + 2, [self lableTextHeightWithSting:_selloutLab.text and:10.0].height + 2);
        }
    }else{
        _selloutLab.hidden = YES;
    }
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
