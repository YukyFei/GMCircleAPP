//
//  GMQNaviBarView.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQNaviBarView.h"

@interface GMQNaviBarView ()

@property (nonatomic, readonly) UIButton *m_btnBack;
@property (nonatomic, readonly) UILabel *m_labelTitle;
@property (nonatomic, readonly) UIImageView *m_imgViewBg;
@property (nonatomic, readonly) UIImageView *m_leftImage;
@property (nonatomic, readonly) UIButton *m_btnLeft;
@property (nonatomic, readonly) UIButton *m_btnRight;
@property (nonatomic, readonly) UIButton *m_btnRightTitle;
@property (nonatomic, readonly) UIButton *m_btnRightLongTitle;
@property (nonatomic, readonly) BOOL m_bIsBlur;
@property (nonatomic, readonly) UIButton       *rightBtn;
//@property(nonatomic,readonly) UIView * titleView ;

@end

@implementation GMQNaviBarView

@synthesize m_btnBack = _btnBack;
@synthesize m_labelTitle = _labelTitle;
@synthesize m_imgViewBg = _imgViewBg;
@synthesize m_btnLeft = _btnLeft;
@synthesize m_leftImage = _m_leftImage;
@synthesize m_btnRight = _btnRight;
@synthesize m_btnRightTitle = _btnRightTitle;
@synthesize m_btnRightLongTitle = _btnRightLongTitle;
@synthesize m_bIsBlur = _bIsBlur;


+ (CGRect)rightBtnFrame
{
    return Rect(SCREENWIDTH-33, 33.0, 20, 20);
}

+ (CGSize)barBtnSize
{
    return Size(60.0f, 40.0f);
}

+ (CGSize)barSize
{
    return Size(SCREENWIDTH, 64.0f);
}

+ (CGRect)titleViewFrame
{
    return Rect(65.0f, 22.0f, 190.0f, 40.0f);
}

// 创建一个导航条按钮：使用默认的按钮图片。
+ (UIButton *)createNormalNaviBarBtnByTitle:(NSString *)strTitle target:(id)target action:(SEL)action
{
    UIButton *btn = [[self class] createImgNaviBarBtnByImgNormal:@"" imgHighlight:@"" target:target action:action];
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [UtilityFunc label:btn.titleLabel setMiniFontSize:8.0f forNumberOfLines:1];
    
    return btn;
}

// 创建一个导航条按钮：自定义按钮图片。
+ (UIButton *)createImgNaviBarBtnByImgNormal:(NSString *)strImg imgHighlight:(NSString *)strImgHighlight target:(id)target action:(SEL)action
{
    return [[self class] createImgNaviBarBtnByImgNormal:strImg imgHighlight:strImgHighlight imgSelected:strImg target:target action:action];
}
+ (UIButton *)createImgNaviBarBtnByImgNormal:(NSString *)strImg imgHighlight:(NSString *)strImgHighlight imgSelected:(NSString *)strImgSelected target:(id)target action:(SEL)action
{
    UIImage *imgNormal = [UIImage imageNamed:strImg];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:imgNormal forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:(strImgHighlight ? strImgHighlight : strImg)] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:(strImgSelected ? strImgSelected : strImg)] forState:UIControlStateSelected];
    
    CGFloat fDeltaWidth = ([[self class] barBtnSize].width - imgNormal.size.width)/2.0f;
    CGFloat fDeltaHeight = ([[self class] barBtnSize].height - imgNormal.size.height)/2.0f;
    fDeltaWidth = (fDeltaWidth >= 2.0f) ? fDeltaWidth/2.0f : 0.0f;
    fDeltaHeight = (fDeltaHeight >= 2.0f) ? fDeltaHeight/2.0f : 0.0f;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(fDeltaHeight, fDeltaWidth, fDeltaHeight, fDeltaWidth)];
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(fDeltaHeight, -imgNormal.size.width, fDeltaHeight, fDeltaWidth)];
    
    return btn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _bIsBlur = (IsiOS7Later && Is4Inch);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleFrame) name:@"changeTitle" object:nil];
        
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    
    // 默认左侧显示返回按钮
    _btnBack = [[self class] createImgNaviBarBtnByImgNormal:@"" imgHighlight:@"" target:self action:@selector(btnBack:)];
//    _titleView = [[UIView alloc]init];
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.textColor = [UIColor whiteColor];
    _labelTitle.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_NavBar_title_size]];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _imgViewBg = [[UIImageView alloc] initWithFrame:self.bounds];
    _imgViewBg.image = [[UIImage imageNamed:@""] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    _imgViewBg.alpha = 0.98f;
    
    if (_bIsBlur)
    {// iOS7可设置是否需要现实磨砂玻璃效果
        _imgViewBg.alpha = 0.0f;
        UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:self.bounds];
        [self addSubview:naviBar];
    }else{}
    
    _imgViewBg.frame = self.bounds;
//    [self addSubview:_titleView] ;
    [self addSubview:_imgViewBg];
    [self addSubview:_labelTitle];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = [UIColor clearColor];
    [self setLeftImage:image];
    
    [self setLeftBtn:_btnBack];
}

- (void)titleFrame
{
    CGFloat height = (IS_IOS7) ? 64 : 44;
    _labelTitle.frame = CGRectMake(0, 20, SCREENWIDTH, height-20);
}

- (void)setTitle:(NSString *)strTitle
{
    CGFloat height = (IS_IOS7) ? 64 : 44;
    [_labelTitle setText:strTitle];
    _labelTitle.frame = CGRectMake(35, 20, SCREENWIDTH-70, height-20);
}

-(void)setTitleView:(UIView *)titleView
{
      CGFloat height = (IS_IOS7) ? 64 : 44;
//     _titleView.frame = CGRectMake(0, 20, SCREENWIDTH, height-20);
    _labelTitle.frame = CGRectMake(0, 20, SCREENWIDTH, height-20);
//    _titleView.userInteractionEnabled = YES ;
     titleView.center = _labelTitle.center ;
    [self addSubview:titleView];
}



- (void)setLeftBtn:(UIButton *)btn
{
    if (_btnLeft)
    {
        [_btnLeft removeFromSuperview];
        _btnLeft = nil;
    }else{}
    
    _btnLeft = btn;
    if (_btnLeft)
    {
        _btnLeft.frame = Rect(15.0f, (64-22)/2 + 10, 12, 22);
        [self addSubview:_btnLeft];
    }else{}
}

- (void)setLeftImage:(UIImageView *)image
{
    if (_m_leftImage)
    {
        [_m_leftImage removeFromSuperview];
        _m_leftImage = nil;
    }else{}
    
    _m_leftImage = image;
    if (_m_leftImage)
    {
        _m_leftImage.frame = Rect(16.0f, 29.0f, 26, 26);
        [self addSubview:_m_leftImage];
    }else{}
}

- (void)setRightBtn:(UIButton *)btn
{
    if (_btnRight)
    {
        [_btnRight removeFromSuperview];
        _btnRight = nil;
    }else{}
    
    _btnRight = btn;
    if (_btnRight)
    {
        _btnRight.frame = [[self class] rightBtnFrame];
        [self addSubview:_btnRight];
    }else{}
}

- (void)setRightTitleBtn:(UIButton *)btn
{
    if (_btnRightTitle)
    {
        [_btnRightTitle removeFromSuperview];
        _btnRightTitle = nil;
    }else{}
    
    _btnRightTitle = btn;
    if (_btnRightTitle)
    {
        _btnRightTitle.frame = Rect(SCREENWIDTH-65, 33.0f, 50, 20);
        _btnRightTitle.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _btnRightTitle.backgroundColor = [UIColor clearColor];
        _btnRightTitle.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self addSubview:_btnRightTitle];
    }else{}
}

- (void)setRightLongTitleBtn:(UIButton *)btn
{
    if (_btnRightLongTitle)
    {
        [_btnRightLongTitle removeFromSuperview];
        _btnRightLongTitle = nil;
    }else{}
    
    _btnRightLongTitle = btn;
    if (_btnRightLongTitle)
    {
        _btnRightLongTitle.frame = Rect(SCREENWIDTH-115, 33.0f, 100, 20);
        _btnRightLongTitle.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _btnRightLongTitle.backgroundColor = [UIColor clearColor];
        _btnRightLongTitle.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self addSubview:_btnRightLongTitle];
    }else{}
}

- (void)btnBack:(id)sender
{
    if (self.m_viewCtrlParent)
    {
        [self.m_viewCtrlParent.navigationController popViewControllerAnimated:YES];
    }else{APP_ASSERT_STOP}
}

- (void)showCoverView:(UIView *)view
{
    [self showCoverView:view animation:NO];
}
- (void)showCoverView:(UIView *)view animation:(BOOL)bIsAnimation
{
    if (view)
    {
        [self hideOriginalBarItem:YES];
        
        [view removeFromSuperview];
        
        view.alpha = 0.4f;
        [self addSubview:view];
        if (bIsAnimation)
        {
            [UIView animateWithDuration:0.2f animations:^()
             {
                 view.alpha = 1.0f;
             }completion:^(BOOL f){}];
        }
        else
        {
            view.alpha = 1.0f;
        }
    }else{APP_ASSERT_STOP}
}

- (void)showCoverViewOnTitleView:(UIView *)view
{
    if (view)
    {
        if (_labelTitle)
        {
            _labelTitle.hidden = YES;
        }else{}
        
        [view removeFromSuperview];
        view.frame = _labelTitle.frame;
        
        [self addSubview:view];
    }else{APP_ASSERT_STOP}
}

- (void)hideCoverView:(UIView *)view
{
    [self hideOriginalBarItem:NO];
    if (view && (view.superview == self))
    {
        [view removeFromSuperview];
    }else{}
}

#pragma mark -
- (void)hideOriginalBarItem:(BOOL)bIsHide
{
    if (_btnLeft)
    {
        _btnLeft.hidden = bIsHide;
    }else{}
    if (_btnBack)
    {
        _btnBack.hidden = bIsHide;
    }else{}
    if (_btnRight)
    {
        _btnRight.hidden = bIsHide;
    }else{}
    if (_labelTitle)
    {
        _labelTitle.hidden = bIsHide;
    }else{}
    if (_btnRightTitle)
    {
        _btnRightTitle.hidden = bIsHide;
    }else{}
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTitle" object:nil];
}

@end
