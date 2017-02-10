//
//  MyCustomScrollView.h
//  YourMate
//
//  Created by Tang Shilei on 14-12-19.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//

//封装一个 滑动的view
#import <UIKit/UIKit.h>

#define rightDirection 1
#define leftDirection 0

//@protocol MyCustomScrollViewDelegate;

@protocol MyCustomScrollViewDelegate <NSObject>

-(void)clickImage:(NSInteger)index;

@end
@interface MyCustomScrollView : UIView<UIScrollViewDelegate>
{
//    UIScrollView *scrollView;
//    UIPageControl *pageControl;
    BOOL pageControlUsed;
    int switchDirection;
}
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)UIPageControl *pageControl;
@property(nonatomic,weak)id<MyCustomScrollViewDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *views;

@property(nonatomic,assign)BOOL timeLoop;
@property(nonatomic,assign)BOOL isInfiniteLoop;
@property(nonatomic,assign)NSInteger timeInterval;


//-(id)initWithFrame:(CGRect)frame andDataArray:(NSMutableArray*)array;

@end

