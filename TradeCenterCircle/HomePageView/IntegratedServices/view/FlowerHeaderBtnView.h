//
//  FlowerHeaderBtnView.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlowerHeaderBtnView ;
@protocol FlowerViewDelegate <NSObject,UICollectionViewDataSource,UICollectionViewDelegate>

@optional
- (void)flowerView:(FlowerHeaderBtnView *)flowerHeaderView didIndexCellClick:(NSInteger)index;

@end

@interface FlowerHeaderBtnView : UICollectionView

@property(nonatomic,strong) UIButton *btn ;
@property (nonatomic ,strong) NSMutableArray *dataShops;
@property(nonatomic,weak)id<FlowerViewDelegate> flowerDelegate;


@end
