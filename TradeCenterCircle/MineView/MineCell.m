//
//  MineCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MineCell.h"

@interface MineCell ()

@end

@implementation MineCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    
    return self;
}
- (void)initUI
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, 200, 44)];
        _titleLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Minecell_title_size]];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_titleLab];
    }
    
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-10-30, 0, 32, 44)];
        _arrowImage.image = [UIImage imageNamed:@"common_btn_more"];
        [self.contentView addSubview:_arrowImage];
    }
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 43.5, SCREENWIDTH-12, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self.contentView addSubview:_lineView];
    }
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
