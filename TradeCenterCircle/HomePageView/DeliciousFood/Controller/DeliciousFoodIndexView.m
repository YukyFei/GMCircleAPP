//
//  DeliciousFoodIndexView.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "DeliciousFoodIndexView.h"
#import "DeliciousFoodIndexCell.h"
#import "FlowerServiceView.h"
#import "DeliciousFoodListModel.h"
#import "ReceiveCouponViewController.h"
#import "DeliciousFoodIndexDetailView.h"

@interface DeliciousFoodIndexView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView         *tableView;
@property(nonatomic,strong) NSMutableArray      *dataArray;
@property(nonatomic,strong) FlowerServiceView   *flowerServiceView;
@property(nonatomic,assign) NSInteger           clickNum;
@property(nonatomic,copy)   NSString            *pageSize;
@property(nonatomic,copy)   NSString            *Order_type;
@property(nonatomic,copy)   NSString            *Cat_id;
@property(nonatomic,copy)   NSString            *Order_by;

@end

@implementation DeliciousFoodIndexView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:self.titleStr];
    
    //判断token是否失效
    [[RefreshManager manager] isRefreshToken];
    
    _dataArray = [NSMutableArray array];
    self.Order_type = @"compre";
    self.Order_by = @"asc";
    
    [self initSubviews];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 32)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#ffdede"];
    bgView.tag = 1001;
    [self.view addSubview:bgView];
    bgView.hidden = YES;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 32)];
    lab.tag = 30;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor colorWithHexString:@"#ff0000"];
    lab.font = [UIFont systemFontOfSize:12.0];
    lab.userInteractionEnabled = YES;
    [bgView addSubview:lab];
    
    UITapGestureRecognizer  *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveCoupon)];
    [bgView addGestureRecognizer:tapGes];
}

//领取优惠券
-(void)receiveCoupon
{
    ReceiveCouponViewController *receiveVC = [[ReceiveCouponViewController alloc] init];
    [self.navigationController pushViewController:receiveVC animated:YES];
}

- (void)initSubviews
{
   /*修改*/
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREENWIDTH, 45);
    bgView.backgroundColor = [UIColor whiteColor];
    
    _flowerServiceView = [[FlowerServiceView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
    _flowerServiceView.backgroundColor = [UIColor orangeColor] ;
    _flowerServiceView.statis = NO;
    [_flowerServiceView createUI];
    [_flowerServiceView.allBtn addTarget:self action:@selector(priceBtnCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    [_flowerServiceView.volumeBtn addTarget:self action:@selector(priceBtnCLC:) forControlEvents:UIControlEventTouchUpInside];
    [_flowerServiceView.NewProductBtn addTarget:self action:@selector(priceBtnCLC:) forControlEvents:UIControlEventTouchUpInside];
    [_flowerServiceView.priceBtn addTarget:self action:@selector(priceBtnCLC:) forControlEvents:UIControlEventTouchUpInside];
    [_flowerServiceView.jiantouBtn addTarget:self action:@selector(priceBtnCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    _flowerServiceView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_flowerServiceView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SCREENWIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [bgView addSubview:lineView];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH , SCREENHEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = aView;
    self.tableView.tableHeaderView = bgView;
    
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
    [_tableView.legendHeader beginRefreshing];
    
    //上拉加载
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

//商品分类button的点击事件
-(void)priceBtnCLC:(UIButton *)sender
{
    self.pageSize = @"1";
    //    综合:compre,销量:sales,新品上架：created，价格：price)
    if (sender.tag <104) {
        
        //        common_btn_descending    common_btn_ascending
        for (UIButton *btn in self.flowerServiceView.subviews) {
            if (btn.tag ==sender.tag) {
                [btn setTitleColor:[UIColor colorWithHexString:@"#b6001b"] forState:UIControlStateNormal] ;
                
            }else{
                [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal] ;
            }
        }
        if (sender.tag == 103) {
            //价格          (正序：asc,倒序：desc)
            self.Order_type = @"price" ;
            self.clickNum ++ ;
            if (self.clickNum ==2) {
                [self.flowerServiceView.jiantouBtn setImage:[UIImage imageNamed:@"common_btn_ascending"] forState:UIControlStateNormal] ;
                //倒序
                self.Order_by = @"desc" ;
            }else if(self.clickNum>2){
                self.clickNum = 1 ;
                [self.flowerServiceView.jiantouBtn setImage:[UIImage imageNamed:@"common_btn_descending"] forState:UIControlStateNormal] ;
                //正序
                self.Order_by = @"asc" ;
            }else{
                
            }
        }else{
            self.clickNum = 0 ;
            [self.flowerServiceView.jiantouBtn setImage:[UIImage imageNamed:@"common_btn_descending"] forState:UIControlStateNormal] ;
            if (sender.tag ==100) {
                //综合
                self.Order_type = @"compre" ;
            }else if (sender.tag ==101){
                //销量
                self.Order_type = @"sales" ;
            }else{
                //新品上架
                self.Order_type = @"created" ;
            }
            self.Order_by = @"asc" ;
        }
    }else{
        for (UIButton *btn in self.flowerServiceView.subviews) {
            if (btn.tag ==103) {
                [btn setTitleColor:[UIColor colorWithHexString:@"#b6001b"] forState:UIControlStateNormal] ;
            }else{
                [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal] ;
            }
        }
        //箭头
        self.clickNum ++ ;
        if (self.clickNum ==2) {
            self.Order_by = @"desc" ;
            [self.flowerServiceView.jiantouBtn setImage:[UIImage imageNamed:@"common_btn_ascending"] forState:UIControlStateNormal] ;
            
        }else if(self.clickNum >2){
            self.Order_by = @"asc" ;
            [self.flowerServiceView.jiantouBtn setImage:[UIImage imageNamed:@"common_btn_descending"] forState:UIControlStateNormal] ;
            
            self.clickNum = 1 ;
        }
    }
    NSLog(@"%ld",(long)sender.tag) ;
    NSLog(@"%@",self.Order_by) ;
    [self loadData];
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
    [self.tableView.legendFooter beginRefreshing];
    int a = [self.pageSize intValue];
    a++ ;
    self.pageSize = [NSString stringWithFormat:@"%d",a];
    [self loadData];
}

-(void)loadData
{
    NSString *page = [NSString stringWithFormat:@"%@",self.pageSize];
    NSString *headStr;

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if ([self.signStr isEqualToString:@""]) {
        //美食上门
        headStr = kGetProductList;
    }else{
        //美食预定
        headStr = kGetReserveList;
        [dic setValue:self.signStr forKey:@"Shop_date"];
    }
    
    [dic setValue:self.shopID forKey:@"Shop_id"];
    [dic setValue:page forKey:@"Page"];
    [dic setValue:self.Order_type forKey:@"Order_type"];
    [dic setValue:self.Order_by forKey:@"Order_by"];
    
    UIView *bgView = [self.view viewWithTag:1001];
    
    [HttpService postWithServiceCode:headStr params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            
            NSArray *data = [dicresult objectForKey:@"Data"][@"Product_list"];
            
            UILabel *lab = (UILabel *)[self.view viewWithTag:30];
            lab.text = [NSString stringWithFormat:@"%@",[dicresult objectForKey:@"Data"][@"Coupon_text"]];
            
            if ([dicresult[@"Data"][@"Coupon"] isEqualToString:@"2"]) {
                _tableView.frame = CGRectMake(0, 64 + 32, SCREENWIDTH , SCREENHEIGHT-64-32);
                bgView.hidden = NO;
            }else{
                _tableView.frame = CGRectMake(0, 64 , SCREENWIDTH , SCREENHEIGHT-64);
                bgView.hidden = YES;
            }
            
            if ([self.pageSize isEqualToString:@"1"]) {
                [self.dataArray removeAllObjects];
            }
            
            for (NSDictionary * dict in data) {
                DeliciousFoodListModel * model = [DeliciousFoodListModel modelWithDic:dict] ;
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
                _tableView.frame = CGRectMake(0, 64 , SCREENWIDTH , SCREENHEIGHT-64);
                bgView.hidden = YES;
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
    static NSString *indentifier = @"DeliciousFoodIndexCell";
    DeliciousFoodIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[DeliciousFoodIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    DeliciousFoodListModel *model = self.dataArray[indexPath.row];
    [cell refreshCellWithModel:model];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

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
    DeliciousFoodListModel *model = self.dataArray[indexPath.row];
    
    DeliciousFoodIndexDetailView *deliciousVC = [[DeliciousFoodIndexDetailView alloc] init];
    deliciousVC.productName = model.Product_name;
    deliciousVC.productId = model.Product_id;
    deliciousVC.wailianURL = model.Product_url ;
    if ([USER_DEFAULT objectForKey:kGetIntoVC] == nil) {
        
        //第一次进入网页时候token的参数需要拼接
        deliciousVC.signStr = @"1";
        
    }else{
        //第二次进入网页时候token的参数不需要拼接
        deliciousVC.signStr = @"2";
    }
    
    [self.navigationController pushViewController:deliciousVC animated:YES];
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
