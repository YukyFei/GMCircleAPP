//
//  ScrollerTimerViewController.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollerBannerDelegate <NSObject>

-(void)clickImage:(NSInteger)index;

@end

@interface ScrollerTimerViewController : UIViewController

@property(nonatomic,strong)id<ScrollerBannerDelegate>delegate;

@property(nonatomic,strong)NSMutableArray *pathArray;

@end
