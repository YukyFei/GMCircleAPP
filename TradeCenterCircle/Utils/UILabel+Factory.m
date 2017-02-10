//
//  UILabel+Factory.m
//  ctoffice
//
//  Created by TangShiLei on 13-9-25.
//  Copyright (c) 2013年 xugang. All rights reserved.
//

#import "UILabel+Factory.h"

@implementation UILabel (Factory)


+(UILabel*)labelWithFrame:(CGRect)frame withText:(NSString *)text withFont:(UIFont *)font withTextColor:(UIColor *)color withBackgroundColor:(UIColor *)bgColor
{
    
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.text=text;
    label.font=font;
    label.textColor=color;
    label.backgroundColor=bgColor;
    return label;
}

#pragma -mark UILabel

+ (UILabel*)labelWithFrame:(CGRect)frame title:(NSString*)title fontSize:(CGFloat)size background:(UIColor*)color;
{
    UILabel *label=[[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.font = [UIFont systemFontOfSize:size];
    label.backgroundColor = color;
    
    return label;
}

+(UILabel*)labelWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)size background:(UIColor *)color lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    UILabel *label=[[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.font=[UIFont systemFontOfSize:size];
    label.lineBreakMode=lineBreakMode;
    label.backgroundColor = color;
    label.numberOfLines=0;
    
    return label;
}



@end
