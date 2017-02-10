//
//  OrderNumberCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/24.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "OrderNumberCell.h"

@interface OrderNumberCell ()

@property(nonatomic,copy)weiPayBlock       weiPayBlock;

@end

@implementation OrderNumberCell

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
    //订单号
    UILabel *_orderNum = [[UILabel alloc] init];
    _orderNum.numberOfLines = 1;
    _orderNum.font = [UIFont systemFontOfSize:14.0];
    _orderNum.textAlignment = NSTextAlignmentLeft;
    _orderNum.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderNum.tag = 10;
    [self.contentView addSubview:_orderNum];

    //订单状态
    UILabel *_orderstatis = [[UILabel alloc] init];
    _orderstatis.numberOfLines = 1;
    _orderstatis.font = [UIFont systemFontOfSize:12.0];
    _orderstatis.textAlignment = NSTextAlignmentLeft;
    _orderstatis.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderstatis.tag = 20;
    [self.contentView addSubview:_orderstatis];

    //支付按钮背景
    UIView *_payBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 65)];
    _payBgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _payBgView.tag = 30;
    [self.contentView addSubview:_payBgView];
    _payBgView.hidden = YES;
    
    //支付按钮
   UIButton * _payBtn = [ButtonControl creatButtonWithFrame:CGRectMake(30, 20, SCREENWIDTH - 60, 35) Text:nil ImageName:nil bgImageName:nil Target:self Action:@selector(payClick)];
    _payBtn.layer.cornerRadius = 5.0;
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _payBtn.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:192.0/255.0 blue:21.0/255.0 alpha:1.0];
    _payBtn.tag = 40;
    [_payBgView addSubview:_payBtn];
}

//数据刷新
-(void)refreshCellWithData:(NSDictionary *)model
{
    UILabel *_orderNum = (UILabel *)[self viewWithTag:10];
    UILabel *_orderstatis = (UILabel *)[self viewWithTag:20];
    UIView *_payBgView = (UIView *)[self viewWithTag:30];
    UIButton *_payBtn = (UIButton *)[self viewWithTag:40];
    
    _orderNum.text = [NSString stringWithFormat:@"订单号：%@",model[@"order_id"]];
    _orderNum.frame = CGRectMake(10, 0, SCREENWIDTH, 50);
    
    NSArray *statisArr = [NSArray arrayWithObjects:@"已完成",@"取消订单",@"待支付",@"未支付",@"待退款",@"已退款",@"待发货",@"已发货",@"已完成",@"待评价",nil];
    
    NSArray *array = [NSArray arrayWithObjects:@"finish",@"cancel",@"waitpay",@"nopay",@"waitrefund",@"refunded",@"delivery",@"shipping",@"confirmed",@"waitevaluate",nil];
    
    NSString *orderStatis = [NSString stringWithFormat:@"%@",model[@"status"]];
    NSString *orderStr;
    for (int i=0; i<statisArr.count; i++) {
        if ([orderStatis isEqualToString:array[i]]) {
            orderStr = [NSString stringWithFormat:@"%@",statisArr[i]];
        }
    }
    
    _orderstatis.text = [NSString stringWithFormat:@"%@",orderStr];
    _orderstatis.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_orderstatis.text and:12.0].width, 0, SCREENWIDTH, 50);

    if ([orderStatis isEqualToString:@"waitpay"] || [orderStatis isEqualToString:@"nopay"]) {
        _payBgView.hidden = NO;
        [_payBtn setTitle:[NSString stringWithFormat:@"使用微信支付 (%@元)",model[@"total_amount"]] forState:UIControlStateNormal];
    }
}

-(CGFloat)cellHeight:(NSDictionary *)model
{
    NSString *orderStatis = [NSString stringWithFormat:@"%@",model[@"status"]];
    
    CGFloat height = 0.0;
    if ([orderStatis isEqualToString:@"waitpay"] || [orderStatis isEqualToString:@"nopay"]){
        height = 115;
    }else{
        height = 50;
    }
    
    return height;
}

//微信支付
-(void)payClick
{
    if (self.weiPayBlock) {
        self.weiPayBlock();
    }
}
-(void)weiPayBlock:(weiPayBlock)block
{
    _weiPayBlock = block;
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
