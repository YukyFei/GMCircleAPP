//
//  MallFoodListCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MallFoodListCell.h"

@interface MallFoodListCell ()

@end

@implementation MallFoodListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

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
    
    //分割线
    UIView *_lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 94.5, SCREENWIDTH, 0.5)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.contentView addSubview:_lineView];
    
    //标题
    UILabel *_titleLab = [[UILabel alloc] init];
    _titleLab.numberOfLines = 0;
    _titleLab.tag = 20;
    
    _titleLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_FoodIndex_title_size]];
    _titleLab.textColor = [UIColor colorWithHexString:@"#5f3f2a"];
    [self.contentView addSubview:_titleLab];
    
    //副标题
    UILabel *_subTitleLab = [[UILabel alloc] init];
    _subTitleLab.font = [UIFont systemFontOfSize:12.0];
    _subTitleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    
    _subTitleLab.text = [NSString stringWithFormat:@"%@",@"美食"];
    _subTitleLab.frame = CGRectMake(_titleImage.right + 10, 95 - 20 - [self lableTextHeightWithSting:_subTitleLab.text and:12.0].height, [self lableTextHeightWithSting:_subTitleLab.text and:12.0].width, [self lableTextHeightWithSting:_subTitleLab.text and:12.0].height);
    
    [self.contentView addSubview:_subTitleLab];
    
    //❤️
    UIImageView *_heartImage = [[UIImageView alloc] initWithFrame:CGRectMake(_subTitleLab.right + 18, 95 - 18 - [self lableTextHeightWithSting:_subTitleLab.text and:12.0].height, 13,12)];
    _heartImage.image = [UIImage imageNamed:@"heart_1"];
//    [self.contentView addSubview:_heartImage];
    
    //评分
    UILabel *_scoreLab = [[UILabel alloc] init];
    _scoreLab.font = [UIFont systemFontOfSize:12.0];
    _scoreLab.textColor = [UIColor colorWithHexString:@"#f15353"];
    
    _scoreLab.text = [NSString stringWithFormat:@"%@分",@"2.0"];
    _scoreLab.frame = CGRectMake(_heartImage.right + 4, 95 - 20 - [self lableTextHeightWithSting:_scoreLab.text and:12.0].height, [self lableTextHeightWithSting:_scoreLab.text and:12.0].width, [self lableTextHeightWithSting:_scoreLab.text and:12.0].height);
    
//    [self.contentView addSubview:_scoreLab];
    
    //订的标记
    UILabel *_bookLab = [[UILabel alloc] init];
    _bookLab.text = @"订";
    _bookLab.font = [UIFont boldSystemFontOfSize:10.0];
    
    _bookLab.frame = CGRectMake(SCREENWIDTH - 10 - ([self lableTextHeightWithSting:_bookLab.text and:10.0].width + 6), 10, [self lableTextHeightWithSting:_bookLab.text and:10.0].width + 6, [self lableTextHeightWithSting:_bookLab.text and:10.0].height + 4);
    
    _bookLab.textColor = [UIColor whiteColor];
    _bookLab.textAlignment = NSTextAlignmentCenter;
    _bookLab.backgroundColor = [UIColor colorWithHexString:@"#fc6156"];
    _bookLab.layer.cornerRadius = 2.0;
    _bookLab.layer.masksToBounds = YES;
    [self.contentView addSubview:_bookLab];
    
    //预订按钮
    UILabel *_bookBtn = [[UILabel alloc]init];
    _bookBtn.text = @"预订" ;
    _bookBtn.textAlignment = NSTextAlignmentCenter ;
    _bookBtn.font = [UIFont systemFontOfSize:14.0];
    _bookBtn.layer.cornerRadius = 2.0 ;
    _bookBtn.clipsToBounds = YES ;
    [_bookBtn setFrame:CGRectMake(SCREENWIDTH - 10 - 80, _bookLab.bottom + 20, 80, 32)];
    _bookBtn.backgroundColor = [UIColor colorWithHexString:@"#fc6156"];
    [self.contentView addSubview:_bookBtn];

}

-(void)refreshCellWithModel:(MallFoodListModel *)model
{
    UIImageView *_titleImage = (UIImageView *)[self viewWithTag:10];
    UILabel     *_titleLab = (UILabel *)[self viewWithTag:20];

    [_titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,model.S_logo]] placeholderImage:[UIImage imageNamed:@"moren"]];
    
    _titleLab.text = [NSString stringWithFormat:@"%@",model.Shop_name];
    _titleLab.frame = CGRectMake(_titleImage.right + 10, 20, SCREENWIDTH - 20 - 100, [self lableTextHeightWithSting:_titleLab.text and:[SizeUtility textFontSize:default_FoodIndex_title_size]].height);
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-20, 999);
    CGSize user_newSize;
    user_newSize = [text boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return user_newSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
