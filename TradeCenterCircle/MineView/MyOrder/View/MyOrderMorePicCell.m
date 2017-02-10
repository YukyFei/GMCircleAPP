//
//  MyOrderMorePicCell.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyOrderMorePicCell.h"
#import "MyOrderListModel.h"

@interface MyOrderMorePicCell ()

@property(nonatomic,strong) UIImageView       *titleImage;        //标题图片
@property(nonatomic,copy) OrderStatisBlock     OrderStatisBlock;

@property(nonatomic,strong)MyOrderListModel    *m_model;

@end

@implementation MyOrderMorePicCell

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
    UIView *_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 300)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.tag = 10;
    [self.contentView addSubview:_bgView];

    //订单号
    UILabel *_orderNum = [[UILabel alloc] init];
    _orderNum.numberOfLines = 1;
    _orderNum.font = [UIFont systemFontOfSize:14.0];
    _orderNum.textAlignment = NSTextAlignmentLeft;
    _orderNum.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderNum.tag = 20;
    [_bgView addSubview:_orderNum];

    //订单状态
    UILabel *_orderStatis = [[UILabel alloc] init];
    _orderStatis.numberOfLines = 1;
    _orderStatis.font = [UIFont systemFontOfSize:12.0];
    _orderStatis.textAlignment = NSTextAlignmentCenter;
    _orderStatis.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderStatis.tag = 30;
    [_bgView addSubview:_orderStatis];
    
    //退款
    UILabel *_refund = [[UILabel alloc] init];
    _refund.numberOfLines = 1;
    _refund.font = [UIFont systemFontOfSize:12.0];
    _refund.textAlignment = NSTextAlignmentCenter;
    _refund.textColor = [UIColor colorWithHexString:@"#666666"];
    _refund.userInteractionEnabled = YES;
    _refund.hidden = YES;
    _refund.tag = 110;
    [_bgView addSubview:_refund];

    //中间分割线
    UIView *_senderLineView = [[UIView alloc] init];
    _senderLineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _senderLineView.tag = 40;
    [_bgView addSubview:_senderLineView];

    //cell分割线
    UIView *_centerLineView = [[UIView alloc] init];
    _centerLineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _centerLineView.tag = 50;
    [_bgView addSubview:_centerLineView];

    //订单价钱
    UILabel *_orderPrice = [[UILabel alloc] init];
    _orderPrice.numberOfLines = 1;
    _orderPrice.textAlignment = NSTextAlignmentLeft;
    _orderPrice.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderPrice.font = [UIFont systemFontOfSize:14.0];
    _orderPrice.tag = 60;
    [_bgView addSubview:_orderPrice];

    //cell分割线
    UIView *_lingView = [[UIView alloc] init];
    _lingView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _lingView.tag = 70;
    [_bgView addSubview:_lingView];
}

//数据刷新
-(void)refreshCellWithModel:(MyOrderListModel *)model
{
    UIView *_bgView = (UIView *)[self viewWithTag:10];
    UILabel *_orderNum = (UILabel *)[self viewWithTag:20];
    UILabel *_orderStatis = (UILabel *)[self viewWithTag:30];
    UIView *_senderLineView = (UIView *)[self viewWithTag:40];
    UIView *_centerLineView = (UIView *)[self viewWithTag:50];
    UILabel *_orderPrice = (UILabel *)[self viewWithTag:60];
    UIView *_lingView = (UIView *)[self viewWithTag:70];
    UILabel *_refund = (UILabel *)[self viewWithTag:110];
    
    self.m_model = model;
    _orderNum.text = [NSString stringWithFormat:@"订单号：%@",model.order_id];
    _orderNum.frame = CGRectMake(10, 10, [self lableTextHeightWithSting:_orderNum.text and:14.0].width, [self lableTextHeightWithSting:_orderNum.text and:14.0].height);
    
    NSArray *statisArr = [NSArray arrayWithObjects:@"已完成",@"取消订单",@"待支付",@"未支付",@"待退款",@"已退款",@"待发货",@"已发货",@"已完成",@"待评价",nil];
    
    NSArray *array = [NSArray arrayWithObjects:@"finish",@"cancel",@"waitpay",@"nopay",@"waitrefund",@"refunded",@"delivery",@"shipping",@"confirmed",@"waitevaluate",nil];
    
    NSString *orderStatis = [NSString stringWithFormat:@"%@",model.status];
    NSString *orderStr;
    for (int i=0; i<statisArr.count; i++) {
        if ([orderStatis isEqualToString:array[i]]) {
            orderStr = [NSString stringWithFormat:@"%@",statisArr[i]];
        }
    }
    
    _orderStatis.text = [NSString stringWithFormat:@"%@",orderStr];
    
    _senderLineView.frame = CGRectMake(0, _orderNum.bottom+10, SCREENWIDTH, 0.5);
    
    NSArray *smallArray;
    if (model.goods.count > 2) {
        smallArray = [model.goods subarrayWithRange:NSMakeRange(0, 3)];
    }else{
        smallArray = model.goods;
    }
    
    for (int i = 0; i < smallArray.count; i++) {
        NSDictionary *dic = smallArray[i];
        UIImageView *PicImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*(i+1) + 80*i, _senderLineView.bottom + 10, 80, 60)];
        PicImage.backgroundColor = [UIColor cyanColor];
        [PicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,[dic objectForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"moren"]];
        [self.contentView addSubview:PicImage];
        _titleImage = PicImage;
    }
    
    _centerLineView.frame = CGRectMake(0, _titleImage.bottom+10, SCREENWIDTH, 0.5);
    _orderPrice.text = [NSString stringWithFormat:@"实付款：￥%@",model.actmoney];
    _orderPrice.frame = CGRectMake(10, 10 + _centerLineView.bottom, [self lableTextHeightWithSting:_orderPrice.text and:14.0].width, [self lableTextHeightWithSting:_orderPrice.text and:14.0].height);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_orderPrice.text];
    
    [attStr addAttribute:NSFontAttributeName
     
                   value:[UIFont systemFontOfSize:11.0]
     
                   range:NSMakeRange(4, 1)];
    
    [attStr addAttribute:NSForegroundColorAttributeName
     
                   value:[UIColor redColor]
     
                   range:NSMakeRange(4, _orderPrice.text.length - 4)];
    
    _orderPrice.attributedText = attStr;
    _lingView.frame = CGRectMake(0, _orderPrice.bottom+10, SCREENWIDTH, 0.5);
    CGFloat height = 10 + [self lableTextHeightWithSting:_orderNum.text and:14.0].height + 10 + 0.5 + 10 + [self lableTextHeightWithSting:_orderPrice.text and:14.0].height + 10 + 0.5 + 0.5 + 20 + 60;
     _orderStatis.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_orderStatis.text and:12.0].width, 0 , [self lableTextHeightWithSting:_orderStatis.text and:12.0].width, 20+[self lableTextHeightWithSting:_orderNum.text and:14.0].height);
    
    
    CGFloat cellHeight = 10 + [self lableTextHeightWithSting:_orderNum.text and:14.0].height + 10;
    
    //添加可以退款的状态 1
    if ([[NSString stringWithFormat:@"%@",model.pay_status] isEqualToString:@"1"] &&(![orderStatis isEqualToString:@"waitrefund"] && ![orderStatis isEqualToString:@"refunded"])) {
        
        _refund.text = @"退款";
        _refund.hidden = NO;
        _refund.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:_orderStatis.text and:12.0].width - 16 - 10 - [self lableTextHeightWithSting:_refund.text and:12.0].width, (cellHeight-([self lableTextHeightWithSting:_refund.text and:12.0].height + 8))/2 , [self lableTextHeightWithSting:_refund.text and:12.0].width + 16, [self lableTextHeightWithSting:_refund.text and:12.0].height + 8);
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderStatisClick)];
        [_refund addGestureRecognizer:tapGes];
        _refund.layer.cornerRadius = 3.0;
        _refund.layer.borderWidth = 0.5;
        _refund.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;

    }else{
        _refund.hidden = YES;
    }
    
    _orderNum.frame = CGRectMake(10, 10, SCREENWIDTH - 10 - 16 - [self lableTextHeightWithSting:_refund.text and:12.0].width - 10 - 10 - [self lableTextHeightWithSting:_orderStatis.text and:12.0].width, [self lableTextHeightWithSting:_orderNum.text and:14.0].height);
    
    _bgView.frame = CGRectMake(0, 0, SCREENWIDTH, height);
}

-(CGFloat)cellHeight
{
    UILabel *_orderNum = (UILabel *)[self viewWithTag:20];
    UILabel *_orderPrice = (UILabel *)[self viewWithTag:60];
    
    _orderNum.text = [NSString stringWithFormat:@"订单号：%@",self.m_model.order_id];
    _orderPrice.text = [NSString stringWithFormat:@"实付款：￥%@",self.m_model.actmoney];
    
    CGFloat height = 10 + [self lableTextHeightWithSting:_orderNum.text and:14.0].height + 10 + 0.5 + 10 + [self lableTextHeightWithSting:_orderPrice.text and:14.0].height + 10 + 0.5 + 0.5 + 20 + 60;
    
    return height;
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-20, 999);
    CGSize user_newSize;
    user_newSize = [text boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return user_newSize;
}

-(void)orderStatisClick
{
    if (self.OrderStatisBlock) {
        self.OrderStatisBlock(self.m_model.actmoney);
    }
}

-(void)OrderStatisBlock:(OrderStatisBlock)block
{
    _OrderStatisBlock = block;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
