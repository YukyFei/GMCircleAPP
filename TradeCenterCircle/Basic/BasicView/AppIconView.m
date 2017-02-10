//
//  AppIconView.m
//  ctoffice
//
//  Created by tangshilei on 15-6-6.
//  Copyright (c) 2015年 xugang. All rights reserved.
//

#import "AppIconView.h"
#import "ImageCenter.h"
#import "UIImageView+WebCache.h"
@implementation AppIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


-(void)singleTap:(UITapGestureRecognizer *)sender
{
	[self.delegate appClicked:self];
}




/**
 *首页Icon
 *
 *  @param frame <#frame description#>
 *  @param name  <#name description#>
 *  @param icon  <#icon description#>
 *
 *  @return <#return value description#>
 */

//首页底部栏用
- (id)initWithFrame:(CGRect)frame name:(NSString *)name homeIcon:(UIImage *)icon textColor:(UIColor*)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.name=name;
        self.icon=icon;
        self.backgroundColor=[UIColor clearColor];
        int margin = 0;
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(margin+2, margin, frame.size.width, frame.size.height-15)];
        //iv.image = icon;
        iv.userInteractionEnabled=YES;
        iv.image=[ImageCenter scaleFromImage:icon scaledToSize:CGSizeMake(frame.size.width, frame.size.height)];
        [self addSubview:iv];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(margin+2-10, VIEW_BY(iv)+5, frame.size.width+20, 10)];
        _label.text=name;
        _label.textColor= textColor;
        
        _label.backgroundColor=[UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:10.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_label];
        
    }
    return self;

}







/**
 *  <#Description#>
 *
 *  @param frame <#frame description#>
 *  @param name  <#name description#>
 *  @param icon  <#icon description#>
 *
 *  @return <#return value description#>
 */

- (id)initWithFrame:(CGRect)frame name:(NSString *)name fileIcon:(UIImage *)icon{
    //固定大小
    //frame=CGRectMake(frame.origin.x, frame.origin.y, 80, 90);
    self = [super initWithFrame:frame];
    if (self) {
        
        self.name=name;
		self.icon=icon;
		self.backgroundColor=[UIColor clearColor];
        
        [self  singleTapGesture];
    
        int margin = (frame.size.width-57)/2;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(margin+8, margin, 50, 50)];
        //iv.image = icon;
        iv.userInteractionEnabled=YES;
        iv.image=[ImageCenter scaleFromImage:icon scaledToSize:CGSizeMake(50, 50)];
        
        [self addSubview:iv];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_BY(iv), frame.size.width, 16)];
        _label.text=name;
        _label.textColor= HexRGB(0xffffff);
        
        _label.backgroundColor=[UIColor clearColor];
        _label.font = [UIFont boldSystemFontOfSize:18.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_label];
        
        UIImageView *tipIvTemp = [[UIImageView alloc]initWithFrame:CGRectMake(53, 53, 25, 25)];
        tipIvTemp.image=[UIImage imageNamed:@"geren_icon_xiaohongdian"];
        self.tipIv =tipIvTemp;
       
        UILabel *tipLabelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
        self.tipLabel = tipLabelTemp;
        tipLabelTemp.textAlignment = NSTextAlignmentCenter;
        tipLabelTemp.textColor =[UIColor whiteColor];
        tipLabelTemp.font=[UIFont systemFontOfSize:10];
        tipLabelTemp.backgroundColor = [UIColor clearColor];
        [self.tipIv addSubview:tipLabelTemp];
        
        [self addSubview:self.tipIv];
        
        self.tipIv.hidden=YES;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame name:(NSString *)name fileIcon:(UIImage *)icon textColor:(UIColor*)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.name=name;
		self.icon=icon;
		self.backgroundColor=[UIColor clearColor];
        int margin = (frame.size.width-57)/2;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(margin+8, margin, 50, 50)];
        //iv.image = icon;
        iv.userInteractionEnabled=YES;
        iv.image=[ImageCenter scaleFromImage:icon scaledToSize:CGSizeMake(50, 50)];
        
        [self addSubview:iv];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0+2, VIEW_BY(iv)+5, frame.size.width, 16)];
        _label.text=name;
        _label.textColor= textColor;
        
        _label.backgroundColor=[UIColor clearColor];
        _label.font = [UIFont boldSystemFontOfSize:18.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_label];
        
        UIImageView *tipIvTemp = [[UIImageView alloc]initWithFrame:CGRectMake(53, 53, 25, 25)];
        tipIvTemp.image=[UIImage imageNamed:@"geren_icon_xiaohongdian"];
        self.tipIv =tipIvTemp;
        
        UILabel *tipLabelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
        self.tipLabel = tipLabelTemp;
        tipLabelTemp.textAlignment = NSTextAlignmentCenter;
        tipLabelTemp.textColor =[UIColor whiteColor];
        tipLabelTemp.font=[UIFont systemFontOfSize:10];
        tipLabelTemp.backgroundColor = [UIColor clearColor];
        [self.tipIv addSubview:tipLabelTemp];
        [self addSubview:self.tipIv];
        
        self.tipIv.hidden=YES;
    }
    return self;
}


- (id)initWithIconFrame:(CGRect)frame name:(NSString *)name fileIcon:(NSString *)icon textColor:(UIColor*)textColor isNet:(BOOL)fromNet
{
   
    self = [super initWithFrame:frame];
    if (self) {
        [self  singleTapGesture];
        self.name=name;
		//self.icon=icon;
		self.backgroundColor=[UIColor clearColor];
        int margin = 0;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(margin+2, margin, frame.size.width, frame.size.height-15)];
        iv.userInteractionEnabled=YES;
        
        if(fromNet){
            
            if ([name isEqualToString:@"加服务项"]) {
                iv.image = [UIImage imageNamed:icon];
            }else if ([name isEqualToString:@"减服务项"]){
                iv.image = [UIImage imageNamed:icon];
            }else{
                [iv sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:nil];

            }
        }
        else{
        iv.image=[ImageCenter scaleFromImage:[UIImage imageNamed:icon] scaledToSize:CGSizeMake(frame.size.width,frame.size.height)];
        }
        
        [self addSubview:iv];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0+2-10, VIEW_BY(iv)+5, frame.size.width+20, 15)];
        _label.text = name;
        _label.textColor = textColor;
        
        _label.backgroundColor=[UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:12.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        
        UIImageView *tipIvTemp = [[UIImageView alloc]initWithFrame:CGRectMake(53, 53, 25, 25)];
        tipIvTemp.image=[UIImage imageNamed:@"geren_icon_xiaohongdian"];
        self.tipIv =tipIvTemp;
        
        UILabel *tipLabelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
        self.tipLabel = tipLabelTemp;
        tipLabelTemp.textAlignment = NSTextAlignmentCenter;
        tipLabelTemp.textColor =[UIColor whiteColor];
        tipLabelTemp.font=[UIFont systemFontOfSize:10];
        tipLabelTemp.backgroundColor = [UIColor clearColor];
        [self.tipIv addSubview:tipLabelTemp];
       
        
        [self addSubview:self.tipIv];
        
        self.tipIv.hidden=YES;
    }
    return self;
    
}
//修改的中间的button
-(id)initWithFrame:(CGRect)frame WithfileIcon:(UIImage *)icon
{
 self = [super initWithFrame:frame];
    if (self) {
        [self  singleTapGesture];
       
        //self.icon=icon;
        self.backgroundColor=[UIColor clearColor];
        int margin = 0;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(margin+2, margin, frame.size.width, frame.size.height-15)];
        iv.userInteractionEnabled=YES;
        
        
        [self addSubview:iv];
   
        UIImageView *tipIvTemp = [[UIImageView alloc]initWithFrame:CGRectMake(53, 53, 25, 25)];
        tipIvTemp.image=[UIImage imageNamed:@"geren_icon_xiaohongdian"];
        self.tipIv =tipIvTemp;
        
        UILabel *tipLabelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
        self.tipLabel = tipLabelTemp;
        tipLabelTemp.textAlignment = NSTextAlignmentCenter;
        tipLabelTemp.textColor =[UIColor whiteColor];
        tipLabelTemp.font=[UIFont systemFontOfSize:10];
        tipLabelTemp.backgroundColor = [UIColor clearColor];
        [self.tipIv addSubview:tipLabelTemp];
        
        
        [self addSubview:self.tipIv];
        
        self.tipIv.hidden=YES;
    }
    return self;
}

//
-(UITapGestureRecognizer*)singleTapGesture
{
    if(!_singleTapGesture)
    {
       _singleTapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:_singleTapGesture];
    }
    return _singleTapGesture;
}



@end