//
//  VShowImgs.h
//  weGame
//
//  Created by zy-iOS on 14/9/26.
//  Copyright (c) 2014年 BlueRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VShowImgs;
@protocol VShowImgsDelegate <NSObject>

@optional
-(void)VShowImgs:(VShowImgs *)showimgs deletetag:(NSInteger)index;
-(void)VShowImgs:(VShowImgs *)showimgs covertag:(NSInteger)index;

@end

@interface VShowImgs : UIView
@property(nonatomic,strong) UIButton *btDelete;
@property(nonatomic,strong) NSMutableArray *imgs;//要显示的图片
@property(nonatomic,assign) NSInteger index;//当前显示第index张 从0开始
@property(nonatomic,assign) BOOL editeable;

@property(nonatomic,weak) id<VShowImgsDelegate> delegate;

-(void)show;

@end
