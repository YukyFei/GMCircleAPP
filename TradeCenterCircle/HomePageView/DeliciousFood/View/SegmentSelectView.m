//
//  SegmentSelectView.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/9/5.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "SegmentSelectView.h"

@implementation SegmentSelectView

-(instancetype)initWithFrame:(CGRect)rect withArray:(NSArray *)array withWith:(CGFloat)width withHeight:(CGFloat)height
{
    self = [super initWithFrame:rect];
    
    if (self) {
        
        _segmentControl=[[UISegmentedControl alloc]initWithItems:array];
        _segmentControl.segmentedControlStyle=UISegmentedControlStyleBar;
        _segmentControl.backgroundColor = [UIColor clearColor];
        _segmentControl.layer.masksToBounds = YES;
        _segmentControl.tintColor = [UIColor clearColor];
        
        //设置位置 大小
        _segmentControl.frame=CGRectMake(0, 0, width, height);
        //默认选择索引
        _segmentControl.selectedSegmentIndex=0;
        
        //选中字体颜色
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[SizeUtility textFontSize:default_FoodShop_title_size]],
                                                 NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#b6001b"]};
        [_segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
        
        //默认字体颜色
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[SizeUtility textFontSize:default_FoodShop_title_size]],
                                                   NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#666666"]};
        [_segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        //设置监听事件
        [_segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segmentControl]; 
    }
    
    return self;
}

-(void)change:(UISegmentedControl *)segment
{
    if ([self.delegate respondsToSelector:@selector(selectSegment:)]) {
        [self.delegate selectSegment:segment.selectedSegmentIndex];
    }
}

@end
