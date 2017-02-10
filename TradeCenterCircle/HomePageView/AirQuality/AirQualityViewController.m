//
//  AirQualityViewController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 17/1/4.
//  Copyright © 2017年 weiwei-zhang. All rights reserved.
//

#import "AirQualityViewController.h"
#import "AirQualityTableViewCell.h"


@interface AirQualityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tableView ;

@property(nonatomic,strong) NSMutableArray * dataArry ;
@end

@implementation AirQualityViewController

-(NSMutableArray *)dataArry
{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array] ;
    }
    return _dataArry ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"空气质量"];
    [self createUI] ;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)createUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviBarHeight, SCREENWIDTH, VIEW_H(self.view)-NaviBarHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
    [self.view addSubview:_tableView];
}
-(void)headerRefreshings
{
    [self loadData] ;
}


-(void)loadData
{
    NSDictionary * dictpragram = @{@"Community_id":[USER_DEFAULT objectForKey:kCommunityId]} ;
    [HttpService postWithServiceCode:kGET_Weather_List params:dictpragram success:^(AFHTTPRequestOperation *operation, id jsonObj) {
       
        NSDictionary * dict = (NSDictionary *)jsonObj ;
        if ([dict validateOk]) {
            [self.tableView.header endRefreshing];
            if (_dataArry.count>0) {
                [_dataArry removeAllObjects];
            }
            for (NSDictionary * dic in dict[@"Data"]) {
                AirQualityModel * model = [AirQualityModel modelWithDic:dic] ;
                [self.dataArry addObject:model];
            }
            [self.tableView reloadData];
            
        }

        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    
}



#pragma tableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArry.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"cellID" ;
     AirQualityTableViewCell * cell = [[AirQualityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    AirQualityModel * model = self.dataArry[indexPath.row] ;
    cell.model = model ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 * SCREENWIDTH /320 ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
