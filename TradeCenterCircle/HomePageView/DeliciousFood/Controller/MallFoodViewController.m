//
//  MallFoodViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MallFoodViewController.h"
#import "MallFoodListModel.h"
#import "MallFoodListCell.h"
#import "DeliciousFoodIndexView.h"
#import "TheChainViewController.h"

@interface MallFoodViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView         *tableView;
@property(nonatomic,strong) NSMutableArray      *dataArray;

@end

@implementation MallFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"商城美食"];
    
    _dataArray = [NSMutableArray array];
    
    [self initSubviews];
}

- (void)initSubviews
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH , SCREENHEIGHT-64) style:UITableViewStylePlain];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)headerRefreshings
{
    [self loadData];
}

-(void)loadData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"goods_food" forKey:@"Shop_type"];

    [HttpService postWithServiceCode:kGetShopList params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        [self.dataArray removeAllObjects];
        
        if ([dicresult validateOk]) {

            NSArray *arr = dicresult[@"Data"];
            
            for (NSDictionary * dict in arr) {
                MallFoodListModel * model = [MallFoodListModel modelWithDic:dict] ;
                [self.dataArray addObject:model];
            }

            [self.tableView.legendHeader endRefreshing];
            [self.tableView.legendFooter endRefreshing];
            [self.tableView reloadData];
            
        }else{
            [self.tableView.legendHeader endRefreshing];
            [self.tableView.legendFooter endRefreshing];
            
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
                [MBProgressHUD showError:@"没有更多了"];
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"MallFoodListCell";
    MallFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[MallFoodListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    MallFoodListModel *model = self.dataArray[indexPath.row];
    [cell refreshCellWithModel:model];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 54)];
//    headView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//    
//    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
//    orderView.backgroundColor = [UIColor whiteColor];
//    [headView addSubview:orderView];
//    
//    UILabel *orderLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
//    orderLab.textColor = [UIColor colorWithHexString:@"#666666"];
//    orderLab.text = @"预订单";
//    orderLab.textAlignment = NSTextAlignmentCenter;
//    orderLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]];
//    [orderView addSubview:orderLab];
//    
//    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-32, 0, 32, 44)];
//    arrowImage.image = [UIImage imageNamed:@"common_btn_more"];
//    [orderView addSubview:arrowImage];
//    
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookOrderVC)];
//    [headView addGestureRecognizer:tapGes];
//    
//    return headView;
//}

//预订单
-(void)bookOrderVC{

}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 54;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallFoodListModel *model = self.dataArray[indexPath.row];
    
    //美食上门
    if ([model.Shop_out isEqualToString:@"no"]) {
        
        //不是外链
        self.hidesBottomBarWhenPushed=YES;
        DeliciousFoodIndexView *deliciousVC = [[DeliciousFoodIndexView alloc] init];
        deliciousVC.titleStr = model.Shop_name;
        deliciousVC.shopID = model.Shop_id;
        deliciousVC.signStr = @"";
        [self.navigationController pushViewController:deliciousVC animated:YES];
        
    }else{
        //是外链
        self.hidesBottomBarWhenPushed=YES;
        TheChainViewController *webVC = [[TheChainViewController alloc] init];
        webVC.titleStr = model.Shop_name;
        webVC.Shop_url = model.Shop_url;
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

@end
