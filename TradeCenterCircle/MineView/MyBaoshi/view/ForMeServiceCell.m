//
//  AffairRecordCell.m
//  YourMate
//
//  Created by Tang Shilei on 15/6/9.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

#import "ForMeServiceCell.h"
#import "UIImageView+WebCache.h"
#import "DateUtil.h"
#import "MyShowImgs.h"
#import "StarView.h"
#import "LineView.h"
#import "NSString+SizeLayout.h"
@interface ForMeServiceCell()
{
    UIImageView *headImageView;
    UILabel *titleLabel;
    UILabel *startTimeLabel;
    UIImageView *statusImageView;
    LineView *lineView;
    UILabel *descLabel;
    
    UIScrollView *imageScrollView;
    
    UIImageView *addressImageView;
    UILabel *addressLabel;
    UIImageView *endTimeImageView;
    UILabel *endTimeLabel;
    NSMutableArray *imageArray;
    
    UIImageView *csqImageView;
    UILabel *csqPhone;
    
    UIButton *callPhone;
    
    LineView *bottomLine;
    LineView *bottomView;
    
    
    UIImageView *csqVcImage;
    UILabel *serviceLab;
    
    //已完成
    UILabel *Ta_evaluation;//服务者对我的评价
    UILabel *Wo_evaluation;//我对服务者的评价
    LineView *Ta_evaluationLine;
    LineView *Wo_evaluationLine;
    UILabel *Ta_evaluationMes;
    UILabel *Wo_evaluationMes;
    
    UIButton *evaluationBtn;
    LineView *evaluationLine;
}
@property(nonatomic,weak)LineView *cancleView;
@property(nonatomic,weak)UILabel *cancleLabel;
@property(nonatomic,weak)UILabel *cancleMes;

@property(nonatomic,weak)LineView *Wo_complainInfoView;
@property(nonatomic,weak)UILabel *Wo_complainInfoLabel;
@property(nonatomic,weak)UILabel *Wo_complainInfoMes;
@end
@implementation ForMeServiceCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    headImageView =[[UIImageView alloc] init];
    titleLabel =[[UILabel alloc] init];
    titleLabel.font=[UIFont systemFontOfSize:15.0f];
    titleLabel.textColor =HexRGB(0x333333);
    titleLabel.backgroundColor =CLEARCOLOR;
    startTimeLabel =[[UILabel alloc]init];
    startTimeLabel.font =[UIFont systemFontOfSize:9.0f];
    startTimeLabel.textColor=HexRGB(0x999999);
    startTimeLabel.backgroundColor=CLEARCOLOR;
    
    statusImageView =[[UIImageView alloc] init];
    
    
    descLabel =[UILabel labelWithFrame:CGRectZero title:@"" fontSize:16.0f background:CLEARCOLOR lineBreakMode:NSLineBreakByWordWrapping];
    //    descLabel.textColor=HexRGB(0x666666);
    descLabel.textColor = [UIColor blackColor];
    
    addressImageView =[[UIImageView alloc] init];
    addressLabel =[[UILabel alloc] init];
    addressLabel.font=[UIFont systemFontOfSize:12.0f];
    addressLabel.backgroundColor=CLEARCOLOR;
    addressLabel.textColor=HexRGB(0x999999);
    endTimeImageView =[[UIImageView alloc] init];
    endTimeLabel =[[UILabel alloc] init];
    endTimeLabel.font=[UIFont systemFontOfSize:12.0f];
    endTimeLabel.backgroundColor=CLEARCOLOR;
    endTimeLabel.textColor=HexRGB(0x999999);
    
    csqImageView = [[UIImageView alloc]init];
    csqImageView.hidden = YES;
    
    csqPhone = [[UILabel alloc]init];
    csqPhone.hidden = YES;
    csqPhone.font = [UIFont systemFontOfSize:15];
    csqPhone.backgroundColor = CLEARCOLOR;
    csqPhone.textColor = HexRGB(0x333333);
    
    callPhone = [[UIButton alloc]init];
    callPhone.hidden = YES;
    [callPhone setBackgroundImage:[UIImage imageNamed:@"icon_phonecall"] forState:UIControlStateNormal];
    [callPhone addTarget:self action:@selector(clickCallPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    
    csqVcImage = [[UIImageView alloc]init];
    csqVcImage.hidden = YES;
    
    
    
    UILabel *cancleLabel = [[UILabel alloc]init];
    cancleLabel.font = [UIFont systemFontOfSize:12];
    cancleLabel.backgroundColor = CLEARCOLOR;
    cancleLabel.textColor = HexRGB(0x999999);
    cancleLabel.text = @"取消原因";
    cancleLabel.hidden = YES;
    self.cancleLabel = cancleLabel;
    
    UILabel *cancleMes = [[UILabel alloc]init];
    cancleMes.font = [UIFont systemFontOfSize:12];
    cancleMes.backgroundColor = CLEARCOLOR;
    cancleMes.textColor = HexRGB(0x333333);
    cancleMes.numberOfLines = 0;
    cancleMes.hidden = YES;
    self.cancleMes = cancleMes;
    
    Ta_evaluation = [[UILabel alloc]init];
    Ta_evaluation.font = [UIFont systemFontOfSize:12];
    Ta_evaluation.backgroundColor = CLEARCOLOR;
    Ta_evaluation.textColor = HexRGB(0x999999);
    Ta_evaluation.text = @"服务者对我的评价";
    Ta_evaluation.hidden = YES;
    
    Ta_evaluationMes = [[UILabel alloc]init];
    Ta_evaluationMes.font = [UIFont systemFontOfSize:12];
    Ta_evaluationMes.backgroundColor = CLEARCOLOR;
    Ta_evaluationMes.textColor = HexRGB(0x333333);
    Ta_evaluationMes.numberOfLines = 0;
    Ta_evaluationMes.hidden = YES;
    
    Wo_evaluation = [[UILabel alloc]init];
    Wo_evaluation.font = [UIFont systemFontOfSize:12];
    Wo_evaluation.backgroundColor = CLEARCOLOR;
    Wo_evaluation.textColor = HexRGB(0x999999);
    Wo_evaluation.text = @"我对服务者的评价";
    Wo_evaluation.hidden = YES;
    
    Wo_evaluationMes = [[UILabel alloc]init];
    Wo_evaluationMes.font = [UIFont systemFontOfSize:12];
    Wo_evaluationMes.backgroundColor = CLEARCOLOR;
    Wo_evaluationMes.textColor = HexRGB(0x333333);
    Wo_evaluationMes.numberOfLines = 0;
    Wo_evaluationMes.hidden = YES;
    
    serviceLab = [[UILabel alloc]init];
    serviceLab.hidden = YES;
    serviceLab.font = [UIFont systemFontOfSize:13];
    serviceLab.backgroundColor = CLEARCOLOR;
    serviceLab.textColor = HexRGB(0x999999);
    
    evaluationBtn = [[UIButton alloc]init];
    [evaluationBtn setImage:[UIImage imageNamed:@"fuwudan_pingjia"] forState:UIControlStateNormal];
    [evaluationBtn setTitle:@"评价服务者" forState:UIControlStateNormal];
    [evaluationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [evaluationBtn addTarget:self action:@selector(clickEvaluationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [evaluationBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20, -2, 0.0)];
    evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    evaluationBtn.hidden = YES;
    
    UILabel *Wo_complainInfoLabel = [[UILabel alloc]init];
    Wo_complainInfoLabel.font = [UIFont systemFontOfSize:12];
    Wo_complainInfoLabel.backgroundColor = CLEARCOLOR;
    Wo_complainInfoLabel.textColor = HexRGB(0x999999);
    Wo_complainInfoLabel.text = @"投诉";
    Wo_complainInfoLabel.hidden = YES;
    self.Wo_complainInfoLabel = Wo_complainInfoLabel;
    
    UILabel *Wo_complainInfoMes = [[UILabel alloc]init];
    Wo_complainInfoMes.font = [UIFont systemFontOfSize:12];
    Wo_complainInfoMes.backgroundColor = CLEARCOLOR;
    Wo_complainInfoMes.textColor = HexRGB(0x333333);
    Wo_complainInfoMes.numberOfLines = 0;
    Wo_complainInfoMes.hidden = YES;
    self.Wo_complainInfoMes = Wo_complainInfoMes;
    
    
    CGFloat leftMargin=10;
    CGFloat topMargin=10;
    CGFloat widthImage=30;
    headImageView.frame=CGRectMake(leftMargin, topMargin+5, widthImage, widthImage);
    titleLabel.frame=CGRectMake(VIEW_BX(headImageView)+8, topMargin, 100, 20);
    startTimeLabel.frame=CGRectMake(VIEW_BX(headImageView)+8, VIEW_BY(titleLabel)+5, 120, 9);
    
    
    statusImageView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-51-10, 18, 51, 24);
    descLabel.frame=CGRectMake(leftMargin, 60+5, [UIScreen mainScreen].bounds.size.width-53-20, 30);
    
    imageScrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
    imageScrollView.bounces=NO;
    imageScrollView.showsHorizontalScrollIndicator=NO;
    imageScrollView.showsVerticalScrollIndicator=NO;
    imageScrollView.userInteractionEnabled=YES;
    [self.contentView addSubview:imageScrollView];
    [self.contentView addSubview:headImageView];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:startTimeLabel];
    [self.contentView addSubview:statusImageView];
    [self.contentView addSubview:descLabel];
    
    [self.contentView addSubview:addressImageView];
    [self.contentView addSubview:addressLabel];
    [self.contentView addSubview:endTimeImageView];
    [self.contentView addSubview:endTimeLabel];
    [self.contentView addSubview:csqImageView];
    [self.contentView addSubview:csqPhone];
    [self.contentView addSubview:callPhone];
    
    
    [self.contentView addSubview:cancleLabel];
    [self.contentView addSubview:cancleMes];
    
    [self.contentView addSubview:csqVcImage];
    
    [self.contentView addSubview:Wo_complainInfoLabel];
    [self.contentView addSubview:Wo_complainInfoMes];
    
    [self.contentView addSubview:serviceLab];
    [self.contentView addSubview:Ta_evaluation];
    [self.contentView addSubview:Ta_evaluationMes];
    [self.contentView addSubview:Wo_evaluation];
    [self.contentView addSubview:Wo_evaluationMes];
    [self.contentView addSubview:evaluationBtn];
}

//完结和评价订单
-(void)clickEvaluationBtn:(UIButton *)btn
{
    if (self.evaluationBtnClick) {
        self.evaluationBtnClick(btn);
    }
}
//打电话
-(void)clickCallPhone:(UIButton *)btn
{
    if (self.btnClick) {
        self.btnClick(btn);
    }
}

//取消服务单
-(void)clickCancleOrderBtn:(UIButton *)btn
{
    if (self.CancleOrderBtnClick) {
        self.CancleOrderBtnClick(btn);
    }
}
-(void)setItem:(AffairRecordItem *)item
{
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[LineView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    addressImageView.image =[UIImage imageNamed:@"baoshi_location"];
    endTimeImageView.image=[UIImage imageNamed:@"baoshi_time"];
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:item.headImageUrl] placeholderImage:nil];
    
    titleLabel.text=item.title;
    [statusImageView sd_setImageWithURL:[NSURL URLWithString:item.Event_status] placeholderImage:nil];
    NSString *descText;
    if([item.desc isKindOfClass:[NSNull class]]||item.desc==nil||[item.desc isEqualToString:@""]){
        descText=@"";
    }else{
        descText=item.desc;
    }
    descLabel.text=descText;
    CGRect frame=descLabel.frame;
    CGSize affairSize=[descText calculateSize:CGSizeMake(VIEW_W(self)-53-20, CGFLOAT_MAX) font:[UIFont systemFontOfSize:14.0f]];
    frame.size.height=affairSize.height>=30?affairSize.height:30;
    descLabel.frame=frame;
    lineView =[[LineView alloc] init];
    lineView.backgroundColor=HexRGB(0xe0e0e0);
    lineView.frame=CGRectMake(10, 59, [UIScreen mainScreen].bounds.size.width-2*10, 1);
    [self.contentView addSubview:lineView];
    
    //tableview cell 复用  清除
    NSArray *array =imageScrollView.subviews;
    for(UIView *view in array)
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageView=(UIImageView*)view;
            [imageView removeFromSuperview];
            imageView.image=nil;
        }
    }
    
    CGFloat height=0;
    //无图片
    if([item.eventPics isKindOfClass:[NSNull class]]||item.eventPics==nil||[item.eventPics isEqualToString:@""]){
        height=VIEW_BY(descLabel);
    }
    else{
        
        CGFloat width = (VIEW_W(self)-VIEW_TX(descLabel)-20-10)/3;
        imageScrollView.frame=CGRectMake(VIEW_TX(descLabel), VIEW_BY(descLabel)+10, VIEW_W(self)-VIEW_TX(descLabel)-20, width);
        imageArray =[NSMutableArray arrayWithCapacity:0];
        imageArray =(NSMutableArray*)[item.eventPics componentsSeparatedByString:@","];
        NSUInteger count =imageArray.count;
        for(NSUInteger i=0;i<count;i++){
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(Origin_x+width*(i%3)+5*(i%3), Origin_y+width*(i/3)+5*(i/3), width, width)];
            imageView.tag=i;
            imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            
            [imageView addGestureRecognizer:gesture];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:nil];
            [imageScrollView addSubview:imageView];
            
        }
        NSInteger line =(count-1)/3+1;
        CGRect frame =imageScrollView.frame;
        frame.size.height=width*line+(line-1)*5;
        imageScrollView.frame=frame;
        height=VIEW_BY(descLabel)+width*line+(line-1)*5;
    }
    addressImageView.frame=CGRectMake(VIEW_TX(descLabel), height+20, 12, 12);
    addressLabel.frame=CGRectMake(VIEW_BX(addressImageView)+5, height+20, 200, 15);
    
    endTimeImageView.frame =CGRectMake(VIEW_TX(descLabel), VIEW_BY(addressLabel)+10+5, 12, 12);
    endTimeLabel.frame=CGRectMake(VIEW_BX(endTimeImageView)+5, VIEW_TY(endTimeImageView), 260, 15);
    addressLabel.text=item.address;
    
    bottomLine = [[LineView alloc]init];
    bottomLine.backgroundColor = HexRGB(0xe0e0e0);
    [self.contentView addSubview:bottomLine];
    bottomLine.frame = CGRectMake(10, VIEW_BY(endTimeLabel)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
    csqImageView.image = [UIImage imageNamed:@"touxiang"];
    csqImageView.frame = CGRectMake(10, VIEW_BY(bottomLine)+10, 30, 30);
    
    csqPhone.text = item.Nick_name;
    CGSize csqSize = [self sizeWithText:csqPhone.text WithFont:csqPhone.font WithMaxSize:CGSizeMake(MAXFLOAT, 20)];
    csqPhone.frame = CGRectMake(VIEW_BX(csqImageView)+10, VIEW_BY(bottomLine)+5, csqSize.width, csqSize.height);
    
    
    
    //解决cell复用的问题
    for (UIImageView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[StarView class]]) {
            [subView removeFromSuperview];
        }
        
    }
    
    CGFloat num = [item.Rank_star floatValue];
    int numInt = [item.Rank_star intValue];
    CGFloat starW = 10;
    CGFloat margin = 1;
    
    
    callPhone.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-40, VIEW_BY(bottomLine)+5, 40, 40);
    bottomView = [[LineView alloc]init];
    bottomView.backgroundColor = HexRGB(0xe0e0e0);
    [self.contentView addSubview:bottomView];
    
    //不是失效状态
    if (![item.Status isEqualToString:@"4"]) {
        
        csqImageView.hidden = NO;
        csqPhone.hidden = NO;
        callPhone.hidden = NO;
        csqVcImage.hidden = NO;
        serviceLab.hidden = NO;
        evaluationBtn.hidden = YES;
        for (int i=0; i<numInt; i++) {
            StarView *star = [[StarView alloc]init];
            star.image = [UIImage imageNamed:@"star_small_yellow"];
            star.frame = CGRectMake(VIEW_BX(csqImageView)+i*(starW+margin)+10, VIEW_BY(csqPhone)+10, starW, starW);
            [self.contentView addSubview:star];
        }
        if (num-numInt > 0) {
            StarView *star = [[StarView alloc]init];
            star.image = [UIImage imageNamed:@"star_small_half"];
            star.frame = CGRectMake(VIEW_BX(csqImageView)+10+numInt*(starW+margin), VIEW_BY(csqPhone)+5, starW, starW);
            [self.contentView addSubview:star];
        }
        
  //      csqVcImage.image = [UIImage imageNamed:@"icon_vcai"];
        csqVcImage.frame = CGRectMake(VIEW_BX(csqPhone)+10, VIEW_TY(csqPhone)+3, csqVcImage.image.size.width, csqVcImage.image.size.height);
        
        serviceLab.text = [NSString stringWithFormat:@"已服务%@单",item.Server_count];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:serviceLab.text];
        int a = [[str string] rangeOfString:@"务"].location;
        int b = [[str string] rangeOfString:@"单"].location;
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(a+1,b-a-1)];
        serviceLab.attributedText = str;
        
        CGSize serSize = [self sizeWithText:serviceLab.text WithFont:serviceLab.font WithMaxSize:CGSizeMake(MAXFLOAT, 20)];
        serviceLab.frame = CGRectMake(VIEW_BX(csqImageView)+10+(num-1)*(starW+margin)+10+10, VIEW_BY(csqPhone)+5, serSize.width, serSize.height);
        
        if(item.address.length > 0){
            
            addressImageView.hidden = NO;
            
        }else{
            
            addressImageView.hidden = YES;
            
        }
        
        //待响应
        if([item.Status isEqualToString:@"0"]){
            csqImageView.hidden = YES;
            csqPhone.hidden = YES;
            callPhone.hidden = YES;
            csqVcImage.hidden = YES;
            serviceLab.hidden = YES;
            Ta_evaluation.hidden = YES;
            Ta_evaluationMes.hidden = YES;
            Wo_evaluation.hidden = YES;
            Wo_evaluationMes.hidden = YES;
            self.cancleLabel.hidden = YES;
            self.cancleMes.hidden = YES;
            self.Wo_complainInfoLabel.hidden = YES;
            self.Wo_complainInfoMes.hidden = YES;
            bottomLine.hidden = YES;
            
            bottomView.frame = CGRectMake(Origin_x, VIEW_BY(bottomLine), [UIScreen mainScreen].bounds.size.width, 10);
        }
        //完成状态
        if ([item.Status isEqualToString:@"2"]) {
            
            self.cancleMes.hidden = YES;
            self.cancleLabel.hidden = YES;
            evaluationBtn.hidden = YES;
            
            if (item.Extra_info.count > 0) {
                csqImageView.hidden = NO;
                csqPhone.hidden = NO;
                csqVcImage.hidden = NO;
                callPhone.hidden = NO;
                serviceLab.hidden = NO;
                
            }else{
                csqImageView.hidden = YES;
                csqPhone.hidden = YES;
                csqVcImage.hidden = YES;
                callPhone.hidden = YES;
                serviceLab.hidden = YES;
            }
            
            //判断是否有服务者对我的评价
            if (item.Ta_evaluationDesc.length > 0) {
                Ta_evaluation.hidden = NO;
                Ta_evaluationMes.hidden = NO;
                evaluationBtn.hidden = YES;
                
                Ta_evaluationLine = [[LineView alloc]init];
                Ta_evaluationLine.backgroundColor = HexRGB(0xe0e0e0);
                if (item.Extra_info.count > 0) {
                    Ta_evaluationLine.frame = CGRectMake(10, VIEW_BY(callPhone)+10, [UIScreen mainScreen].bounds.size.width-20, 1);}
                else{
                    Ta_evaluationLine.frame = CGRectMake(10, VIEW_BY(endTimeLabel)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                }
                [self.contentView addSubview:Ta_evaluationLine];
                
                CGSize taSize = [self sizeWithText:Ta_evaluation.text WithFont:Ta_evaluation.font WithMaxSize:CGSizeMake(MAXFLOAT, 20)];
                
                Ta_evaluation.frame = CGRectMake(10, VIEW_BY(Ta_evaluationLine)+10, taSize.width, taSize.height);
                
                CGFloat num = [item.Ta_evaluationStar floatValue];
                int numInt = [item.Ta_evaluationStar intValue];
                
                for (int i=0; i<numInt; i++) {
                    StarView *star = [[StarView alloc]init];
                    star.image = [UIImage imageNamed:@"star_small_yellow"];
                    star.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30-i*(starW+margin), VIEW_TY(Ta_evaluation), starW, starW);
                    [self.contentView addSubview:star];
                }
                if (num-numInt > 0) {
                    StarView *star = [[StarView alloc]init];
                    star.image = [UIImage imageNamed:@"star_small_half"];
                    star.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30-numInt*(starW+margin), VIEW_TY(Ta_evaluation), starW, starW);
                    [self.contentView addSubview:star];
                }
                Ta_evaluationMes.text = item.Ta_evaluationDesc;
                CGSize ta_size = [self sizeWithText:Ta_evaluationMes.text WithFont:Ta_evaluationMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                Ta_evaluationMes.frame = CGRectMake(10, VIEW_BY(Ta_evaluation)+10, ta_size.width, ta_size.height);
                
                //判断是否有我对服务者的评价
                if (item.Wo_evaluationDesc.length > 0) {
                    
                    Wo_evaluation.hidden = NO;
                    Wo_evaluationMes.hidden = NO;
                    evaluationBtn.hidden = YES;
                    
                    Wo_evaluationLine = [[LineView alloc]init];
                    Wo_evaluationLine.backgroundColor = HexRGB(0xe0e0e0);
                    Wo_evaluationLine.frame = CGRectMake(10, VIEW_BY(Ta_evaluationMes)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                    [self.contentView addSubview:Wo_evaluationLine];
                    
                    CGSize woSize = [self sizeWithText:Wo_evaluation.text WithFont:Wo_evaluation.font WithMaxSize:CGSizeMake(MAXFLOAT, 20)];
                    
                    Wo_evaluation.frame = CGRectMake(10, VIEW_BY(Wo_evaluationLine)+10, woSize.width, woSize.height);
                    
                    CGFloat num = [item.Wo_evaluationStar floatValue];
                    int numInt = [item.Wo_evaluationStar intValue];
                    
                    for (int i=0; i<numInt; i++) {
                        StarView *star = [[StarView alloc]init];
                        star.image = [UIImage imageNamed:@"star_small_yellow"];
                        star.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30-i*(starW+margin), VIEW_TY(Wo_evaluation), starW, starW);
                        [self.contentView addSubview:star];
                    }
                    if (num-numInt > 0) {
                        StarView *star = [[StarView alloc]init];
                        star.image = [UIImage imageNamed:@"star_small_half"];
                        star.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30-numInt*(starW+margin), VIEW_TY(Wo_evaluation), starW, starW);
                        [self.contentView addSubview:star];
                    }
                    Wo_evaluationMes.text = item.Wo_evaluationDesc;
                    CGSize wo_size = [self sizeWithText:Wo_evaluationMes.text WithFont:Wo_evaluationMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                    Wo_evaluationMes.frame = CGRectMake(10, VIEW_BY(Wo_evaluation)+10, wo_size.width, wo_size.height);
                    
                    //投诉原因
                    if (item.Wo_complainInfo.length > 0) {
                        
                        self.Wo_complainInfoLabel.hidden = NO;
                        self.Wo_complainInfoMes.hidden = NO;
                        
                        LineView *Wo_complainInfoView = [[LineView alloc]init];
                        Wo_complainInfoView.backgroundColor = HexRGB(0xe0e0e0);
                        [self.contentView addSubview:Wo_complainInfoView];
                        Wo_complainInfoView.frame = CGRectMake(10, VIEW_BY(Wo_evaluationMes)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                        
                        CGSize infoLab = [self sizeWithText:self.Wo_complainInfoLabel.text WithFont:self.Wo_complainInfoLabel.font WithMaxSize:CGSizeMake(MAXFLOAT, 20)];
                        self.Wo_complainInfoLabel.frame = CGRectMake(10, VIEW_BY(Wo_complainInfoView)+10, infoLab.width, infoLab.height);
                        
                        self.Wo_complainInfoMes.text = item.Wo_complainInfo;
                        
                        //投诉原因
                        CGSize infoSize = [self sizeWithText:self.Wo_complainInfoMes.text WithFont:self.Wo_complainInfoMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                        
                        self.Wo_complainInfoMes.frame = CGRectMake(10, VIEW_BY(self.Wo_complainInfoLabel)+10, infoSize.width, infoSize.height);
                        
                        bottomView.frame = CGRectMake(Origin_x, VIEW_BY(self.Wo_complainInfoMes)+10, [UIScreen mainScreen].bounds.size.width, 10);
                        
                    }else{
                        
                        //没有投诉原因
                        self.Wo_complainInfoLabel.hidden = YES;
                        self.Wo_complainInfoMes.hidden = YES;
                        bottomView.frame = CGRectMake(Origin_x, VIEW_BY(Wo_evaluationMes)+10, [UIScreen mainScreen].bounds.size.width, 10);
                    }
                    
                }else{
                    
                    //没有我对服务者的评价
                    Wo_evaluation.hidden = YES;
                    Wo_evaluationMes.hidden = YES;
                    evaluationBtn.hidden = YES;
                    
                    //投诉原因
                    if (item.Wo_complainInfo.length > 0) {
                        
                        self.Wo_complainInfoLabel.hidden = NO;
                        self.Wo_complainInfoMes.hidden = NO;
                        
                        LineView *Wo_complainInfoView = [[LineView alloc]init];
                        Wo_complainInfoView.backgroundColor = HexRGB(0xe0e0e0);
                        [self.contentView addSubview:Wo_complainInfoView];
                        Wo_complainInfoView.frame = CGRectMake(10, VIEW_BY(Wo_evaluationMes)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                        
                        CGSize infoLab = [self sizeWithText:self.Wo_complainInfoLabel.text WithFont:self.Wo_complainInfoLabel.font WithMaxSize:CGSizeMake(MAXFLOAT, 20)];
                        self.Wo_complainInfoLabel.frame = CGRectMake(10, VIEW_BY(Wo_complainInfoView)+10, infoLab.width, infoLab.height);
                        
                        self.Wo_complainInfoMes.text = item.Wo_complainInfo;
                        
                        //投诉原因
                        CGSize infoSize = [self sizeWithText:self.Wo_complainInfoMes.text WithFont:self.Wo_complainInfoMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                        
                        self.Wo_complainInfoMes.frame = CGRectMake(10, VIEW_BY(self.Wo_complainInfoLabel)+10, infoSize.width, infoSize.height);
                        
                        evaluationBtn.hidden = NO;
                        evaluationLine =[[LineView alloc] init];
                        evaluationLine.backgroundColor=HexRGB(0xe0e0e0);
                        evaluationLine.frame=CGRectMake(10, VIEW_BY(self.Wo_complainInfoMes)+10, [UIScreen mainScreen].bounds.size.width-2*10, 1);
                        [self.contentView addSubview:evaluationLine];
                        evaluationBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2, VIEW_BY(evaluationLine)+10, 150, 30);
                        bottomView.frame = CGRectMake(Origin_x, VIEW_BY(evaluationBtn)+10, [UIScreen mainScreen].bounds.size.width, 10);
                        
                        
                    }else{
                        
                        //没有投诉原因
                        self.Wo_complainInfoLabel.hidden = YES;
                        self.Wo_complainInfoMes.hidden = YES;
                        
                        evaluationBtn.hidden = NO;
                        evaluationLine =[[LineView alloc] init];
                        evaluationLine.backgroundColor=HexRGB(0xe0e0e0);
                        evaluationLine.frame=CGRectMake(10, VIEW_BY(Wo_evaluationMes)+10, [UIScreen mainScreen].bounds.size.width-2*10, 1);
                        [self.contentView addSubview:evaluationLine];
                        evaluationBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2, VIEW_BY(evaluationLine)+10, 150, 30);
                        bottomView.frame = CGRectMake(Origin_x, VIEW_BY(evaluationBtn)+10, [UIScreen mainScreen].bounds.size.width, 10);
                        
                    }
                    
                }
                
                
            }else{
                
                //没有服务者对我的评价
                Ta_evaluation.hidden = YES;
                Ta_evaluationMes.hidden = YES;
                evaluationBtn.hidden = YES;
                
                if (item.Wo_evaluationDesc.length > 0) {
                    
                    Wo_evaluation.hidden = NO;
                    Wo_evaluationMes.hidden = NO;
                    
                    Wo_evaluationLine = [[LineView alloc]init];
                    Wo_evaluationLine.backgroundColor = HexRGB(0xe0e0e0);
                    if (item.Extra_info.count>0) {
                        Wo_evaluationLine.frame = CGRectMake(10, VIEW_BY(callPhone)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                    }else{
                        Wo_evaluationLine.frame = CGRectMake(10, VIEW_BY(endTimeLabel)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                    }
                    
                    [self.contentView addSubview:Wo_evaluationLine];
                    
                    CGSize woSize = [self sizeWithText:Wo_evaluation.text WithFont:Wo_evaluation.font WithMaxSize:CGSizeMake(MAXFLOAT, 20)];
                    
                    Wo_evaluation.frame = CGRectMake(10, VIEW_BY(Wo_evaluationLine)+10, woSize.width, woSize.height);
                    
                    CGFloat num = [item.Wo_evaluationStar floatValue];
                    int numInt = [item.Wo_evaluationStar intValue];
                    
                    for (int i=0; i<numInt; i++) {
                        StarView *star = [[StarView alloc]init];
                        star.image = [UIImage imageNamed:@"star_small_yellow"];
                        star.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30-i*(starW+margin), VIEW_TY(Wo_evaluation), starW, starW);
                        [self.contentView addSubview:star];
                    }
                    if (num-numInt > 0) {
                        StarView *star = [[StarView alloc]init];
                        star.image = [UIImage imageNamed:@"star_small_half"];
                        star.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30-numInt*(starW+margin), VIEW_TY(Wo_evaluation), starW, starW);
                        [self.contentView addSubview:star];
                    }
                    Wo_evaluationMes.text = item.Wo_evaluationDesc;
                    CGSize wo_size = [self sizeWithText:Wo_evaluationMes.text WithFont:Wo_evaluationMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                    Wo_evaluationMes.frame = CGRectMake(10, VIEW_BY(Wo_evaluation)+10, wo_size.width, wo_size.height);
                    
                    //投诉原因
                    if (item.Wo_complainInfo.length > 0) {
                        
                        self.Wo_complainInfoLabel.hidden = NO;
                        self.Wo_complainInfoMes.hidden = NO;
                        
                        LineView *Wo_complainInfoView = [[LineView alloc]init];
                        Wo_complainInfoView.backgroundColor = HexRGB(0xe0e0e0);
                        [self.contentView addSubview:Wo_complainInfoView];
                        Wo_complainInfoView.frame = CGRectMake(10, VIEW_BY(Wo_evaluationMes)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                        
                        CGSize infoLab = [self sizeWithText:self.Wo_complainInfoLabel.text WithFont:self.Wo_complainInfoLabel.font WithMaxSize:CGSizeMake(MAXFLOAT, 20)];
                        self.Wo_complainInfoLabel.frame = CGRectMake(10, VIEW_BY(Wo_complainInfoView)+10, infoLab.width, infoLab.height);
                        
                        self.Wo_complainInfoMes.text = item.Wo_complainInfo;
                        //投诉原因
                        CGSize infoSize = [self sizeWithText:self.Wo_complainInfoMes.text WithFont:self.Wo_complainInfoMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                        
                        self.Wo_complainInfoMes.frame = CGRectMake(10, VIEW_BY(self.Wo_complainInfoLabel)+10, infoSize.width, infoSize.height);
                        
                        bottomView.frame = CGRectMake(Origin_x, VIEW_BY(self.Wo_complainInfoMes)+10, [UIScreen mainScreen].bounds.size.width, 10);
                        
                    }else{
                        
                        //没有投诉原因
                        self.Wo_complainInfoLabel.hidden = YES;
                        self.Wo_complainInfoMes.hidden = YES;
                        bottomView.frame = CGRectMake(Origin_x, VIEW_BY(Wo_evaluationMes)+10, [UIScreen mainScreen].bounds.size.width, 10);
                    }
                    
                }else{
                    //没有我对服务者的评价
                    Wo_evaluation.hidden = YES;
                    Wo_evaluationMes.hidden = YES;
                    
                    
                    //投诉原因
                    if (item.Wo_complainInfo.length > 0) {
                        
                        self.Wo_complainInfoLabel.hidden = NO;
                        self.Wo_complainInfoMes.hidden = NO;
                        
                        LineView *Wo_complainInfoView = [[LineView alloc]init];
                        Wo_complainInfoView.backgroundColor = HexRGB(0xe0e0e0);
                        [self.contentView addSubview:Wo_complainInfoView];
                        if (item.Extra_info.count>0) {
                            Wo_complainInfoView.frame = CGRectMake(10, VIEW_BY(callPhone)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                        }else{
                            Wo_complainInfoView.frame = CGRectMake(10, VIEW_BY(bottomLine)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                        }
                        
                        
                        CGSize infoLab = [self sizeWithText:self.Wo_complainInfoLabel.text WithFont:self.Wo_complainInfoLabel.font WithMaxSize:CGSizeMake(MAXFLOAT, 20)];
                        self.Wo_complainInfoLabel.frame = CGRectMake(10, VIEW_BY(Wo_complainInfoView)+10, infoLab.width, infoLab.height);
                        
                        self.Wo_complainInfoMes.text = item.Wo_complainInfo;
                        //投诉原因
                        CGSize infoSize = [self sizeWithText:self.Wo_complainInfoMes.text WithFont:self.Wo_complainInfoMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                        
                        self.Wo_complainInfoMes.frame = CGRectMake(10, VIEW_BY(self.Wo_complainInfoLabel)+10, infoSize.width, infoSize.height);
                        
                        
                        
                        evaluationBtn.hidden = NO;
                        evaluationLine =[[LineView alloc] init];
                        evaluationLine.backgroundColor=HexRGB(0xe0e0e0);
                        evaluationLine.frame=CGRectMake(10, VIEW_BY(self.Wo_complainInfoMes)+10, [UIScreen mainScreen].bounds.size.width-2*10, 1);
                        [self.contentView addSubview:evaluationLine];
                        evaluationBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2, VIEW_BY(evaluationLine)+10, 150, 30);
                        
                        bottomView.frame = CGRectMake(Origin_x, VIEW_BY(evaluationBtn)+10, [UIScreen mainScreen].bounds.size.width, 10);
                        
                        
                        
                        
                    }else{
                        
                        //没有投诉原因
                        self.Wo_complainInfoLabel.hidden = YES;
                        self.Wo_complainInfoMes.hidden = YES;
                        
                        evaluationBtn.hidden = NO;
                        evaluationLine =[[LineView alloc] init];
                        evaluationLine.backgroundColor=HexRGB(0xe0e0e0);
                        if (item.Extra_info.count>0) {
                            evaluationLine.frame=CGRectMake(10, VIEW_BY(callPhone)+10, [UIScreen mainScreen].bounds.size.width-2*10, 1);
                        }else{
                            evaluationLine.frame=CGRectMake(10, VIEW_BY(endTimeLabel)+10, [UIScreen mainScreen].bounds.size.width-2*10, 1);
                        }
                        
                        [self.contentView addSubview:evaluationLine];
                        evaluationBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2, VIEW_BY(evaluationLine)+10, 150, 30);
                        
                        bottomView.frame = CGRectMake(Origin_x, VIEW_BY(evaluationBtn)+10, [UIScreen mainScreen].bounds.size.width, 10);
                        
                    }
                    
                    
                    
                    
                    
                    
                }
                
            }
        }else{
            
            //不是完成状态
            Ta_evaluation.hidden = YES;
            Ta_evaluationMes.hidden = YES;
            Wo_evaluation.hidden = YES;
            Wo_evaluationMes.hidden = YES;
            self.Wo_complainInfoMes.hidden = YES;
            self.Wo_complainInfoLabel.hidden = YES;
            self.cancleMes.hidden = YES;
            self.cancleLabel.hidden = YES;
            evaluationBtn.hidden = YES;
            
            //已取消状态
            if ([item.Status isEqualToString:@"3"]) {
                
                if (item.Nick_name.length > 0) {
                    
                    //有取消信息
                    if (item.Cancel_msg.length > 0) {
                        
                        self.cancleLabel.hidden = NO;
                        self.cancleMes.hidden = NO;
                        
                        LineView *cancleView = [[LineView alloc]init];
                        cancleView.backgroundColor = HexRGB(0xe0e0e0);
                        [self.contentView addSubview:cancleView];
                        cancleView.frame = CGRectMake(10, VIEW_BY(callPhone)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                        
                        CGSize cancle_size = [self sizeWithText:self.cancleLabel.text WithFont:self.cancleLabel.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                        self.cancleLabel.frame = CGRectMake(10, VIEW_BY(cancleView)+10, cancle_size.width, cancle_size.height);
                        
                        self.cancleMes.text = item.Cancel_msg;
                        CGSize cancleMes_size = [self sizeWithText:self.cancleMes.text WithFont:self.cancleMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                        self.cancleMes.frame = CGRectMake(10, VIEW_BY(self.cancleLabel)+10, cancleMes_size.width, cancleMes_size.height);
                        
                        //有投诉信息
                        if(item.Wo_complainInfo.length > 0){
                            
                            self.Wo_complainInfoLabel.hidden = NO;
                            self.Wo_complainInfoMes.hidden = NO;
                            
                            LineView *Wo_complainInfoView = [[LineView alloc]init];
                            Wo_complainInfoView.backgroundColor = HexRGB(0xe0e0e0);
                            [self.contentView addSubview:Wo_complainInfoView];
                            Wo_complainInfoView.frame = CGRectMake(10, VIEW_BY(self.cancleMes)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                            
                            CGSize complain_size = [self sizeWithText:self.Wo_complainInfoLabel.text WithFont:self.Wo_complainInfoLabel.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                            self.Wo_complainInfoLabel.frame = CGRectMake(10, VIEW_BY(Wo_complainInfoView)+10, complain_size.width, complain_size.height);
                            
                            self.Wo_complainInfoMes.text = item.Wo_complainInfo;
                            CGSize complainMes_size = [self sizeWithText:self.Wo_complainInfoMes.text WithFont:self.Wo_complainInfoMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                            self.Wo_complainInfoMes.frame = CGRectMake(10, VIEW_BY(self.Wo_complainInfoLabel)+10, complainMes_size.width, complainMes_size.height);
                            
                            bottomView.frame = CGRectMake(Origin_x, VIEW_BY(self.Wo_complainInfoMes)+10, [UIScreen mainScreen].bounds.size.width, 10);
                            
                        }else{
                            
                            //没有投诉信息
                            self.Wo_complainInfoLabel.hidden = YES;
                            self.Wo_complainInfoMes.hidden = YES;
                            bottomView.frame = CGRectMake(Origin_x, VIEW_BY(self.cancleMes)+10, [UIScreen mainScreen].bounds.size.width, 10);
                            
                        }
                        
                    }else{
                        
                        //没有取消信息
                        self.cancleLabel.hidden = YES;
                        self.cancleMes.hidden = YES;
                    }
                    
                }else{
                    
                    csqImageView.hidden = YES;
                    csqPhone.hidden = YES;
                    callPhone.hidden = YES;
                    csqVcImage.hidden = YES;
                    serviceLab.hidden = YES;
                    bottomLine.hidden = YES;
                    for (UIView *subView in self.contentView.subviews) {
                        if ([subView isKindOfClass:[StarView class]]) {
                            [subView removeFromSuperview];
                        }
                    }
                    //有取消信息
                    if (item.Cancel_msg.length > 0) {
                        
                        self.cancleLabel.hidden = NO;
                        self.cancleMes.hidden = NO;
                        
                        LineView *cancleView = [[LineView alloc]init];
                        cancleView.backgroundColor = HexRGB(0xe0e0e0);
                        [self.contentView addSubview:cancleView];
                        cancleView.frame = CGRectMake(10, VIEW_BY(endTimeLabel)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                        
                        CGSize cancle_size = [self sizeWithText:self.cancleLabel.text WithFont:self.cancleLabel.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                        self.cancleLabel.frame = CGRectMake(10, VIEW_BY(cancleView)+10, cancle_size.width, cancle_size.height);
                        
                        self.cancleMes.text = item.Cancel_msg;
                        CGSize cancleMes_size = [self sizeWithText:self.cancleMes.text WithFont:self.cancleMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                        self.cancleMes.frame = CGRectMake(10, VIEW_BY(self.cancleLabel)+10, cancleMes_size.width, cancleMes_size.height);
                        
                        //有投诉信息
                        if(item.Wo_complainInfo.length > 0){
                            
                            self.Wo_complainInfoLabel.hidden = NO;
                            self.Wo_complainInfoMes.hidden = NO;
                            
                            LineView *Wo_complainInfoView = [[LineView alloc]init];
                            Wo_complainInfoView.backgroundColor = HexRGB(0xe0e0e0);
                            [self.contentView addSubview:Wo_complainInfoView];
                            Wo_complainInfoView.frame = CGRectMake(10, VIEW_BY(self.cancleMes)+10, [UIScreen mainScreen].bounds.size.width-20, 1);
                            
                            CGSize complain_size = [self sizeWithText:self.Wo_complainInfoLabel.text WithFont:self.Wo_complainInfoLabel.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                            self.Wo_complainInfoLabel.frame = CGRectMake(10, VIEW_BY(Wo_complainInfoView)+10, complain_size.width, complain_size.height);
                            
                            self.Wo_complainInfoMes.text = item.Wo_complainInfo;
                            CGSize complainMes_size = [self sizeWithText:self.Wo_complainInfoMes.text WithFont:self.Wo_complainInfoMes.font WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
                            self.Wo_complainInfoMes.frame = CGRectMake(10, VIEW_BY(self.Wo_complainInfoLabel)+10, complainMes_size.width, complainMes_size.height);
                            
                            bottomView.frame = CGRectMake(Origin_x, VIEW_BY(self.Wo_complainInfoMes)+10, [UIScreen mainScreen].bounds.size.width, 10);
                            
                        }else{
                            
                            //没有投诉信息
                            self.Wo_complainInfoLabel.hidden = YES;
                            self.Wo_complainInfoMes.hidden = YES;
                            bottomView.frame = CGRectMake(Origin_x, VIEW_BY(self.cancleMes)+10, [UIScreen mainScreen].bounds.size.width, 10);
                            
                        }
                        
                    }else{
                        
                        //没有取消信息
                        self.cancleLabel.hidden = YES;
                        self.cancleMes.hidden = YES;
                    }
                    
                }
                
                
                
                
                
            }else{
                
                self.cancleLabel.hidden = YES;
                self.cancleMes.hidden = YES;
            }
            
        }
        
        
        
    }else{
        
        csqImageView.hidden = YES;
        csqPhone.hidden = YES;
        callPhone.hidden = YES;
        csqVcImage.hidden = YES;
        serviceLab.hidden = YES;
        Ta_evaluation.hidden = YES;
        Ta_evaluationMes.hidden = YES;
        Wo_evaluation.hidden = YES;
        Wo_evaluationMes.hidden = YES;
        self.cancleLabel.hidden = YES;
        self.cancleMes.hidden = YES;
        self.Wo_complainInfoLabel.hidden = YES;
        self.Wo_complainInfoMes.hidden = YES;
        bottomLine.hidden = YES;
        
        bottomView.frame = CGRectMake(Origin_x, VIEW_BY(bottomLine), [UIScreen mainScreen].bounds.size.width, 10);
    }
    
    
    
    
    double  timeInterval =[item.createTime doubleValue];
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateStr=[DateUtil formatDateFromDate:date];
    
    startTimeLabel.text=dateStr;
    
    double startTime =[item.startTime doubleValue];
    double endTime =[item.endTime doubleValue];
    
    NSDate *start =[NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *end =[NSDate dateWithTimeIntervalSince1970:endTime];
    
    
    NSString *dateStart =[DateUtil formatDateFromDate:start];
    NSString *dateEnd =[DateUtil formatDateFromDate:end];
    NSString *startTemp = [dateStart componentsSeparatedByString:@" "][0];
    NSString *endTemp = [dateEnd componentsSeparatedByString:@" "][0];
    NSString *dateEnd1 =[dateEnd componentsSeparatedByString:@" "][1];
    if ([startTemp isEqualToString:endTemp]) {
        endTimeLabel.text=[NSString stringWithFormat:@"%@~%@",dateStart,dateEnd1];
    }else{
        endTimeLabel.text=[NSString stringWithFormat:@"%@~%@",dateStart,dateEnd];
    }
}


-(CGFloat)rowHeightForItem:(AffairRecordItem *)item
{
    NSArray *array =[NSArray array];
    CGFloat height=0;
    //无图片
    if([item.eventPics isKindOfClass:[NSNull class]]||item.eventPics==nil||[item.eventPics isEqualToString:@""]){
        height=0;
    }else{
        array =[item.eventPics componentsSeparatedByString:@","];
        NSUInteger count =array.count;
        CGFloat width = (SCREENWIDTH-53-20)/3;
        NSInteger line =(count-1)/3+1;
        height=width*line+10;
    }
    
    NSString *descText;
    if([item.desc isKindOfClass:[NSNull class]]||item.desc==nil||[item.desc isEqualToString:@""]){
        descText=@"";
    }else{
        descText=item.desc;
    }
    
    NSString *text=descText;
    CGSize affairSize=[text calculateSize:CGSizeMake(SCREENWIDTH-53-20, CGFLOAT_MAX) font:[UIFont systemFontOfSize:14.0f]];
    
    CGFloat OtherHeightSencond;
    
    CGSize cancleSize = [self sizeWithText:item.Cancel_msg WithFont:[UIFont systemFontOfSize:12] WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
    
    
    CGSize infoSize = [self sizeWithText:item.Wo_complainInfo WithFont:[UIFont systemFontOfSize:12] WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)];
    
    CGSize ta_size = [self sizeWithText:item.Ta_evaluationDesc WithFont:[UIFont systemFontOfSize:12]WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT)];
    
    
    
    CGSize wo_size = [self sizeWithText:item.Wo_evaluationDesc WithFont:[UIFont systemFontOfSize:12] WithMaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT)];
    
    
    if (![item.Status isEqualToString:@"4"]) {
        
        //待响应
        if ([item.Status isEqualToString:@"0"]) {
            OtherHeightSencond = -60;
        }
        //已完成
        if ([item.Status isEqualToString:@"2"]) {
            
            if (item.Extra_info.count>0) {
                
                
                if (item.Ta_evaluationDesc.length > 0) {
                    
                    if (item.Wo_evaluationDesc.length > 0) {
                        
                        
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+ta_size.height+40+wo_size.height+40+infoSize.height+10;
                            
                        }else{
                            
                            OtherHeightSencond = 40+ta_size.height+40+wo_size.height+10;
                            
                        }
                        
                    }else{
                        
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+ta_size.height+40+infoSize.height+10;
                            
                        }else{
                            
                            OtherHeightSencond = 40+ta_size.height+10;
                            
                        }
                        
                    }
                    
                }else{
                    
                    if (item.Wo_evaluationDesc.length > 0) {
                        
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+wo_size.height+40+infoSize.height+10;
                            
                        }else{
                            
                            OtherHeightSencond = 40+wo_size.height+10;
                            
                        }
                        
                    }else{
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+infoSize.height+10+50;
                            
                        }else{
                            
                            OtherHeightSencond = 10+50;
                            
                        }
                    }
                    
                }
            }else{
                if (item.Ta_evaluationDesc.length > 0) {
                    
                    if (item.Wo_evaluationDesc.length > 0) {
                        
                        
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+wo_size.height+40+infoSize.height+10-50;
                            
                        }else{
                            
                            OtherHeightSencond = 40+wo_size.height+10-50;
                            
                        }
                        
                    }else{
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+infoSize.height+10+50;
                            
                        }else{
                            
                            OtherHeightSencond = 10+50;
                            
                        }
                    }
                    
                }else{
                    
                    if (item.Wo_evaluationDesc.length > 0) {
                        
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+wo_size.height+40+infoSize.height+10-50;
                            
                        }else{
                            
                            OtherHeightSencond = 40+wo_size.height+10-50;
                            
                        }
                        
                    }else{
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+infoSize.height+10;
                            
                        }else{
                            
                            OtherHeightSencond = 0;
                            
                        }
                        
                    }
                }
            }
            
        }else{
            
            //已取消
            if ([item.Status isEqualToString:@"3"]) {
                
                if (item.Nick_name.length > 0) {
                    
                    if (item.Cancel_msg.length > 0) {
                        
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+cancleSize.height+40+infoSize.height+10;
                        }else{
                            OtherHeightSencond = 40+cancleSize.height+10;
                        }
                    }else{
                        OtherHeightSencond = 10;
                    }
                    
                }else{
                    
                    if (item.Cancel_msg.length > 0) {
                        
                        if (item.Wo_complainInfo.length > 0) {
                            
                            OtherHeightSencond = 40+cancleSize.height+40+infoSize.height+10-70;
                        }else{
                            OtherHeightSencond = 40+cancleSize.height+10-70;
                        }
                    }else{
                        OtherHeightSencond = 10-70;
                    }
                }
            }
        }
        
        
        
    }else{
        
        OtherHeightSencond = -60;
        
    }
    
    return ((affairSize.height>=30)?(affairSize.height):30)+70+10+2*15+20+10+height+50+20+OtherHeightSencond;
}

-(void)tap:(UITapGestureRecognizer*)gesture
{
    NSLog(@"。。。点击图片");
    NSMutableArray *picArr =[NSMutableArray arrayWithCapacity:0];
    UIImageView *imageView=(UIImageView*)gesture.view;
    UIScrollView *mScrollView=(UIScrollView*)imageView.superview;
    for(UIView *view in mScrollView.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            UIImageView *imageView=(UIImageView *)view;
            UIImage *image=imageView.image;
            if(image!=nil){
                [picArr addObject:image];
            }
            
        }
    }
    MyShowImgs *s = [[MyShowImgs alloc] initWithFrame:[UIScreen mainScreen].bounds];
    s.imgs = picArr;
    s.index = imageView.tag;
    [s show];
}

-(CGSize)sizeWithText:(NSString *)text WithFont:(UIFont *)font WithMaxSize:(CGSize )maxSize
{
    NSDictionary *attri = @{NSFontAttributeName :font};
    return  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
}

@end
