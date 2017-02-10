//
//  YMRefreshTableView.h
//  YourMate
//
//  Created by Tang Shilei on 14-12-5.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//

#import "YMTableView.h"
#import "UITableView+Create.h"
#import "YMTableViewCell.h"
typedef void (^TableViewCellSelectBlock)(NSIndexPath*indexPath);
typedef CGFloat (^TableViewCellHeightBlock)(NSIndexPath*indexPath);
typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@protocol YMRefreshTableDelegate;

@interface YMRefreshTableView : YMTableView<UITableViewDataSource,UITableViewDelegate>

-(void)beginRefreshing;
-(void)finishLoadHeaderRefresh;
-(void)finishLoadFooterRefresh;
//refresh delegate
@property(nonatomic,weak)id<YMRefreshTableDelegate>refreshDelegate;
@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;

////数据
@property (nonatomic, strong) NSArray *items;

+(instancetype)configTableViewframe:(CGRect)frame items:(NSArray *)anItems  selectCellBlock:(TableViewCellSelectBlock)selectBlock;


////类方法
+(instancetype)configTableViewframe:(CGRect)frame style:(UITableViewStyle)style items:(NSArray *)anItems configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock selectCellBlock:(TableViewCellSelectBlock)selectBlock heightBlock:(TableViewCellHeightBlock)heightBlock;


@end
@protocol YMRefreshTableDelegate <NSObject>
@optional
-(void)loadHeader;
-(void)loadFooter;

@end