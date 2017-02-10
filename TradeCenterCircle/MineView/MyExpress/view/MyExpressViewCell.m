//
//  MyExpressViewCell.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/16.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyExpressViewCell.h"

@implementation MyExpressViewCell

- (void)awakeFromNib {
    // Initialization code
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
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
        [self.contentView addSubview:_bgView];
    }
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"] ;
        [_bgView addSubview:_lineView];
    }
    
    if (!_orderNum) {
        _orderNum = [[UILabel alloc] init];
        _orderNum.numberOfLines = 1;
        _orderNum.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-3];
        _orderNum.textAlignment = NSTextAlignmentLeft;
        _orderNum.textColor = [UIColor colorWithHexString:@"#666666"];
        [_bgView addSubview:_orderNum];
    }
    
    if (!_orderStatis) {
        _orderStatis = [[UILabel alloc] init];
        _orderStatis.numberOfLines = 1;
        _orderStatis.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-3];
        _orderStatis.textAlignment = NSTextAlignmentLeft;
        _orderStatis.textColor = [UIColor lightGrayColor];
        [_bgView addSubview:_orderStatis];
    }
    
    if (!_senderLineView) {
        _senderLineView = [[UIView alloc] init];
        _senderLineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [_bgView addSubview:_senderLineView];
    }
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.numberOfLines = 1;
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _nameLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]];
        
        [_bgView addSubview:_nameLab];
        
    }
    
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] init];
        
        _addressLab.numberOfLines = 1;
        _addressLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]];
        _addressLab.textAlignment = NSTextAlignmentLeft;
         _addressLab.textColor = [UIColor lightGrayColor] ;
        [_bgView addSubview:_addressLab];
    }
    
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        
        _typeLab.textColor = [UIColor lightGrayColor] ;
        _typeLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
        [_bgView addSubview:_typeLab];
    }
    if (!_commentsLab) {
        _commentsLab = [[UILabel alloc] init];
        _commentsLab.textColor = [UIColor lightGrayColor] ;
        _commentsLab.font=[UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
        
        _commentsLab.numberOfLines = 0 ;
      [_bgView addSubview:_commentsLab];
    }
    
    
}

-(void)setModel:(MyExpressModel *)model
{
    _model = model ;
    _lineView.frame = CGRectMake(0, 0, SCREENWIDTH, 0.5);
    
    _orderNum.text = [NSString stringWithFormat:@"订单号：%@",model.Order_id];
    _orderNum.frame = CGRectMake(10, 10, [self lableTextHeightWithSting:_orderNum.text and:14.0].width, [self lableTextHeightWithSting:_orderNum.text and:14.0].height);
    
    _orderStatis.text = @"已联系快递";
    _orderStatis.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_orderStatis.text and:12.0].width, VIEW_TY(_orderNum) , [self lableTextHeightWithSting:_orderStatis.text and:13.0].width, [self lableTextHeightWithSting:_orderStatis.text and:12.0].height);
    
    _senderLineView.frame = CGRectMake(0, _orderNum.bottom+10, SCREENWIDTH, 0.5);
    
       _nameLab.text = [NSString stringWithFormat:@"%@   %@",model.Express_name,model.Express_mobile];
    _nameLab.frame = CGRectMake(10, 10 + _senderLineView.bottom, VIEW_W(self), [self lableTextHeightWithSting:_nameLab.text and:14.0].height);
    
    _addressLab.text = model.Express_area ;
    _addressLab.frame = CGRectMake(VIEW_TX(_nameLab), 10 + _nameLab.bottom , VIEW_W(self), [self lableTextHeightWithSting:_addressLab.text and:14.0].height);
    
    _typeLab.text =  [NSString stringWithFormat:@"类别：%@",model.Express_type];
    _typeLab.frame = CGRectMake(VIEW_TX(_nameLab), VIEW_BY(_addressLab)+5, SCREENWIDTH-VIEW_TX(_nameLab)*2, [self lableTextHeightWithSting:_typeLab.text and:14.0].height);
    
    _commentsLab.text = [NSString stringWithFormat:@"备注：%@",model.Express_note] ;
    _commentsLab.frame = CGRectMake(VIEW_TX(_nameLab), VIEW_BY(_typeLab)+5, SCREENWIDTH-VIEW_TX(_nameLab)*2, [self lableTextHeightWithSting:_commentsLab.text and:14.0].height);
    
//    CGFloat  height = 10+_orderNum.height +_nameLab.height+10+_addressLab.height +5+[self lableTextHeightWithSting:_commentsLab.text and:14.0f].height +5+_typeLab.height+_lineView.height ;
    CGFloat  height = 20+_orderNum.height +10+_nameLab.height+10+_addressLab.height+10  +5+_typeLab.height+_lineView.height +5+_commentsLab.height+5;

    _bgView.frame = CGRectMake(0, 0, SCREENWIDTH, height);
    _bgView.backgroundColor = [UIColor whiteColor];
}


-(CGFloat)cellHeightWithModel:(MyExpressModel *)model
{
    
    _model = model ;
    _lineView.frame = CGRectMake(0, 0, SCREENWIDTH, 0.5);
    
    _orderNum.text = [NSString stringWithFormat:@"订单号：%@",model.Order_id];

    
    _orderStatis.text = @"已联系快递";
    
    _senderLineView.frame = CGRectMake(0, _orderNum.bottom+10, SCREENWIDTH, 0.5);
    
    _nameLab.text = [NSString stringWithFormat:@"%@   %@",model.Express_name,model.Express_mobile];
    
    _addressLab.text = model.Express_area ;
   
    
    _typeLab.text =  [NSString stringWithFormat:@"类别：%@",model.Express_type];
       _commentsLab.text = [NSString stringWithFormat:@"备注：%@",model.Express_note] ;
   
    
     CGFloat  height = 20+_orderNum.height +10+_nameLab.height+10+_addressLab.height+10  +5+_typeLab.height+_lineView.height +5+_commentsLab.height+5;
    
    
       return height;
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

    // Configure the view for the selected state
}

@end
