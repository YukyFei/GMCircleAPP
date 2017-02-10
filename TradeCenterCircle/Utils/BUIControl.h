//
//  UIControl+BUIControl.h
//  BlockUI
//
//  Created by 张 玺 on 12-9-10.
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionBlock)();

@interface UIControl (BUIControl)

#pragma mark ---UIButton 类方法
+(UIButton*)buttonWithType:(UIButtonType)type andFrame:(CGRect)frame andTitle:(NSString *)title andBackgroundImage:(NSString *)imageName;

//UIButton 点击事件 block回调
+(UIButton*)buttonWithType:(UIButtonType)type andFrame:(CGRect)frame andTitle:(NSString *)title andBackgroundImage:(NSString *)imageName andHandleEvent:(UIControlEvents)event andCompletionBlcok:(ActionBlock)block;

+(UIButton*)buttonWithType:(UIButtonType)type frame:(CGRect)frame title:(NSString*)title backgroundImage:(NSString*)bgName  selectImage:(NSString*)selectName handleControlEvent:(UIControlEvents)event completionBlock:(ActionBlock)block;

//创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame imageName:(NSString*)imageName bgImageName:(NSString*)bgImageName title:(NSString*)title SEL:(SEL)sel target:(id)target;

//创建buttonwithtag
+(UIButton*)buttonWithType:(UIButtonType)type andFrame:(CGRect)frame andTag:(NSString *)tag andBackgroundImage:(NSString *)imageName;

+(UIButton*)buttonWithType:(UIButtonType)type andFrame:(CGRect)frame andTag:(NSString *)tag andTitle:(NSString *)title ;
@end
