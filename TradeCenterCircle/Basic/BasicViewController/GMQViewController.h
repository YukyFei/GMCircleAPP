//
//  GMQViewController.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMQViewController : UIViewController

@property (nonatomic, strong)   UIButton       *backBtn;
@property (nonatomic, readonly) UIButton       *rightBtn;

- (void)bringNaviBarToTopmost;

- (void)hideNaviBar:(BOOL)bIsHide;
- (void)hideNaviback:(BOOL)bIsHide;
- (void)setNaviBarTitle:(NSString *)strTitle;
- (void)setNaviBarTitleView:(UIView *)titleView;
- (void)setNaviBarLeftBtn:(UIButton *)btn;
- (void)setNaviBarLeftImage:(UIImageView *)image;
- (void)setNaviBarRightBtn:(UIButton *)btn;

- (void)setNaviBarRightTitleBtn:(UIButton *)btn;
- (void)setNaviBarRightLongTitleBtn:(UIButton *)btn;

- (void)naviBarAddCoverView:(UIView *)view;
- (void)naviBarAddCoverViewOnTitleView:(UIView *)view;
- (void)naviBarRemoveCoverView:(UIView *)view;

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)bCanDragBack;

//导航条右侧标题按钮
-(void)createNavigationRightBarButtonWithTitle:(NSString *)title andTitleColor:(UIColor *)color;

//返回
-(void)backClick;

-(void)rightBarButtonPress ;

@end
