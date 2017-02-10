//
//  BrowserScroView.m
//  weGame
//
//  Created by zy-iOS on 14/11/20.
//  Copyright (c) 2014年 BlueRain. All rights reserved.
//

#import "BrowserScroView.h"
#import "TapImgView.h"
# import <AssetsLibrary/AssetsLibrary.h>
# import "AppDelegate.h"

@interface BrowserScroView ()<UIScrollViewDelegate,ImgScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) NSMutableArray *scrviews;
@property (nonatomic,strong) NSMutableDictionary *finalySelTags;
//导航与底部按钮
@property (nonatomic,strong) UIView *topNav;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *backBT;
@property (nonatomic,strong) UIButton *okBT;
@property (nonatomic,strong) UILabel *lbTitle;
@property (nonatomic,strong) UIButton *selectBT;
@property (nonatomic,strong) UILabel * label;
@end

@implementation BrowserScroView

-(void)dealloc
{
    _arrs = nil;
    _selectedTag = nil;
    _finalySelTags = nil;
    for(UIView *v in self.scrollview.subviews)
    {
        [v removeFromSuperview];
    }
    self.scrollview = nil;
    self.scrviews = nil;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor blackColor];
        
        _arrs = [NSMutableArray array];
        _selectedTag = [NSMutableArray array];
        _finalySelTags = [NSMutableDictionary dictionary];
        self.frame = [UIScreen mainScreen].bounds;
        self.scrollview = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.scrollview.pagingEnabled = YES;
        self.scrollview.showsHorizontalScrollIndicator = NO;
        self.scrollview.showsVerticalScrollIndicator = NO;
        self.scrollview.delegate = self;
        self.scrollview.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self addSubview:self.scrollview];
        
        _topNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 64)];
       // UIImageView *imgviewNav = [[UIImageView alloc] initWithFrame:_topNav.frame];
        //imgviewNav.image = [UIImage imageNamed:@"v12navbar6"];
        _topNav.backgroundColor = HexRGB(0x00b4a2);
       // [_topNav addSubview:imgviewNav];
        [self addSubview:_topNav];
        _backBT = [[UIButton alloc] initWithFrame:CGRectMake(5, 22, 50, 40)];
        [_backBT setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
        [_backBT addTarget:self action:@selector(actionDismiss) forControlEvents:UIControlEventTouchUpInside];
        [_topNav addSubview:_backBT];
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backBT.frame), 22, 80, 40)];
       // _lbTitle.text = @"";
        _lbTitle.backgroundColor = [UIColor clearColor];
        _lbTitle.textColor = [UIColor whiteColor];
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        _label.center = CGPointMake(self.frame.size.width/2, 42);
       // _label.text = @"图片库";
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [_topNav addSubview:_label];
        
        [_topNav addSubview:_lbTitle];
//        _okBT = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 75 - 10, 22+5, 75, 30)];
//        _okBT.backgroundColor = [UIColor clearColor];
//        [_okBT setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [_okBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_okBT setBackgroundImage:[UIImage imageNamed:@"v12nav_space_icon"] forState:UIControlStateNormal];
//        [_okBT addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
//        _okBT.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_topNav addSubview:_okBT];
                _selectBT = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 65, 22+5, 75, 35)];
                _selectBT.backgroundColor = [UIColor clearColor];
                [_selectBT setImage:[UIImage imageNamed:@"勾选_03"] forState:UIControlStateNormal];
                //[_selectBT setImage:[UIImage imageNamed:@"photo_choose"] forState:UIControlStateSelected];
                [_selectBT addTarget:self action:@selector(actionSelect:) forControlEvents:UIControlEventTouchUpInside];
                [_topNav addSubview:_selectBT];
        

        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
        //_bottomView.backgroundColor = [UIColor colorWithRed:11.0/255.0 green:44.0/255.0 blue:79.0/255.0 alpha:1.0];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_bottomView];
//        _selectBT = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 70 - 5, 5, 30, 30)];
//        _selectBT.backgroundColor = [UIColor clearColor];
//        [_selectBT setImage:[UIImage imageNamed:@"v12assert_uncheck"] forState:UIControlStateNormal];
//        [_selectBT setImage:[UIImage imageNamed:@"图片-选中"] forState:UIControlStateSelected];
//        
//        [_selectBT addTarget:self action:@selector(actionSelect:) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomView addSubview:_selectBT];
                _okBT = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 70 - 15, 5, 75, 30)];
                _okBT.backgroundColor = HexRGB(0x0c9a23);
                _okBT.layer.masksToBounds =YES;
                _okBT.layer.cornerRadius = 5;
               // [_okBT setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                [_okBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_okBT setBackgroundImage:[UIImage imageNamed:@"v12nav_space_icon"] forState:UIControlStateNormal];
                [_okBT addTarget:self action:@selector(actionOK) forControlEvents:UIControlEventTouchUpInside];
                _okBT.titleLabel.font = [UIFont systemFontOfSize:16];
                [_bottomView addSubview:_okBT];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectBT.frame)+5, 5, 40, 30)];
        lb.text = @"选择";
        lb.textColor = [UIColor whiteColor];
        lb.backgroundColor = [UIColor clearColor];
        [_bottomView addSubview:lb];
    }
    return self;
}
-(void)setArrs:(NSMutableArray *)arrs
{
    [_arrs removeAllObjects];
    [_arrs addObjectsFromArray:arrs];
  //  _lbTitle.text = [NSString stringWithFormat:@"%d/%lu",_currentPage+1,(unsigned long)_arrs.count];
    _label.text = [NSString stringWithFormat:@"%d/%lu",_currentPage+1,(unsigned long)_arrs.count];

    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < _arrs.count; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.scrviews = controllers;
    CGSize s = [UIScreen mainScreen].bounds.size;
    self.scrollview.contentSize = CGSizeMake(s.width*_arrs.count, s.height);
    
    [self loadImgScrViewWithPage:0];
    [self loadImgScrViewWithPage:1];
}
-(void)setSelectedTag:(NSMutableArray *)selectedTag
{
    [_selectedTag removeAllObjects];
    [_selectedTag addObjectsFromArray:selectedTag];
    [_finalySelTags removeAllObjects];
    for (int i=0; i<selectedTag.count; i++) {
        [_finalySelTags setObject:@"1" forKey:[selectedTag objectAtIndex:i]];
    }
    
    NSInteger selectedNum = selectedTag.count;
   // [_okBT setTitle:[NSString stringWithFormat:@"确定(%ld/%ld)",(long)selectedNum,(long)_maxNumberOfSelected] forState:UIControlStateNormal];
    [_okBT setTitle:[NSString stringWithFormat:@"确定(%ld)",(long)selectedNum] forState:UIControlStateNormal];
  //  _label.text = [NSString stringWithFormat:@"%ld/%ld",(long)selectedNum,(long)_maxNumberOfSelected];
    
    if(selectedNum < 1)
    {
        [_okBT setEnabled:NO];
    }
    else
    {
        [_okBT setEnabled:YES];
    }
}
-(void)actionDismiss
{
    [self removeFromSuperview];
}
-(void)actionSelect:(UIButton *)sender
{
    if(sender.selected)
    {
        //选中状态改为取消选择
        [_finalySelTags setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        if([self.delegate respondsToSelector:@selector(browserScroView:isSelected:tag:)])
        {
            [self.delegate browserScroView:self isSelected:NO tag:sender.tag];//
        }
        
        sender.selected = !sender.selected;
        NSInteger selectedNum = 0;
        for (NSString *key in [_finalySelTags allKeys]) {
            if([[_finalySelTags objectForKey:key] isEqualToString:@"1"])
            {
                selectedNum++;
            }
        }
    //    [_okBT setTitle:[NSString stringWithFormat:@"确定(%ld/%ld)",(long)selectedNum,(long)_maxNumberOfSelected] forState:UIControlStateNormal];
         [_okBT setTitle:[NSString stringWithFormat:@"确定(%ld)",(long)_maxNumberOfSelected] forState:UIControlStateNormal];
        if(selectedNum < 1)
        {
            [_okBT setEnabled:NO];
        }
        else
        {
            [_okBT setEnabled:YES];
        }
    }
    else
    {
        //选中 判断是否已达上限
        NSInteger selectedNum = 0;
        for (NSString *key in [_finalySelTags allKeys]) {
            if([[_finalySelTags objectForKey:key] isEqualToString:@"1"])
            {
                selectedNum++;
            }
        }
        if(selectedNum >= _maxNumberOfSelected)
        {
            return;
        }
        else
        {
            [_finalySelTags setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            if([self.delegate respondsToSelector:@selector(browserScroView:isSelected:tag:)])
            {
                [self.delegate browserScroView:self isSelected:YES tag:sender.tag];
            }
            
            sender.selected = !sender.selected;
            selectedNum = 0;
            for (NSString *key in [_finalySelTags allKeys]) {
                if([[_finalySelTags objectForKey:key] isEqualToString:@"1"])
                {
                    selectedNum++;
                }
            }
            if(selectedNum < 1)
            {
                [_okBT setEnabled:NO];
            }
            else
            {
                [_okBT setEnabled:YES];
            }
       //     [_okBT setTitle:[NSString stringWithFormat:@"确定(%ld/%ld)",(long)selectedNum,(long)_maxNumberOfSelected] forState:UIControlStateNormal];
             [_okBT setTitle:[NSString stringWithFormat:@"确定(%ld)",(long)selectedNum] forState:UIControlStateNormal];
        }
    }
}
-(void)actionOK
{
    if ([self.delegate respondsToSelector:@selector(browserScroView:didSend:)]) {
        [self.delegate browserScroView:self didSend:nil];
    }
    [self removeFromSuperview];
}

-(void)show
{
    [[AppDelegate sharedInstance].window addSubview:self];
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
  //  _lbTitle.text = [NSString stringWithFormat:@"%ld/%lu",_currentPage+1,(unsigned long)_arrs.count];
      _label.text = [NSString stringWithFormat:@"%d/%lu",_currentPage+1,(unsigned long)_arrs.count];
    [self loadImgScrViewWithPage:currentPage-1];
    [self loadImgScrViewWithPage:currentPage];
    [self loadImgScrViewWithPage:currentPage+1];
    
    if(currentPage > 2)
    {
        [self freeScrviews:currentPage-2];
        [self freeScrviews:currentPage+2];
    }
    //初始设置时直接显示到currentPage
    CGFloat pageWidth = CGRectGetWidth(self.scrollview.frame);
    [self.scrollview setContentOffset:CGPointMake(currentPage*pageWidth, 0)];
    //显示是否选中
    if(_selectedTag.count > 0)
    {
        if(_showLimit)
        {
            NSString *isSs = [_selectedTag objectAtIndex:_currentPage];
            if(isSs && [[_finalySelTags objectForKey:isSs] isEqualToString:@"1"])
            {
                [_selectBT setSelected:YES];
            }
            else
            {
                [_selectBT setSelected:NO];
            }
        }
        else
        {
            NSString *isSs = [_finalySelTags objectForKey:[NSString stringWithFormat:@"%ld",(long)_currentPage]];
            if([isSs isEqualToString:@"1"])
            {
                [_selectBT setSelected:YES];
            }
            else
            {
                [_selectBT setSelected:NO];
            }
        }
    }
    if(_showLimit)
    {
        _selectBT.tag = [[_selectedTag objectAtIndex:_currentPage] integerValue];
    }
    else
    {
        _selectBT.tag = _currentPage;
    }
    
}

-(void)freeScrviews:(NSInteger)page
{
    if(page<0 || page >= self.scrviews.count)
    {
        return;
    }
    ImgScrollView *imageScroll = [self.scrviews objectAtIndex:page];
    if(![imageScroll isKindOfClass:[NSNull class]])
    {
        [imageScroll removeFromSuperview];
    }
    [self.scrviews replaceObjectAtIndex:page withObject:[NSNull null]];
}

-(void)loadImgScrViewWithPage:(NSInteger)page
{
    if(page >= self.arrs.count || page < 0)
    {
        return;
    }
    ImgScrollView *imageScroll = [self.scrviews objectAtIndex:page];
    if((NSNull *)imageScroll == [NSNull null])
    {
        imageScroll = [[ImgScrollView alloc] initWithFrame:CGRectMake(0, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)];
        imageScroll.imgDelegate = self;
        [self.scrviews replaceObjectAtIndex:page withObject:imageScroll];
    }
    if(imageScroll.superview == nil)
    {
        CGRect frame = self.scrollview.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        imageScroll.frame = frame;
        
        if([[self.arrs objectAtIndex:page] isKindOfClass:[ALAsset class]])
        {
            ALAsset *a = [self.arrs objectAtIndex:page];
            UIImage *fullImage = [UIImage imageWithCGImage:[a.defaultRepresentation fullScreenImage]
                                                     scale:[a.defaultRepresentation scale] orientation:UIImageOrientationUp];
            [imageScroll setImage:fullImage];
        }
        else
        {
            [imageScroll setImage:nil];
        }
        [imageScroll setAnimationRect:NO];
        
        [self.scrollview addSubview:imageScroll];
    }
    else
    {
        imageScroll.zoomScale = 1.0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollview.frame);
    NSUInteger page = floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPage = page;
}
#pragma mark -
- (void)ImgScrollViewTapTouch:(ImgScrollView *)imgScroll
{
    if(self.topNav.hidden)
    {
        [self.topNav setHidden:NO];
    }
    else
    {
        [self.topNav setHidden:YES];
    }
    if(self.bottomView.hidden)
    {
        [self.bottomView setHidden:NO];
    }
    else
    {
        [self.bottomView setHidden:YES];
    }
}
@end
