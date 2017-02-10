//
//  UIView+BUIView.h
//  ctoffice
//
//  Created by TangShiLei on 13-12-9.
//  Copyright (c) 2013年 xugang. All rights reserved.
//

#import <UIKit/UIKit.h>

//UIAlertView 回调block
typedef void (^completeBlock)(NSUInteger buttonIndex);

//UIActionSheet 回调block
typedef void (^actionFinish)(NSUInteger index,UIActionSheet *action);

@interface UIView (BUIView)<UIAlertViewDelegate,UIActionSheetDelegate>



//UIAlertView  block 封装
+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)meg cancelButtonTitle:(NSString*)cancelButtonTitle completeBlcok:(completeBlock)block;

+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)meg cancelButtonTitle:(NSString*)cancelButtonTitle completeBlcok:(completeBlock)block otherTitles:(NSArray*)buttonTitles;

+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)meg cancelButtonTitle:(NSString*)cancelButtonTitle completeBlcok:(completeBlock)block otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;



//UIActionSheet block封装
+(void)showInView:(UIView*)view withTitle:(NSString*)title  cancelButtonTitle:(NSString*)cancelButtonTitle deleteButtonTitle:(NSString*)deleteTitle  completeBlcok:(actionFinish)block otherButtonTitles:(NSString*)otherButtonTitles,...NS_REQUIRES_NIL_TERMINATION;

+(void)showInView:(UIView*)view withTitle:(NSString*)title  cancelButtonTitle:(NSString*)cancelButtonTitle deleteButtonTitle:(NSString*)deleteTitle otherButtonTitles:(NSArray*)titlesArray completeBlcok:(actionFinish)block;


//创建ImageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName;
//创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text;
#pragma mark --创建View
+(UIView*)viewWithFrame:(CGRect)frame;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftView:(UIView*)left_View rightView:(UIView*)rgView  Font:(float)font;

//适配器的方法  扩展性方法
//现有方法，已经在工程里面存在，如果修改工程内所有方法，工作量巨大，就需要使用适配器的方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;

//

                                                                                                                            @end
