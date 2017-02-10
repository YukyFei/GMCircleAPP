//
//  ReceiveCouponViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/9/6.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "ReceiveCouponViewController.h"
#import "ReceiveCouponCell.h"
#import "ReceiveCouponModel.h"

@interface ReceiveCouponViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView       *tabView;
@property(nonatomic,strong) NSMutableArray    *dataList;
@property(nonatomic,copy)   NSString          *pageSize;

@end

@implementation ReceiveCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"获取优惠券"];
    
    _dataList = [NSMutableArray array];
    
    [self loadData];
    
    [self initSubTableViews];
}

-(void)initSubTableViews
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT-64) style:UITableViewStyleGrouped];
        _tabView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.delegate = self;
        _tabView.dataSource = self;
        [self.view addSubview:_tabView];
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tabView.tableFooterView = aView;
        
        //下拉刷新
        [_tabView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
        [_tabView.legendHeader beginRefreshing];
        
        //上拉加载
        [_tabView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pageSize= @"1";
}

-(void)headerRefreshings
{
    self.pageSize = @"1";
    [self loadData];
}

-(void)footerRefreshing
{
    [self.tabView.legendFooter beginRefreshing];
    int a = [self.pageSize intValue];
    a++ ;
    self.pageSize = [NSString stringWithFormat:@"%d",a];
    
    [self loadData];
}

-(void)loadData
{
    NSString *page = [NSString stringWithFormat:@"%@",self.pageSize];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"];
    [dic setValue:page forKey:@"Page"];
    
    [HttpService postWithServiceCode:kAjaxCreateCouponList params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            
            NSArray *data = [dicresult objectForKey:@"Data"];
            
            if ([self.pageSize isEqualToString:@"1"]) {
                [self.dataList removeAllObjects];
            }
            
            for (NSDictionary * dict in data) {
                ReceiveCouponModel * model = [ReceiveCouponModel modelWithDic:dict] ;
                [self.dataList addObject:model];
            }
            
            [self.tabView.legendHeader endRefreshing];
            [self.tabView.legendFooter endRefreshing];
            [self.tabView reloadData];
            
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
                [MBProgressHUD showError:@"没有更多了"];
            }
            [self.tabView.legendHeader endRefreshing];
            [self.tabView.legendFooter endRefreshing];
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tabView.legendHeader endRefreshing];
        [self.tabView.legendFooter endRefreshing];
    }];
}

-(void)receiveCouponData:(NSString *)strID
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"];
    [dic setValue:strID forKey:@"Rule_id"];
    
    [HttpService postWithServiceCode:kCreateCoupon params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            [SVMessageHUD showInView:self.view status:@"领取成功" afterDelay:1.0];
            [self loadData];
            
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
}

#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ReceiveCouponCell";
    
    ReceiveCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ReceiveCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    ReceiveCouponModel *model = self.dataList[indexPath.row];
    return [cell cellHeight:model] + 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyCouponsCell";
    
    ReceiveCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ReceiveCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    __weak __typeof(self)weakSelf = self;

    [cell receiveCouponBlock:^(NSString *ID) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf) {
            //领取优惠券
            [self receiveCouponData:ID];
        }
    }];
    
    ReceiveCouponModel *model = self.dataList[indexPath.row];
    [cell refreshCellWithModel:model];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
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
