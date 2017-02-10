//
//  ScrollerTimerViewController.m
//  YourMate
//
//  Created by ww on 16/7/3.
//  Copyright © 2016年 Yourmate. All rights reserved.
//

#import "ScrollerTimerViewController.h"
#import <objc/runtime.h>

@interface ScrollerTimerViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView      *_scrollView;
    UIPageControl     *_page;
    NSTimer           *myTimer;
}

@end

@implementation ScrollerTimerViewController

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2)];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH*(_pathArray.count + 1),SCREENWIDTH/2);
        _scrollView.showsVerticalScrollIndicator =NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor =[UIColor clearColor];
        [self.view addSubview:_scrollView];
    }
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBannerView)];
    tapGes.delegate = self;
    [_scrollView addGestureRecognizer:tapGes];
    
    UIImageView *imageView = [[UIImageView alloc]
                              
                              initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2)];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,_pathArray.lastObject]] placeholderImage:[UIImage imageNamed:@"moren"]];
    [_scrollView addSubview:imageView];
    
    for (int i = 0;i<[_pathArray count];i++) {
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH*i+SCREENWIDTH, 0, SCREENWIDTH, SCREENWIDTH/2)];
        [tempImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,_pathArray[i]]] placeholderImage:[UIImage imageNamed:@"moren"]];
        tempImageView.userInteractionEnabled = YES;
        [_scrollView addSubview:tempImageView];
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH*(_pathArray.count +1), 0, SCREENWIDTH, SCREENWIDTH/2)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,_pathArray.firstObject]] placeholderImage:[UIImage imageNamed:@"moren"]];
    [_scrollView addSubview:imageView];
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREENWIDTH - 20 - (_pathArray.count- 1) * 20, SCREENWIDTH/2-30 , _pathArray.count * 20, 30)];
    _page.numberOfPages = _pathArray.count;
    _page.currentPage = 0;
    _page.pageIndicatorTintColor = [UIColor whiteColor];
    _page.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#a6873b"];
    [_page addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_page];
    
    [self performSelector:@selector(updateScrollView) withObject:nil afterDelay:0.0f];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = (_scrollView.contentOffset.x - _scrollView.frame.size.width
                       / ([_pathArray count]+2)) / _scrollView.frame.size.width + 1;
    
    //    NSLog(@"%d",currentPage);
    
    if (currentPage==0) {
        [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH*_pathArray.count, 0, SCREENWIDTH, SCREENWIDTH/2) animated:NO];
    }
    
    else if (currentPage==([_pathArray count]+1)) {
        //如果是最后+1,也就是要开始循环的第一个
        [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENWIDTH/2) animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    int page = _scrollView.contentOffset.x/SCREENWIDTH-1;
    _page.currentPage = page;
}

-(void)pageAction
{
    NSInteger page = _page.currentPage;
    [_scrollView setContentOffset:CGPointMake(SCREENWIDTH * (page+1), 0)];
}

- (void) updateScrollView
{
    [myTimer invalidate];
    myTimer = nil;
    //time duration
    NSTimeInterval timeInterval = 3;
    //timer
    myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self
                                             selector:@selector(handleMaxShowTimer:)
                                             userInfo: nil
                                              repeats:YES];
}

- (void)handleMaxShowTimer:(NSTimer*)theTimer
{
    CGPoint pt = _scrollView.contentOffset;
    NSInteger count = [_pathArray count];
    if(pt.x == SCREENWIDTH * count){
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH,0,SCREENWIDTH,SCREENWIDTH/2) animated:YES];
    }else{
        [_scrollView scrollRectToVisible:CGRectMake(pt.x+SCREENWIDTH,0,SCREENWIDTH,SCREENWIDTH/2) animated:YES];
    }
}

-(void)clickBannerView
{
    if ([self.delegate respondsToSelector:@selector(clickImage:)]) {
        [self.delegate clickImage:_page.currentPage];
    }
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
