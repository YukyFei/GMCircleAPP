//
//  VShowImgs.m
//  weGame
//
//  Created by zy-iOS on 14/9/26.
//  Copyright (c) 2014年 BlueRain. All rights reserved.
//

# import "VShowImgs.h"
# import "AppDelegate.h"

@interface VShowImgs()<UIScrollViewDelegate>
{
    NSInteger numberPages;//当前图片数量
}

@property(nonatomic,strong) UIButton *btSet;
@property(nonatomic,strong) UILabel *lbTitle;

@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  NSMutableArray *viewControllers;//scrollview要现实的视图
@end

@implementation VShowImgs

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _editeable = YES;
        _imgs = [NSMutableArray array];
        _index = 0;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.bounces = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 40, 20)];
        _lbTitle.textColor = [UIColor whiteColor];
        _lbTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbTitle];
        _btDelete = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 55, 20, 50, 50)];
        //展示页删除图片
        [_btDelete setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        [_btDelete addTarget:self action:@selector(actionDeleteCurrentImageview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btDelete];
        _btSet = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, frame.size.height - 80, 200, 65)];

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handerGesture)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)setEditeable:(BOOL)editeable
{
    _editeable = editeable;
    if(_editeable)
    {
        [_btSet  setHidden:NO];
        [_btDelete setHidden:NO];
    }
    else
    {
        [_btSet  setHidden:YES];
        [_btDelete setHidden:YES];
    }
}

-(void)actionDeleteCurrentImageview
{
    UIImageView *controller = [self.viewControllers objectAtIndex:self.index];
    if(controller)
    {
        [controller removeFromSuperview];
    }
    for(NSInteger i=self.index ;i<self.viewControllers.count-1;i++)
    {
        UIImageView *v = [self.viewControllers objectAtIndex:i+1];
        if(![v isKindOfClass:[NSNull class]])
        {
            CGRect frame = self.scrollView.frame;
            frame.origin.x = CGRectGetWidth(frame) * i;
            frame.origin.y = 0;
            v.frame = frame;
        }
    }
    [self.imgs removeObjectAtIndex:self.index];
    [self.viewControllers removeObjectAtIndex:self.index];
    if(self.index == numberPages - 1)
    {
        //删除第n张，当前位置还是n，不变，如果是最后一张，则减1,最小为0;
        self.index = self.index - 1;
        if (self.index < 0) {
            self.index = 0;
        }
    }
    numberPages = self.imgs.count;
    
    self.scrollView.contentSize =CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    [self loadScrollViewWithPage:self.index];
    [self setTheLableTitle];
    
    if([self.delegate respondsToSelector:@selector(VShowImgs:deletetag:)])
    {
        [self.delegate VShowImgs:self deletetag:self.index];
    }
    
    if(numberPages == 0)
    {
        [self hiddenAnimation];
    }
}

-(void)btSetCover
{
    if([self.delegate respondsToSelector:@selector(VShowImgs:covertag:)])
    {
        [self.delegate VShowImgs:self covertag:self.index];
    }
    [self hiddenAnimation];
}

-(void)setImgs:(NSMutableArray *)imgs
{
    _imgs = imgs;
    numberPages = _imgs.count;
    self.scrollView.contentSize =CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
}


- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.imgs.count)
        return;
    
    // replace the placeholder if necessary
    UIImageView *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[UIImageView alloc] init];
        controller.contentMode = UIViewContentModeScaleAspectFit;
        controller.userInteractionEnabled = YES;
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.frame = frame;
        [self.scrollView addSubview:controller];
        
        UIImage *img = [self.imgs objectAtIndex:page];
        controller.image = img;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.index = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    [self setTheLableTitle];
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

-(void)show
{
    if(self.index == 0)
    {
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
    }
    else
    {
        [self loadScrollViewWithPage:self.index - 1];
        [self loadScrollViewWithPage:self.index];
        [self loadScrollViewWithPage:self.index + 1];
        
        self.scrollView.contentOffset = CGPointMake(self.index * self.scrollView.frame.size.width, 0);
    }
    
    [self setTheLableTitle];
    
    [[AppDelegate sharedInstance].window setWindowLevel:UIWindowLevelAlert];
    [[AppDelegate sharedInstance].window addSubview:self];
}

-(void)setTheLableTitle
{
    NSString *str = [NSString stringWithFormat:@"%ld/%ld",(long)self.index+1,(long)numberPages];
    _lbTitle.text = str;
}

- (void)hiddenAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        [[AppDelegate sharedInstance].window setWindowLevel:UIWindowLevelNormal];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

-(void)handerGesture
{
    [self hiddenAnimation];
}

@end
