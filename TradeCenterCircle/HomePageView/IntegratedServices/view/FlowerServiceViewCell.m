//
//  FlowerServiceViewCell.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/16.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "FlowerServiceViewCell.h"

@implementation FlowerServiceViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       [self createUI];
    }
    
    return self;
}

-(void)createUI
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
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self.contentView addSubview:_lineView];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
//        _titleLab.text = @"哈瓦那havana";
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:14.0];
        _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_titleLab];
    }
    
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = [UIFont systemFontOfSize:14.0];
        _priceLab.textColor = [UIColor redColor];
        
        [self.contentView addSubview:_priceLab];
    }
    
    if (!_specialLab) {
        _specialLab = [[UILabel alloc] init];
//        _specialLab.text = @"饮水机专用";
               _specialLab.font = [UIFont boldSystemFontOfSize:10.0];
        _specialLab.textColor = [UIColor whiteColor];
        _specialLab.textAlignment = NSTextAlignmentCenter;
        _specialLab.backgroundColor = [UIColor redColor];
        _specialLab.layer.cornerRadius = 2.0;
        _specialLab.layer.masksToBounds = YES;
        [self.contentView addSubview:_specialLab];
    }
//
    if (!_selloutLab) {
        _selloutLab = [[UILabel alloc] init];
        _selloutLab.font = [UIFont boldSystemFontOfSize:10.0];
        _selloutLab.textColor = [UIColor redColor];
        _selloutLab.textAlignment = NSTextAlignmentCenter;
        _selloutLab.backgroundColor = [UIColor whiteColor];
        _selloutLab.layer.cornerRadius = 3.0;
        _selloutLab.layer.masksToBounds = YES;
        _selloutLab.layer.borderColor = [UIColor redColor].CGColor;
        _selloutLab.layer.borderWidth = 0.5;
        [self.contentView addSubview:_selloutLab];
    }

    
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-20, 999);
    CGSize user_newSize;
    user_newSize = [text boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return user_newSize;
}


-(void)setModel:(FlowerSeverModel *)model
{
//    _model = model ;
//    *titleImage;
//    *titleLab;
//    *priceLab;
//    *specialLab;
//    *hotImageView;
//    *selloutLab;
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",demoURLL,model.Product_pic]]] ;
    self.titleLab.text = model.Product_name ;
    _titleLab.frame = CGRectMake(_titleImage.right + 10, 20, SCREENWIDTH - 20 - 100, [self lableTextHeightWithSting:_titleLab.text and:14.0].height);
    
  
    //热销
    if ([model.Product_hot isEqualToString:@"2"]) {
        self.hotImageView.hidden = YES ;
    }
    
    //保洁OR价格
    if (model.Product_note==nil||[model.Product_note isEqualToString:@""]) {
      self.priceLab.text = model.Product_price ;
    }else{
      self.priceLab.text = model.Product_note ;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_priceLab.text];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(0, 1)];
        _priceLab.attributedText = attStr;
    }
      _priceLab.frame = CGRectMake(_titleImage.right + 10, 95 - 20 - [self lableTextHeightWithSting:_priceLab.text and:14.0].height, [self lableTextHeightWithSting:_priceLab.text and:14.0].width, [self lableTextHeightWithSting:_priceLab.text and:14.0].height);
    //特殊标记
    if (model.Product_point==nil ||[model.Product_point isEqualToString:@""]) {
        self.specialLab.hidden = YES ;
    }else{
        self.specialLab.text = model.Product_point ;
    }
    _specialLab.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_specialLab.text and:10.0].width - 2, 95 - 20 - [self lableTextHeightWithSting:_specialLab.text and:10.0].height - 2, [self lableTextHeightWithSting:_specialLab.text and:10.0].width + 2, [self lableTextHeightWithSting:_specialLab.text and:10.0].height + 2);

    //是否售罄
    if ([model.Product_sale isEqualToString:@"1"]) {
        self.selloutLab.text = @"已售罄" ;
    }else{
            self.selloutLab.text = nil ;
    }
    _selloutLab.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_selloutLab.text and:10.0].width - 2, 95 - 20 - [self lableTextHeightWithSting:_selloutLab.text and:10.0].height - 2, [self lableTextHeightWithSting:_selloutLab.text and:10.0].width + 2, [self lableTextHeightWithSting:_selloutLab.text and:10.0].height + 2);
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",demoURLL,model.Product_pic]) ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
