//
//  HomeCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()

@end

@implementation HomeCell

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
    //首页cell大图片
    UIImageView *_titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, [SizeUtility textFontSize:default_HomeCell_height_size])];
    _titleImg.tag = 10;
    _titleImg.contentMode = UIViewContentModeScaleToFill;
    _titleImg.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleImg];

    //分割线
    UIView *_lineView = [[UIView alloc] initWithFrame:CGRectMake(0, [SizeUtility textFontSize:default_HomeCell_height_size] - 0.5, SCREENWIDTH, 0.5)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [self.contentView addSubview:_lineView];
}

-(void)refreshCellWithModel:(HomeModel *)model
{
    UIImageView *_titleImg = (UIImageView *)[self viewWithTag:10];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@",demoURLL,model.O_pic];
    
    [_titleImg sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"moren"]];
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
