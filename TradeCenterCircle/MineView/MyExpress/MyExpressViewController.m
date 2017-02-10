//
//  MyExpressViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyExpressViewController.h"
#import "MyExpressViewCell.h"
#import "MyExpressModel.h"

@interface MyExpressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView   *tabView;
@property(nonatomic,strong) NSMutableArray *dataList;

@property(nonatomic,assign) NSInteger currentPage ;


@end

@implementation MyExpressViewController

-(NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array] ;
    }
    return _dataList ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"我的快递"];
        [self initSubTableViews];
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
        [_tabView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshings)] ;
    }
}

-(void)headerRefreshings
{
    self.currentPage = 1 ;
    [self loadMessage] ;
}

-(void)footerRefreshings
{
    self.currentPage ++ ;
    [self loadMessage] ;
}

-(void)loadMessage
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
//    {"User_id":"1CBE77CC-FE2E-61A6-5D5D-E858CC7C4ED2","Page":1,"Page_size":5}
//    [dict setValue:@"1CBE77CC-FE2E-61A6-5D5D-E858CC7C4ED2" forKey:@"User_id"];
    [dict setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"] ;
    [dict setValue:[NSString stringWithFormat:@"%ld",self.currentPage] forKey:@"Page"] ;
    [dict setValue:@"5" forKey:@"Page_size"] ;
    [HttpService postWithServiceCode:GET_EXPRESS_LIST params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        
        [self.tabView.legendHeader endRefreshing];
        if ([resultDic validateOk]) {
            if (self.currentPage==1) {
                if (self.dataList.count>0) {
                    [self.dataList removeAllObjects];
                }
            }
            for (NSDictionary * dic in [resultDic[@"Data"] objectForKey:@"Order_list"]) {
                MyExpressModel * model = [MyExpressModel modelWithDic:dic] ;
                [self.dataList addObject:model];
            }
            [self.tabView.legendFooter endRefreshing];
            [self.tabView.legendHeader endRefreshing];
            
            [self.tabView reloadData];
        }else{
            [self.tabView.legendFooter endRefreshing];
            [self.tabView.legendHeader endRefreshing] ;
            [ProgressHUD showActionWithMessage:resultDic[@"Message"] hiddenAffterDelay:1.5f];
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tabView.legendFooter endRefreshing];
        [self.tabView.legendHeader endRefreshing] ;
         [SVMessageHUD showInView:self.view status:@"服务器响应异常" afterDelay:1.5f] ;
    }];
    


}




#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyExpressCell";
    
    MyExpressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MyExpressViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MyExpressModel * model = self.dataList[indexPath.row] ;
    cell.model = model ;
   return [cell cellHeightWithModel:model]+10 ;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyExpressCell";
    
    MyExpressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MyExpressViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MyExpressModel * model = self.dataList[indexPath.row] ;
    cell.model = model ;
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
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
