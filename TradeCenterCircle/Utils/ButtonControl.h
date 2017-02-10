//
//  ButtonControl.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonControl : NSObject

//创建view
+(UIView *)creatViewWithFrame:(CGRect)frame;
//创建lable
+(UILabel *)creatLableWithFrame:(CGRect)frame Text:(NSString *)text font:(CGFloat)font TextColor:(UIColor *)color;
//创建button
+(UIButton *)creatButtonWithFrame:(CGRect)frame Text:(NSString *)text ImageName:(NSString *)imageName bgImageName:(NSString *)bgImageName Target:(id)target Action:(SEL)Method;
//创建imageview
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end
