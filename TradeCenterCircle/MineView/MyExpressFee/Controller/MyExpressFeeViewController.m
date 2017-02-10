//
//  MyExpressFeeViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyExpressFeeViewController.h"
#import "MyExpressFeeCell.h"
#import "MyExpressFeeModel.h"

@interface MyExpressFeeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView       *tabView;
@property(nonatomic,strong) NSMutableArray    *dataList;
@property(nonatomic,strong) NSDictionary      *data;

@end

@implementation MyExpressFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"我的快递费"];
    
    _dataList = [NSMutableArray array];
    [self initSubTableViews];
    
    [self loadData];
}

-(void)initSubTableViews
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT-64) style:UITableViewStylePlain];
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
    }
}

-(void)headerRefreshings
{
    [self loadData];
}

-(void)loadData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"];
    
    [HttpService postWithServiceCode:kGetOrderMoney params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        [self.dataList removeAllObjects];
        if ([dicresult validateOk]) {
            
            NSArray *arr = dicresult[@"Data"];
            for (NSDictionary *dic in arr) {
                MyExpressFeeModel *model = [MyExpressFeeModel modelWithDic:dic];
                [self.dataList addObject:model];
            }
            
            [self.tabView.legendHeader endRefreshing];
            [self.tabView reloadData];
            
        }else{
            [self.tabView.legendHeader endRefreshing];
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
                [MBProgressHUD showError:@"没有更多了"];
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tabView.legendHeader endRefreshing];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyExpressFeeCell";
    
    MyExpressFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[MyExpressFeeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    return [cell cellHeight] + 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyExpressFeeCell";
    
    MyExpressFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[MyExpressFeeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    MyExpressFeeModel *model = self.dataList[indexPath.row];
    [cell refreshCellWithModel:model];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
