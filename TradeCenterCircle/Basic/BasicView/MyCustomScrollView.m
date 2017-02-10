//
//  MyCustomScrollView.m
//  YourMate
//
//  Created by Tang Shilei on 14-12-19.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//

#import "MyCustomScrollView.h"
#import "MyCustomPageControl.h"
@interface MyCustomScrollView()

@property (nonatomic, strong) NSTimer *timer;
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation MyCustomScrollView

-(void)setViews:(NSMutableArray *)views
{
    _views=views;
    int kNumberOfPages = (int) _views.count;
    if(views.count>1)
    {
       self.pageControl.numberOfPages = kNumberOfPages;
    }
    self.pageControl.currentPage = 0;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * kNumberOfPages, self.scrollView.frame.size.height);
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    int pageControlHeight = 20;
    self.scrollView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.pageControl.frame=CGRectMake(0, frame.size.height - pageControlHeight, frame.size.width, pageControlHeight);
}



-(id)initWithFrame:(CGRect)frame {
    if(self=[super initWithFrame:frame])
    {
        int pageControlHeight = 20;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        MyCustomPageControl *pageControl = [[MyCustomPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - pageControlHeight, frame.size.width, pageControlHeight)];
        [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [pageControl setCurrentPageIndicatorTintColor:HexRGB(0x00b4a2)];
        [pageControl setPageIndicatorTintColor:[UIColor groupTableViewBackgroundColor]];
        
        [self addSubview:scrollView];
        [self addSubview:pageControl];
//        int kNumberOfPages = (int) array.count;
        
        scrollView.pagingEnabled = YES;
//        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;

//        pageControl.numberOfPages = kNumberOfPages;
//        pageControl.currentPage = 0;
//        
//        [self loadScrollViewWithPage:0];
//        [self loadScrollViewWithPage:1];
        self.scrollView = scrollView;
        self.pageControl = pageControl;
    }
        return self;
}

- (void)loadScrollViewWithPage:(int)page {
    
    int kNumberOfPages =(int) self.views.count;
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    // replace the placeholder if necessary
    UIView *view = [_views objectAtIndex:page];
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [view addGestureRecognizer:gesture];
    view.userInteractionEnabled=YES;
    if ((NSNull *)view == [NSNull null]) {
        view = [[UIView alloc] initWithFrame:self.scrollView.bounds];
        [_views replaceObjectAtIndex:page withObject:view];
    }
    // add the controller's view to the scroll view
    if (nil == view.superview) {
        CGRect frame =  self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [self.scrollView addSubview:view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (pageControlUsed) {
        return;
    }
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
//    [self removeTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    pageControlUsed = YES;
//    self.timeLoop = YES;
}
// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (void)changePage:(id)sender
{
    int page =(int) self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

-(void)setTimeLoop:(BOOL)timeLoop
{
    if(timeLoop)
    {
      self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(runtimePage) userInfo:nil repeats:YES];
    }
}

-(void)runtimePage
{
    NSInteger  page=self.pageControl.currentPage;
    if(page==0)
        switchDirection=rightDirection;
    else if(page==self.views.count-1)
        switchDirection=leftDirection;
    
    if(switchDirection==rightDirection)
        page++;
    else if(switchDirection==leftDirection)
        page--;
        
    self.pageControl.currentPage=page;
    [self changePage:self.pageControl];
    
}

-(void)tap
{
    if([self.delegate respondsToSelector:@selector(clickImage:)])
    {
        [self.delegate clickImage:self.pageControl.currentPage];
    }
}
/**
 *  关闭定时器
 */
- (void)removeTimer
{
     [self.timer invalidate];
}
@end
