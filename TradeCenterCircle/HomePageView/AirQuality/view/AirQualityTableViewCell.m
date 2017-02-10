//
//  AirQualityTableViewCell.m
//  TradeCenterCircle
//
//  Created by 李阳 on 17/1/4.
//  Copyright © 2017年 weiwei-zhang. All rights reserved.
//

#import "AirQualityTableViewCell.h"

@implementation AirQualityTableViewCell

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
    _addressLab = [[UILabel alloc]initWithFrame:CGRectMake(12*SCREENWIDTH/320, 0, 180*SCREENWIDTH/320, 60*SCREENWIDTH/320)];
    _addressLab.textAlignment = NSTextAlignmentLeft ;
    _addressLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_airquality_title_size]] ;
    _addressLab.numberOfLines = 0 ;
    [self.contentView addSubview:_addressLab];
    
    _degreeLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-74*SCREENWIDTH/320-50*SCREENWIDTH/320, 23*SCREENWIDTH/320, 50*SCREENWIDTH/320,  14*SCREENWIDTH/320)];
    _degreeLab.layer.cornerRadius = 4.0f ;
    _degreeLab.textColor = [UIColor whiteColor] ;
    _degreeLab.textAlignment = NSTextAlignmentCenter ;
    _degreeLab.font = [UIFont systemFontOfSize:([SizeUtility textFontSize:default_Minecell_title_size]-2)] ;
    [self.contentView addSubview:_degreeLab];
    _numberLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 62*SCREENWIDTH/320 , 0, 50*SCREENWIDTH/320, 60*SCREENWIDTH/320)];
    _numberLab.textAlignment = NSTextAlignmentCenter ;
    _numberLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_airquality_title_size]] ;
    [self.contentView addSubview:_numberLab];
    //分割线
    UIView *_lineView = [[UIView alloc] initWithFrame:CGRectMake(8*SCREENWIDTH/320, 60*SCREENWIDTH/320-1, SCREENWIDTH-12*SCREENWIDTH/320, 1)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [self.contentView addSubview:_lineView];
}

-(void)setModel:(AirQualityModel *)model
{
    NSArray * textArr = @[@"严重污染",@"重度污染",@"中度污染",@"轻度污染",@"良",@"优"];
    NSArray * colourArr = @[@"#712330",@"#b9377a",@"#da555d",@"#ff971a",@"#f1c307",@"#3cd066"] ;
    _model = model ;
    _addressLab.text = model.Weather_Name ;
    _numberLab.text = model.Weather_Number ;
    _degreeLab.text = textArr[([model.Weather_Fouls intValue]-1)];
    _degreeLab.backgroundColor = [UIColor colorWithHexString:colourArr[([model.Weather_Fouls intValue]-1)]] ;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
