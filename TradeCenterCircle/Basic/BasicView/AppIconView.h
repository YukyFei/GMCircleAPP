//
//  AppIconView.h
//  ctoffice
//
//  Created by xugang on 13-6-6.
//  Copyright (c) 2013年 xugang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


//icon 图片+文字  点击
@protocol AppIconViewDelegate;
@interface AppIconView : UIView

@property (nonatomic,assign) id<AppIconViewDelegate> delegate;
@property(nonatomic,weak) UIImage *icon;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,weak) UIImageView *tipIv;
@property(nonatomic,weak) UILabel *tipLabel;
@property(nonatomic,assign) NSInteger appId;


@property(nonatomic,strong)UILabel *label;
@property(nonatomic,retain)UITapGestureRecognizer *singleTapGesture;

- (id)initWithFrame:(CGRect)frame name:(NSString *)name fileIcon:(UIImage *)icon;
- (id)initWithFrame:(CGRect)frame name:(NSString *)name fileIcon:(UIImage *)icon textColor:(UIColor*)textColor;


//首页使用的
- (id)initWithIconFrame:(CGRect)frame name:(NSString *)name fileIcon:(NSString *)icon textColor:(UIColor*)textColor isNet:(BOOL)fromNet;

- (id)initWithFrame:(CGRect)frame name:(NSString *)name homeIcon:(UIImage *)icon textColor:(UIColor*)textColor;


@end



@protocol AppIconViewDelegate <NSObject>

-(void)appClicked:(AppIconView*)app;

@end