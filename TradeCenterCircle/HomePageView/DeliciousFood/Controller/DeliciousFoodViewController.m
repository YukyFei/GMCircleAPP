//
//  DeliciousFoodViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "DeliciousFoodViewController.h"
#import "DeliciousFoodCell.h"
#import "DeliciousFoodIndexView.h"
#import "ScrollerTimerViewController.h"
#import "TheChainViewController.h"
#import "MallFoodViewController.h"

@interface DeliciousFoodViewController ()<UITableViewDelegate,UITableViewDataSource,ScrollerBannerDelegate>
{
    ScrollerTimerViewController *scrollerVC;
}

@property(nonatomic,strong) UITableView     *tableView;
@property(nonatomic,strong) NSMutableArray  *dataArray;
@property(nonatomic,strong) NSMutableArray  *logoArray; //存储美食上门图标

@end

@implementation DeliciousFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"美食上门"];
    
    _dataArray = [NSMutableArray array];
    _logoArray = [NSMutableArray array];
    [self initSubviews];
    
    [self loadData];
}

- (void)initSubviews
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , SCREENWIDTH , SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = aView;
    
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
    [_tableView.legendHeader beginRefreshing];
}

-(void)loadLogoData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"food" forKey:@"Shop_type"];
    
    [HttpService postWithServiceCode:kGetShopList params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;

        if ([dicresult validateOk]) {
            self.logoArray = dicresult[@"Data"];
            
            [self.tableView.legendHeader endRefreshing];
            [self.tableView reloadData];
            
        }else{
            [self.tableView.legendHeader endRefreshing];
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.legendHeader endRefreshing];
    }];
}

-(void)headerRefreshings
{
    [self loadData];
}

-(void)loadData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary] ;
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"food" forKey:@"Position"];
    
    [HttpService postWithServiceCode:kGetFigure params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            
            _dataArray = dicresult[@"Data"];
            
            [self.tableView.legendHeader endRefreshing];
            [self.tableView reloadData];
            
            [self loadLogoData];
        }else{
            [self.tableView.legendHeader endRefreshing];
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.legendHeader endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"DeliciousFoodCell";
    DeliciousFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[DeliciousFoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    if (self.logoArray.count<=0) {
        
    }else{
        
        [cell refreshCellWithModel:self.logoArray];
    }
    
    __weak __typeof(self)weakSelf = self;
    
    [cell logoTapVCBlock:^(NSInteger indexTag, NSString *titleStr) {
        __weak __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf) {
            //美食上门
            if ([self.logoArray[indexTag][@"Shop_out"] isEqualToString:@"no"]) {
                
                if ([titleStr isEqualToString:@"商城美食"]) {
                    self.hidesBottomBarWhenPushed = YES;
                    MallFoodViewController *mallFoodView = [[MallFoodViewController alloc] init];
                    [self.navigationController pushViewController:mallFoodView animated:YES];
                }else{
                    //不是外链
                    self.hidesBottomBarWhenPushed=YES;
                    DeliciousFoodIndexView *deliciousVC = [[DeliciousFoodIndexView alloc] init];
                    deliciousVC.titleStr = titleStr;
                    deliciousVC.shopID = self.logoArray[indexTag][@"Shop_id"];
                    deliciousVC.signStr = @"";
                    [self.navigationController pushViewController:deliciousVC animated:YES];
                }
                
            }else{
                //是外链
                self.hidesBottomBarWhenPushed=YES;
                TheChainViewController *webVC = [[TheChainViewController alloc] init];
                webVC.titleStr = self.logoArray[indexTag][@"Shop_name"];
                webVC.Shop_url = self.logoArray[indexTag][@"Shop_url"];
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
    }];
    
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SCREENWIDTH/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"DeliciousFoodCell";
    DeliciousFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[DeliciousFoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }

    return 20+45+[cell cellHeight:self.logoArray]+1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2);
    if (_dataArray.count <=0) {
    }else
    {
        if (!scrollerVC) {
            scrollerVC = [[ScrollerTimerViewController alloc] init];
            scrollerVC.delegate = self;
        }
        
        NSMutableArray *paths = [NSMutableArray array];
        
        for (NSInteger i=0; i<_dataArray.count; i++) {
            
            [paths addObject:_dataArray[i][@"O_pic"]];
        }
        scrollerVC.pathArray = paths;
        [bgView addSubview:scrollerVC.view];
    }
    
    return bgView;
}

-(void)clickImage:(NSInteger)index
{
    NSDictionary *dic = nil;
    dic = _dataArray[index];
    
    if ([[dic objectForKey:@"O_url"] isEqualToString:@""]) {
        
    }else{

        self.hidesBottomBarWhenPushed=YES;
        TheChainViewController *webVC = [[TheChainViewController alloc] init];
        webVC.titleStr = [dic objectForKey:@"O_title"];
        webVC.Shop_url = [dic objectForKey:@"O_url"];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

-(void)dealloc
{
    self.tableView = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.dataArray = nil;
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
