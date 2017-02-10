//
//  MyExpressFeeCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyExpressFeeCell.h"

@interface MyExpressFeeCell ()

@property(nonatomic,strong) MyExpressFeeModel *m_model;

@end

@implementation MyExpressFeeCell

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
    //背景
    UIView *_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.tag = 10;
    [self.contentView addSubview:_bgView];

    //订单号
    UILabel *_orderNum = [[UILabel alloc] init];
    _orderNum.numberOfLines = 1;
    _orderNum.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_ExpressFee_Title_size]];
    _orderNum.textAlignment = NSTextAlignmentLeft;
    _orderNum.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderNum.tag = 20;
    [_bgView addSubview:_orderNum];

    //订单状态
    UILabel *_orderStatis = [[UILabel alloc] init];
    _orderStatis.numberOfLines = 1;
    _orderStatis.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_ExpressFee_SubTitle_size]];
    _orderStatis.textAlignment = NSTextAlignmentLeft;
    _orderStatis.textColor = [UIColor lightGrayColor];
    _orderStatis.tag = 30;
    [_bgView addSubview:_orderStatis];

    //中间分割线
    UIView *_senderLineView = [[UIView alloc] init];
    _senderLineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _senderLineView.tag = 40;
    [_bgView addSubview:_senderLineView];

    //订单价钱
    UILabel *_orderPrice = [[UILabel alloc] init];
    _orderPrice.numberOfLines = 1;
    _orderPrice.textAlignment = NSTextAlignmentLeft;
    _orderPrice.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderPrice.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_ExpressFee_Title_size]];
    _orderPrice.tag = 50;
    [_bgView addSubview:_orderPrice];

    //订单时间
    UILabel *_orderTime = [[UILabel alloc] init];
    _orderTime.numberOfLines = 1;
    _orderTime.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_ExpressFee_SubTitle_size]];
    _orderTime.textAlignment = NSTextAlignmentLeft;
    _orderTime.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderTime.tag = 60;
    [_bgView addSubview:_orderTime];

    //cell分割线
    UIView *_lingView = [[UIView alloc] init];
    _lingView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _lingView.tag = 70;
    [_bgView addSubview:_lingView];
}

-(void)refreshCellWithModel:(MyExpressFeeModel *)model
{
    UIView *_bgView = (UIView *)[self viewWithTag:10];
    UILabel *_orderNum = (UILabel *)[self viewWithTag:20];
    UILabel *_orderStatis = (UILabel *)[self viewWithTag:30];
    UIView *_senderLineView = (UIView *)[self viewWithTag:40];
    UILabel *_orderPrice = (UILabel *)[self viewWithTag:50];
    UILabel *_orderTime = (UILabel *)[self viewWithTag:60];
    UIView *_lingView = (UIView *)[self viewWithTag:70];
    
    self.m_model = model;
    _orderNum.text = [NSString stringWithFormat:@"订单号：%@",model.Order_id];
    _orderNum.frame = CGRectMake(10, 10, [self lableTextHeightWithSting:_orderNum.text and:[SizeUtility textFontSize:default_ExpressFee_Title_size]].width, [self lableTextHeightWithSting:_orderNum.text and:[SizeUtility textFontSize:default_ExpressFee_Title_size]].height);
    
    NSString *statisStr;
    if ([[NSString stringWithFormat:@"%@",model.Pay_status] isEqualToString:@"0"]) {
        statisStr = @"未支付";
    }else if ([[NSString stringWithFormat:@"%@",model.Pay_status] isEqualToString:@"1"]) {
        statisStr = @"已支付";
    }else{
        statisStr = @"已支付待确认";
    }
    _orderStatis.text = statisStr;
    _orderStatis.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_orderStatis.text and:[SizeUtility textFontSize:default_ExpressFee_SubTitle_size]].width, 10 , [self lableTextHeightWithSting:_orderStatis.text and:[SizeUtility textFontSize:default_ExpressFee_SubTitle_size]].width, [self lableTextHeightWithSting:_orderStatis.text and:[SizeUtility textFontSize:default_ExpressFee_SubTitle_size]].height);
    
    _senderLineView.frame = CGRectMake(0, _orderNum.bottom+10, SCREENWIDTH, 0.5);
    
    _orderPrice.text = [NSString stringWithFormat:@"实付款：￥%@",model.Pay_money];
    _orderPrice.frame = CGRectMake(10, 10 + _senderLineView.bottom, [self lableTextHeightWithSting:_orderPrice.text and:[SizeUtility textFontSize:default_ExpressFee_Title_size]].width, [self lableTextHeightWithSting:_orderPrice.text and:[SizeUtility textFontSize:default_ExpressFee_Title_size]].height);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_orderPrice.text];
    
    [attStr addAttribute:NSFontAttributeName
     
                   value:[UIFont systemFontOfSize:11.0]
     
                   range:NSMakeRange(4, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName
     
                   value:[UIColor redColor]
     
                   range:NSMakeRange(4, _orderPrice.text.length - 4)];
    
    _orderPrice.attributedText = attStr;
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",model.Create_time];
    
    _orderTime.text = [NSString stringWithFormat:@"%@",(NSString *)[self invokeDayMonthHourMinutsSeconds:timeStr]];
    _orderTime.text = timeStr;
    
    _orderTime.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_orderTime.text and:[SizeUtility textFontSize:default_ExpressFee_SubTitle_size]].width, 10 + _senderLineView.bottom , [self lableTextHeightWithSting:_orderTime.text and:[SizeUtility textFontSize:default_ExpressFee_SubTitle_size]].width, [self lableTextHeightWithSting:_orderTime.text and:[SizeUtility textFontSize:default_ExpressFee_SubTitle_size]].height);
    
    CGFloat height = 10 + [self lableTextHeightWithSting:_orderNum.text and:[SizeUtility textFontSize:default_ExpressFee_Title_size]].height + 10 + 0.5 + 10 + [self lableTextHeightWithSting:_orderPrice.text and:[SizeUtility textFontSize:default_ExpressFee_Title_size]].height + 10 + 0.5;
    
    _lingView.frame = CGRectMake(0, _orderPrice.bottom+10, SCREENWIDTH, 0.5);

    _bgView.frame = CGRectMake(0, 0, SCREENWIDTH, height);
}

-(CGFloat)cellHeight
{
    UILabel *_orderNum = (UILabel *)[self viewWithTag:20];
    UILabel *_orderPrice = (UILabel *)[self viewWithTag:50];
    
    _orderNum.text = [NSString stringWithFormat:@"订单号：%@",self.m_model.Order_id];
    _orderPrice.text = [NSString stringWithFormat:@"实付款：￥%@",self.m_model.Pay_money];
    
    CGFloat height = 0.0;
    
    height += 10 + [self lableTextHeightWithSting:_orderNum.text and:[SizeUtility textFontSize:default_ExpressFee_Title_size]].height + 10 + 0.5 + 10 + [self lableTextHeightWithSting:_orderPrice.text and:[SizeUtility textFontSize:default_ExpressFee_Title_size]].height + 10 + 0.5;
    
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
