//
//  SegmentSelectView.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/9/5.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol segmentSelectDelegate;

@interface SegmentSelectView : UIView

@property(nonatomic,strong)id<segmentSelectDelegate>delegate;

@property(nonatomic,strong)UISegmentedControl *segmentControl;

-(instancetype)initWithFrame:(CGRect)rect withArray:(NSArray *)array withWith:(CGFloat)width withHeight:(CGFloat)height;

@end

@protocol segmentSelectDelegate <NSObject>

//用于区别点击的哪个索引
-(void)selectSegment:(NSInteger)segment;

@end
