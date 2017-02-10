//
//  NoticeTableviewCell.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/13.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "NoticeTableviewCell.h"
#import "UIImageView+WebCache.h"
#import "DateUtil.h"
#import "NSString+SizeLayout.h"

@interface NoticeTableviewCell()
@property(nonatomic,strong)UIImageView * headImageView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIImageView * statusImageView;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *PropertyName;
@property(nonatomic,strong)UILabel *TimeLabel;
@property(nonatomic,strong)UIImageView *Qimage;
@property(nonatomic,strong)UIImageView *Limage;
@end


@implementation NoticeTableviewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGRect frame =self.frame;
    frame.size.width=SCREENWIDTH;
    self.frame=frame;
    
    
    CGFloat leftMargin=10;
    CGFloat topMargin=10;
    CGFloat widthImage=34;
    _Limage=[[UIImageView alloc] init];
    _Qimage=[[UIImageView alloc] init];
    _Limage.frame=CGRectMake(leftMargin-1.5, topMargin-1.5, widthImage, widthImage);
    _Qimage.frame=CGRectMake(leftMargin-3, topMargin-3, widthImage+3, widthImage+3);
    self.Qimage.layer.cornerRadius=self.Qimage.frame.size.width/2;
    self.Qimage.clipsToBounds=YES;
//    self.Qimage.backgroundColor=RGBCOLOR(60, 160, 180);
    
    self.Limage.layer.cornerRadius=self.Limage.frame.size.width/2;
    self.Limage.clipsToBounds=YES;
    self.Limage.backgroundColor=[UIColor whiteColor];
    
    
    _headImageView =[[UIImageView alloc] init];
    _headImageView.frame=CGRectMake(leftMargin, topMargin, widthImage, widthImage);
    _statusImageView =[[UIImageView alloc] init];
    _statusImageView.frame=CGRectMake(VIEW_W(self)-51-10, 0, 49, 49);
    // headImageView.image=[UIImage imageNamed:@"diandeng"];
    
    
    
    _titleLabel =[[UILabel alloc] init];
    _titleLabel.textColor =HexRGB(0x333333);
    _titleLabel.backgroundColor =CLEARCOLOR;
    _titleLabel =[UILabel labelWithFrame:CGRectZero title:@"" fontSize:15.0f background:CLEARCOLOR
                           lineBreakMode:NSLineBreakByCharWrapping];
    _titleLabel.frame=CGRectMake(VIEW_BX(_headImageView)+8, 0, VIEW_W(self)-53-20-49, 50);
    _lineView =[[UIView alloc] init];
    _lineView.backgroundColor=HexRGB(0xe0e0e0);
    _lineView.frame=CGRectMake(leftMargin, VIEW_BY(_titleLabel)+10, VIEW_W(self)-2*leftMargin, 1);
    
    _descLabel =[UILabel labelWithFrame:CGRectZero title:@"" fontSize:14.0f background:CLEARCOLOR lineBreakMode:NSLineBreakByWordWrapping];
    _descLabel.textColor=HexRGB(0x666666);
    _descLabel.frame=CGRectMake(20, VIEW_BY(_lineView)+5, VIEW_W(self)-20, 40);
    
    _PropertyName = [[UILabel alloc] init];
    _PropertyName.textColor=HexRGB(0x00b4a2);
    _PropertyName.font=[UIFont systemFontOfSize:12];
    _PropertyName.frame=CGRectMake(VIEW_W(self)-200, VIEW_BY(_descLabel)+20, 180, 12);
    _PropertyName.textAlignment=NSTextAlignmentRight;
    _TimeLabel = [[UILabel alloc] init];
    _TimeLabel.textColor=HexRGB(0x999999);
    _TimeLabel.font=[UIFont systemFontOfSize:12];
    _TimeLabel.frame=CGRectMake(VIEW_W(self)-120, VIEW_BY(_PropertyName)+10, 180, 12);
    
    [self.contentView addSubview:_Qimage];
    [self.contentView addSubview:_Limage];
    [self.contentView addSubview:_headImageView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_statusImageView];
    [self.contentView addSubview:_lineView];
    [self.contentView addSubview:_descLabel];
    [self.contentView addSubview:_PropertyName];
    [self.contentView addSubview:_TimeLabel];
    
}


-(void)configForCellWithData:(id)data
{
     NoticeModel*item;
    if([data isKindOfClass:[NoticeModel class]]){
        item=data;
    }
    if ([item.Property_logo isKindOfClass:[NSNull class]]) {
        item.Property_logo = @"";
    }
//    [_headImageView sd_setImageWithURL:[NSURL URLWithString:item.Property_logo]placeholderImage:[UIImage imageNamed:@"gmq_notice"]];
//    NSLog(@"zhi  %@",item.Level);
    if ([item.Property_logo isEqualToString:@""]) {
        _headImageView.image = [UIImage imageNamed:@"gmq_notice"] ;
    }else{
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:item.Property_logo]] ;
    }
    
    
    if ([@"1" isEqualToString:item.Level]) {
        
        _statusImageView.image =[UIImage imageNamed:@"tongzhi_jinji"];
    }else
        _statusImageView.image =[UIImage imageNamed:@""];
    
    _titleLabel.text=item.Title;
    // NSLog(@"1111111111111%@",self.item.Title);
    _descLabel.text=item.Content;
    CGRect frame=_descLabel.frame;
    CGSize affairSize=[_descLabel.text calculateSize:CGSizeMake(VIEW_W(self)-53-20, CGFLOAT_MAX) font:[UIFont systemFontOfSize:14.0f]];
    frame.size.height=affairSize.height;
    _descLabel.frame=frame;
    if ([item.Property_name isKindOfClass:[NSNull class]]) {
        item.Property_name = @"";
    }
    _PropertyName.text=item.Property_name;
    
    CGRect frame1=_PropertyName.frame;
    CGSize size = [_PropertyName.text calculateSize:CGSizeMake(VIEW_W(self)-180, CGFLOAT_MAX )font:[UIFont systemFontOfSize:12.0f]];
    frame1.size.height=size.height;
    
    double timeInterval=[item.Time doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter * dateFormatter = [DateUtil dateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dataStr=[dateFormatter stringFromDate:date];
    
    _TimeLabel.text=dataStr;
    CGRect frame2=_TimeLabel.frame;
    CGSize size1=[_TimeLabel.text calculateSize:CGSizeMake(VIEW_W(self)-120, CGFLOAT_MAX) font:[UIFont systemFontOfSize:12.0f]];
    frame2.size.height=size1.height;
}


-(CGFloat)heightForData:(id)data
{
    NoticeModel *item;
    if([data isKindOfClass:[NoticeModel class]])
    {
        item=data;
        NSString *text=item.Content;
        CGSize affairSize=[text calculateSize:CGSizeMake(SCREENWIDTH-53-20, CGFLOAT_MAX) font:[UIFont systemFontOfSize:14.0f]];
        return affairSize.height+70+55+30;
    }
    return 44;
}




@end
