//
//  YMRefreshTableView.m
//  YourMate
//
//  Created by Tang Shilei on 14-12-5.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//


#import "YMRefreshTableView.h"
#import "MJRefresh.h"

#define CELL_HEIGHT 44
@interface YMRefreshTableView()

@property (nonatomic,copy) TableViewCellConfigureBlock configureCellBlock;
@property(nonatomic,copy)TableViewCellSelectBlock selectBlock;
@property(nonatomic,copy)TableViewCellHeightBlock heightBlock;
@end

@implementation YMRefreshTableView

/**
 *  初始化方法
 *
 *  @param frame 大小
 *  @param style 类型
 *
 *  @return UITableView
 */
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self=[super initWithFrame:frame style:style];
    if(self)
    {
        //[self createUI];
        self.delegate=self;
        self.dataSource=self;
    }
    
    return self;
}

-(void)beginRefreshing
{
    [self.legendHeader beginRefreshing];
}

-(void)finishLoadHeaderRefresh
{
    [self.legendHeader endRefreshing];
}

-(void)finishLoadFooterRefresh
{
    [self.legendFooter endRefreshing];
}

- (void)setEnableHeader:(BOOL)tf
{
    if(tf)
    {
        __weak YMRefreshTableView *weakSelf=self;
        [self addLegendHeaderWithRefreshingBlock:^{
            if([weakSelf.refreshDelegate respondsToSelector:@selector(loadHeader)])
            {
                [weakSelf.refreshDelegate loadHeader];
            }

        }];
    }
}

- (void)setEnableFooter:(BOOL)tf
{
    if(tf)
    {
        __weak YMRefreshTableView *weakSelf=self;
        [self addLegendFooterWithRefreshingBlock:^{
            if([weakSelf.refreshDelegate respondsToSelector:@selector(loadFooter)])
            {
                [weakSelf.refreshDelegate loadFooter];
            }
        }];
    }
}

+(instancetype)configTableViewframe:(CGRect)frame style:(UITableViewStyle)style items:(NSArray *)anItems idenTifier:(NSString*)identifier configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock selectCellBlock:(TableViewCellSelectBlock)selectBlock heightBlock:(TableViewCellHeightBlock)heightBlock
{
    YMRefreshTableView *tableView =[self configTableViewframe:frame style:style items:anItems configureCellBlock:aConfigureCellBlock selectCellBlock:selectBlock heightBlock:heightBlock];
    [tableView registerClass:NSClassFromString(identifier) forCellReuseIdentifier:@"cell"];
    return tableView;
}


+(instancetype)configTableViewframe:(CGRect)frame style:(UITableViewStyle)style items:(NSArray *)anItems configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock selectCellBlock:(TableViewCellSelectBlock)selectBlock heightBlock:(TableViewCellHeightBlock)heightBlock
{
    
    YMRefreshTableView *tableView=[[self alloc] initWithFrame:frame style:style];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView* v = [[UIView alloc]init];
    tableView.tableFooterView = v;
    
    tableView.items=anItems;
    tableView.configureCellBlock=[aConfigureCellBlock copy];
    tableView.selectBlock=[selectBlock copy];
    tableView.heightBlock=[heightBlock copy];
    return tableView;
    
}



+(instancetype)configTableViewframe:(CGRect)frame items:(NSArray *)anItems  selectCellBlock:(TableViewCellSelectBlock)selectBlock
{
    
    YMRefreshTableView *tableView=[[self alloc]initWithFrame:frame style:UITableViewStylePlain];
    //分割线
    //UIEdgeInsets edgeInset = tableView.separatorInset;
    
    if([tableView respondsToSelector:@selector(setSeparatorInset:)])
        //tableView.separatorInset = UIEdgeInsetsMake(edgeInset.top, 0, edgeInset.bottom, edgeInset.right);//修改分隔线长度
        [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIView* v = [[UIView alloc]init];
    tableView.tableFooterView = v;
    
    //
    tableView.items=anItems;
    tableView.selectBlock=[selectBlock copy];
    return tableView;
    
}


- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return   [self.items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.configureCellBlock){
            UITableViewCell *cell= [YMTableViewCell configCellForTableView:tableView];
            id item = [self itemAtIndexPath:indexPath];
            self.configureCellBlock(cell, item);
            return cell;
    }
    else{
        
       id<YMTableViewCellDelegate>cell = [YMTableViewCell cellForTableView:tableView];
       id item = [self itemAtIndexPath:indexPath];
       [cell configForCellWithData:item];
        return (UITableViewCell*)cell;
    }
    return nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.heightBlock){
        
        return  self.heightBlock(indexPath)>44?self.heightBlock(indexPath):44;
    }
    else{
        
    id data =self.items[indexPath.row];
    id<YMTableViewCellDelegate>cell =(id<YMTableViewCellDelegate>)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if([cell respondsToSelector:@selector(heightForData:)])
         return [cell heightForData:data];
    
    }
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.selectBlock)
        self.selectBlock(indexPath);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
