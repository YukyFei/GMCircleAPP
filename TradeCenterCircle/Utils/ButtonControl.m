//
//  ButtonControl.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "ButtonControl.h"

@implementation ButtonControl
//创建view
+(UIView *)creatViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    return view;
}
//创建lable
+(UILabel *)creatLableWithFrame:(CGRect)frame Text:(NSString *)text font:(CGFloat)font TextColor:(UIColor *)color
{
    UILabel *lable = [[UILabel alloc]initWithFrame:frame];
    lable.text=text;
    lable.textColor = color;
    lable.font=[UIFont systemFontOfSize:font];
    return lable;
}
//创建button
+(UIButton *)creatButtonWithFrame:(CGRect)frame Text:(NSString *)text ImageName:(NSString *)imageName bgImageName:(NSString *)bgImageName Target:(id)target Action:(SEL)Method
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    [button addTarget:target action:Method forControlEvents:UIControlEventTouchUpInside];
    if (text) {
        [button setTitle:text forState:UIControlStateNormal];
    }
    return button;
}

//创建imageview
+(UIImageView *)creatImageViewWithFrame:(CGRect)frame ImageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=YES;
    return imageView;
}
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

@end
