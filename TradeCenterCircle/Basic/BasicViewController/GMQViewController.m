//
//  GMQViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQViewController.h"
#import "GMQNavigationController.h"
#import "GMQNaviBarView.h"

@interface GMQViewController ()

@property (nonatomic, readonly) GMQNaviBarView *m_viewNaviBar;
//@property (nonatomic, strong)   UIButton       *backBtn;
//@property (nonatomic, readonly) UIButton       *rightBtn;

@end

@implementation GMQViewController
@synthesize m_viewNaviBar = _viewNaviBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    _viewNaviBar = [[GMQNaviBarView alloc] initWithFrame:Rect(0.0f, 0.0f, [GMQNaviBarView barSize].width, [GMQNaviBarView barSize].height)];
    _viewNaviBar.m_viewCtrlParent = self;
    _viewNaviBar.backgroundColor = [UIColor colorWithHexString:@"#a6873b"];
    [self.view addSubview:_viewNaviBar];
    
    if (!self.backBtn) {
        UIButton *headBtn = [ButtonControl creatButtonWithFrame:CGRectMake(5, (64-44)/2 + 10, 44, 44) Text:nil ImageName:nil bgImageName:nil Target:self Action:@selector(backClick)];
        self.backBtn = headBtn;
        [headBtn setImage:[UIImage imageNamed:@"common_btn_back"] forState:UIControlStateNormal];
        [_viewNaviBar addSubview:headBtn];
    } 

}

- (void)dealloc
{
    [UtilityFunc cancelPerformRequestAndNotification:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_viewNaviBar && !_viewNaviBar.hidden)
    {
        [self.view bringSubviewToFront:_viewNaviBar];
    }else{}
}

#pragma mark -

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bringNaviBarToTopmost
{
    if (_viewNaviBar)
    {
        [self.view bringSubviewToFront:_viewNaviBar];
    }else{}
}

- (void)hideNaviBar:(BOOL)bIsHide
{
    _viewNaviBar.hidden = bIsHide;
}

-(void)hideNaviback:(BOOL)bIsHide
{
    self.backBtn.hidden = bIsHide;
}

- (void)setNaviBarTitle:(NSString *)strTitle
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setTitle:strTitle];
    }else{APP_ASSERT_STOP}
}

- (void)setNaviBarTitleView:(UIView *)titleView
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setTitleView:titleView] ;
    }else{APP_ASSERT_STOP}
}

- (void)setNaviBarLeftBtn:(UIButton *)btn
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setLeftBtn:btn];
    }else{APP_ASSERT_STOP}
}

- (void)setNaviBarLeftImage:(UIImageView *)image
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setLeftImage:image];
    }
}

- (void)setNaviBarRightBtn:(UIButton *)btn
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setRightBtn:btn];
    }else{APP_ASSERT_STOP}
}

-(void)createNavigationRightBarButtonWithTitle:(NSString *)title andTitleColor:(UIColor *)color
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(SCREENWIDTH - 100 - 10, (64-30)/2+10, 100, 30);
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    [_rightBtn setTitleColor:color forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_RightNav_title_size]];
    _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightBtn addTarget:self action:@selector(rightBarButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [_viewNaviBar addSubview:_rightBtn];
}

//右导航栏按钮 点击事件
-(void)rightBarButtonPress
{
    
}

- (void)setNaviBarRightTitleBtn:(UIButton *)btn andTitleStr:(NSString *)title andTitleColor:(UIColor *)color
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setRightTitleBtn:btn];
    }else{APP_ASSERT_STOP}
}

- (void)setNaviBarRightLongTitleBtn:(UIButton *)btn
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setRightLongTitleBtn:btn];
    }else{APP_ASSERT_STOP}
}

- (void)naviBarAddCoverView:(UIView *)view
{
    if (_viewNaviBar && view)
    {
        [_viewNaviBar showCoverView:view animation:YES];
    }else{}
}

- (void)naviBarAddCoverViewOnTitleView:(UIView *)view
{
    if (_viewNaviBar && view)
    {
        [_viewNaviBar showCoverViewOnTitleView:view];
    }else{}
}

- (void)naviBarRemoveCoverView:(UIView *)view
{
    if (_viewNaviBar)
    {
        [_viewNaviBar hideCoverView:view];
    }else{}
}

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)bCanDragBack
{
    if (self.navigationController)
    {
        [((GMQNavigationController *)(self.navigationController)) navigationCanDragBack:bCanDragBack];
    }else{}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
