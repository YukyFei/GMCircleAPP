//
//  GoodsView.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/24.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GoodsView.h"

@interface GoodsView ()

@end

@implementation GoodsView

-(instancetype)initWithFrame:(CGRect)frame withDict:(NSDictionary *)dict{
    self = [super initWithFrame:frame];
    
    if (self) {

        //商品图片
        UIImageView *_titleImage = [[UIImageView alloc] init];
        [_titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,dict[@"pic"]]] placeholderImage:[UIImage imageNamed:@"moren"]];
        _titleImage.frame = CGRectMake(10, 10, 80, 60);
        [self addSubview:_titleImage];

        //菜名
        UILabel *_theDishesLab = [[UILabel alloc] init];
        _theDishesLab.text = [NSString stringWithFormat:@"%@",dict[@"goods_name"]];
        _theDishesLab.frame = CGRectMake(10 + _titleImage.right, 10, SCREENWIDTH - 20 - 80, [self lableTextHeightWithSting:_theDishesLab.text and:14.0].height);
        _theDishesLab.numberOfLines = 0;
        _theDishesLab.textAlignment = NSTextAlignmentLeft;
        _theDishesLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _theDishesLab.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_theDishesLab];

        //商品购买个数
        UILabel *_numLab = [[UILabel alloc] init];
        _numLab.text = [NSString stringWithFormat:@"数量：%@", dict[@"number"]];
        _numLab.frame = CGRectMake(10 + _titleImage.right, 5 + _theDishesLab.bottom, SCREENWIDTH - 20 - 80, [self lableTextHeightWithSting:_theDishesLab.text and:12.0].height);
        _numLab.numberOfLines = 1;
        _numLab.textAlignment = NSTextAlignmentLeft;
        _numLab.textColor = [UIColor lightGrayColor];
        _numLab.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_numLab];

        //原价
        UILabel *_normalPriceLab = [[UILabel alloc] init];
        _normalPriceLab.text =[self stringFormat:[NSString stringWithFormat:@"￥%@",dict[@"price"]]];
        _normalPriceLab.frame = CGRectMake(10 + _titleImage.right, 5 + _numLab.bottom, [self lableTextHeightWithSting:_normalPriceLab.text and:14.0].width, [self lableTextHeightWithSting:_normalPriceLab.text and:14.0].height);
        _normalPriceLab.numberOfLines = 1;
        _normalPriceLab.textAlignment = NSTextAlignmentLeft;
        _normalPriceLab.textColor = [UIColor redColor];
        _normalPriceLab.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_normalPriceLab];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_normalPriceLab.text];
        
        [attStr addAttribute:NSFontAttributeName
         
                       value:[UIFont systemFontOfSize:11.0]
         
                       range:NSMakeRange(0, 1)];
        _normalPriceLab.attributedText = attStr;
    }
    
    return self;
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-20, 999);
    CGSize user_newSize;
    user_newSize = [text boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return user_newSize;
}

- (NSString *)stringFormat:(NSString *)str
{
    return [NSString stringWithFormat:@"%@",str];
}

@end
