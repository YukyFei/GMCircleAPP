//
//  ListCellView.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/11/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "ListCellView.h"

@interface ListCellView()

@end
@implementation ListCellView


+(instancetype)viewWithFrame:(CGRect)frame andImage:(NSString *)imageName andTitle:(NSString *)title andBlock:(listCellBlock)block
{
    ListCellView *view = [[ListCellView alloc] initWithFrame:frame andImage:imageName andTitle:title andBlock:block];
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)imageName andTitle:(NSString *)title andBlock:(listCellBlock)block
{
    if(self = [super initWithFrame:frame])
        
    {
        _mBlock = [block copy];
        UIImageView *imageView;
        if (imageName != nil) {
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_H(self), VIEW_H(self))];
            imageView.image = [UIImage imageNamed:imageName];
            imageView.userInteractionEnabled = YES;
            [self addSubview:imageView];
        }
        _title = [UILabel labelWithFrame:CGRectMake(VIEW_BX(imageView)+10, 7, 260, 30) title:title fontSize:15.0f background:CLEARCOLOR];
        _title.font = [UIFont systemFontOfSize:16.0];
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_title];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_W(self)-10-11, (48-21)/2, 11, 21)];
        imageView2.image = [UIImage imageNamed:@"goto_link"];
        imageView2.userInteractionEnabled = YES;
        [self addSubview:imageView2];
        UITapGestureRecognizer *getsure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:getsure];
        
    }
    
    return self;
}
+(instancetype)viewWithFramea:(CGRect)frame andImagea:(NSString *)imageName andTitlea:(NSString *)title andBlocka:(listCellBlock)block
{
    ListCellView *view = [[ListCellView alloc] initWithViewFramea:frame andImagea:imageName andTitlea:title andBlocka:block];
    
    return view;
}

-(instancetype)initWithViewFramea:(CGRect)frame andImagea:(NSString *)imageName andTitlea:(NSString *)title andBlocka:(listCellBlock)block
{
    if(self = [super initWithFrame:frame])
        
    {
        _mBlock = [block copy];
        UIImageView *imageView;
        if (imageName != nil) {
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (50-20)/2, 20, 20)];
            imageView.image = [UIImage imageNamed:imageName];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.userInteractionEnabled = YES;
            [self addSubview:imageView];
        }
        _title = [UILabel labelWithFrame:CGRectMake(imageView.right + 10, 10, SCREENWIDTH-10-20-10-11-10, 30) title:title fontSize:16.0f background:CLEARCOLOR];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_title];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_W(self)-21, (48-21)/2, 11, 21)];
        imageView2.image = [UIImage imageNamed:@"goto_link"];
        imageView2.userInteractionEnabled = YES;
        imageView2.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView2];
        UITapGestureRecognizer *getsure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:getsure];
        
    }
    
    return self;
}

-(instancetype)initWithViewFrame:(CGRect)frame andImage:(NSString *)imageName andTitle:(NSString *)title andBlock:(listCellBlock)block
{
    if(self = [super initWithFrame:frame])
        
    {
        _mBlock = [block copy];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        //圆形头像
        _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;
        _imageView.clipsToBounds = YES;
        
        _imageView.image = [UIImage imageNamed:imageName];
        _imageView.userInteractionEnabled = YES;
        _title = [UILabel labelWithFrame:CGRectMake(VIEW_BX(_imageView)+10, 25, 260, 30) title:title fontSize:16.0f background:CLEARCOLOR];
        [self addSubview:_imageView];
        [self addSubview:_title];
        UITapGestureRecognizer *getsure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:getsure];
        
    }
    
    return self;
}

/**
 * 个人信息页新增三个cell类型
 */
+(instancetype)headViewWithFrame:(CGRect)frame andTitle:(NSString *)title amdSubTitle:(NSString *)subtitle andBlock:(listCellBlock)block
{
    ListCellView *view = [[ListCellView alloc]initWithHeadViewFrame:frame andTitle:title andSubTitle:subtitle andBlock:^{
        
    }];
    return view;
}
-(instancetype)initWithHeadViewFrame:(CGRect)frame andTitle:(NSString *)title andSubTitle:(NSString *)subtitle andBlock:(listCellBlock)block
{
    if(self = [super initWithFrame:frame])
        
    {
        _mBlock = [block copy];
        _title = [UILabel labelWithFrame:CGRectMake(10, 10, 100, 30) title:title fontSize:16.0f background:CLEARCOLOR];
        _subTitle = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_W(self)-200, 10, 150, 30)];
        _subTitle.textColor =[UIColor grayColor] ;
        _subTitle.textAlignment = NSTextAlignmentRight ;
        [self addSubview:_title];
        [self addSubview:_subTitle];
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_W(self)-30, 18, 10, 10)];
        imageView2.image = [UIImage imageNamed:@"goto_link"];
        imageView2.userInteractionEnabled = YES;
        [self addSubview:imageView2];
        
        UITapGestureRecognizer *getsure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:getsure];
        
    }
    return self;
}

+(instancetype)headViewWithFrame:(CGRect)frame andTitle:(NSString *)title  andBlock:(listCellBlock)block
{
    ListCellView *view = [[ListCellView alloc]initWithHeadViewFrame:frame andTitle:title andBlock:^{
        
    }];
    return view;
}

-(instancetype)initWithHeadViewFrame:(CGRect)frame andTitle:(NSString *)title andBlock:(listCellBlock)block
{
    if(self = [super initWithFrame:frame])
        
    {
        _mBlock = [block copy];
        _title = [UILabel labelWithFrame:CGRectMake(10, 10, 260, 30) title:title fontSize:16.0f background:CLEARCOLOR];
        [self addSubview:_title];
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_W(self)-30, 18, 10, 10)];
        imageView2.image = [UIImage imageNamed:@"goto_link"];
        imageView2.userInteractionEnabled = YES;
        [self addSubview:imageView2];
        
        UITapGestureRecognizer *getsure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:getsure];
        
    }
    return self;
    
    
}



-(void)tap
{
    listCellBlock block = self.mBlock;
    if(block){
        block();
    }
}
@end
