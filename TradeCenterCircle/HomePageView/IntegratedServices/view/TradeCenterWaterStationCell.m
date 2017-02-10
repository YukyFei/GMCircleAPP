//
//  TradeCenterWaterStationCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/17.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "TradeCenterWaterStationCell.h"

@implementation TradeCenterWaterStationCell

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
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 75)];
        _titleImage.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_titleImage];
    }
    
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
        _hotImageView.backgroundColor = [UIColor colorWithHexString:@"#f97200"];
        [_titleImage addSubview:_hotImageView];
    }
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 94.5, SCREENWIDTH, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self.contentView addSubview:_lineView];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"甜心魅魔-鸡肉紫甘蓝沙拉";
        _titleLab.numberOfLines = 0;
        _titleLab.frame = CGRectMake(_titleImage.right + 10, 20, SCREENWIDTH - 20 - 100, [self lableTextHeightWithSting:_titleLab.text and:14.0].height);
        _titleLab.font = [UIFont systemFontOfSize:14.0];
        _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_titleLab];
    }
    
    if (!_salePriceLab) {
        _salePriceLab = [[UILabel alloc] init];
        _salePriceLab.text = [NSString stringWithFormat:@"￥%@",@"34.00"];
        _salePriceLab.frame = CGRectMake(_titleImage.right + 10, 95 - 20 - [self lableTextHeightWithSting:_salePriceLab.text and:14.0].height, [self lableTextHeightWithSting:_salePriceLab.text and:14.0].width, [self lableTextHeightWithSting:_salePriceLab.text and:14.0].height);
        _salePriceLab.font = [UIFont systemFontOfSize:14.0];
        _salePriceLab.textColor = [UIColor redColor];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_salePriceLab.text];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(0, 1)];
        _salePriceLab.attributedText = attStr;
        
        [self.contentView addSubview:_salePriceLab];
    }
    
    if (!_specialLab) {
        _specialLab = [[UILabel alloc] init];
        _specialLab.text = @"饮水机专用";
        _specialLab.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_specialLab.text and:10.0].width - 2, 95 - 20 - [self lableTextHeightWithSting:_specialLab.text and:10.0].height - 2, [self lableTextHeightWithSting:_specialLab.text and:10.0].width + 2, [self lableTextHeightWithSting:_specialLab.text and:10.0].height + 2);
        _specialLab.font = [UIFont boldSystemFontOfSize:10.0];
        _specialLab.textColor = [UIColor whiteColor];
        _specialLab.textAlignment = NSTextAlignmentCenter;
        _specialLab.backgroundColor = [UIColor redColor];
        _specialLab.layer.cornerRadius = 2.0;
        _specialLab.layer.masksToBounds = YES;
        [self.contentView addSubview:_specialLab];
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
