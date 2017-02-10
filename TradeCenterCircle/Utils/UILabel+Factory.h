//
//  UILabel+Factory.h
//  ctoffice
//
//  Created by TangShiLei on 13-9-25.
//  Copyright (c) 2013年 xugang. All rights reserved.
//

#import <UIKit/UIKit.h>


//UILabel 工厂方法
@interface UILabel (Factory)


+(UILabel*)labelWithFrame:(CGRect)frame withText:(NSString*)text withFont:(UIFont*)font withTextColor:(UIColor*)color withBackgroundColor:(UIColor*)bgColor;

+(UILabel*)labelWithFrame:(CGRect)frame title:(NSString*)title fontSize:(CGFloat)size background:(UIColor*)color;

+(UILabel*)labelWithFrame:(CGRect)frame title:(NSString*)title fontSize:(CGFloat)size background:(UIColor*)color lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
