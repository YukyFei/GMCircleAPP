//
//  FlowerServiceViewController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "FlowerServiceViewController.h"
#import "FlowerHeaderBtnView.h"
#import "FlowerServiceView.h"
#import "FlowerServiceViewCell.h"
#import "ScrollerTimerViewController.h"
#import "FlowerHeadModel.h"
#import "FlowerPicModel.h"
#import "FlowerSeverModel.h"
#import "TheChainViewController.h"
#import "GMQWebViewController.h"

CGFloat kCustomViewHeight;
CGFloat flowserviceHei ;

@interface FlowerServiceViewController ()<FlowerViewDelegate,UITableViewDataSource,UITableViewDelegate,ScrollerBannerDelegate>
{
    ScrollerTimerViewController *scrollerVC;
}

@property(nonatomic,strong) FlowerHeaderBtnView         *flowerHeaderView;
@property(nonatomic,strong) FlowerServiceView           *flowerServiceView;
@property(nonatomic,strong) NSMutableArray              *titleARR;
@property(nonatomic,strong) UITableView                 *tableView;
@property(nonatomic,strong) UIScrollView                *scrollView;
@property(nonatomic,assign) NSInteger                   clickNum;
@property(nonatomic,strong) NSMutableArray              *pathArray;
@property(nonatomic,strong) NSMutableArray * dataArr ;

//@property(nonatomic,copy) NSString * Shop_id ;
@property(nonatomic,assign) NSInteger currentPage ;
//"desc": "Order_type(综合:compre,销量:sales,新品上架：created，价格：price),Order_by(正序：desc,倒序：asc),Cat_id:商品分类(允许为空)"
@property(nonatomic,copy) NSString * Order_type ;
@property(nonatomic,copy) NSString * Cat_id ;
@property(nonatomic,copy) NSString * Order_by ;
@property(nonatomic,copy) NSString * OldCatID ;


@end


@implementation FlowerServiceViewController
-(NSMutableArray *)titleARR
{
    if (!_titleARR) {
        _titleARR = [NSMutableArray array] ;
    }
    return _titleARR ;
}
-(NSMutableArray *)pathArray
{
    if (!_pathArray) {
        _pathArray = [NSMutableArray array] ;
    }
    return _pathArray ;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array] ;
    }
    return _dataArr ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断token是否失效
    [[RefreshManager manager] isRefreshToken];
    
    [self setNaviBarTitle:self.titleStr];
    self.pathArray = [NSMutableArray array];
    
    [self createTableview];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    self.currentPage = 1 ;
    self.Order_type = @"compre" ;
    self.Order_by = @"asc" ;
    [self loadHeadWithShopID:self.Shop_id] ;
  
}

-(void)loadHeadWithShopID:(NSString *)shopID
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
      [dict setValue:self.Shop_id forKey:@"Shop_id"];
    [HttpService postWithServiceCode:GET_PRODUCT_CAT params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        if ([resultDic validateOk]) {
            if (self.titleARR.count>0) {
                [self.titleARR removeAllObjects];
            }
            if (self.pathArray.count>0) {
                [self.pathArray removeAllObjects];
            }
            for (NSDictionary * dic in [resultDic[@"Data"] objectForKey:@"Cat"]) {
                FlowerHeadModel * model = [FlowerHeadModel modelWithDic:dic] ;
                [self.titleARR addObject:model];
            }
            for (NSDictionary * dic  in [resultDic[@"Data"] objectForKey:@"Figure"]) {
                FlowerPicModel * model = [FlowerPicModel modelWithDic:dic] ;
                [self.pathArray addObject:model];
            }
            
            [_flowerHeaderView reloadData];
            
            if (self.titleARR.count==0) {
                flowserviceHei = 0;
            }else{
                flowserviceHei = 44*SCREENHEIGHT/667;
            }
            //如果有分类默认加载第一个分类，没有置为空
            if (self.titleARR.count ==0 ) {
                self.Cat_id = @"" ;
            }else{
                self.Cat_id = [[self.titleARR firstObject] valueForKey:@"Cat_id"] ;
            }
            //获取商品信息
            [self loadProductList] ;
            [self createHeadView] ;
            self.OldCatID = self.Cat_id ;
            
        }else{
            if (self.titleARR.count==0) {
                flowserviceHei = 0;
            }else{
                flowserviceHei = 44*SCREENHEIGHT/667;
            }
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    
//        [SVMessageHUD showInView:self.view status:@"服务器响应异常" afterDelay:1.5f] ;
    }];
    
    
}
/**
 * 下载商品信息
 */
-(void)loadProductList
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    NSString * page = [NSString stringWithFormat:@"%ld",self.currentPage] ;
        [dict setValue:self.Shop_id forKey:@"Shop_id"] ;
    [dict setValue:page forKey:@"Page"] ;
    [dict setValue:self.Order_type forKey:@"Order_type"] ;
    [dict setValue:self.Order_by forKey:@"Order_by"] ;
    [dict setValue:self.Cat_id forKey:@"Cat_id"] ;
  
    [HttpService postWithServiceCode:kGetProductList params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        [self.tableView.legendFooter endRefreshing];
        [self.tableView.legendHeader endRefreshing];
        if ([resultDic validateOk]) {
            if (self.dataArr.count>0&&self.currentPage ==1) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary * dic in [resultDic[@"Data"] objectForKey:@"Product_list"]) {
                FlowerSeverModel * model = [FlowerSeverModel modelWithDic:dic] ;
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
            self.OldCatID = self.Cat_id ;
            
        }else{
            if ([[resultDic objectForKey:@"Message"] isEqualToString:@"not more data"]) {
                if (![self.OldCatID isEqualToString:self.Cat_id]) {
                   [self.dataArr removeAllObjects];
                    self.OldCatID = self.Cat_id ;
                }
                
            }else{
                 [MBProgressHUD showError:@"加载失败"];
            }
            [self.tableView reloadData];
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.legendFooter endRefreshing];
        [self.tableView.legendHeader endRefreshing];
    }];
    
}


//商品顶部轮播及分类
-(void)createHeadView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREENWIDTH, 195*SCREENHEIGHT/667);
    CGFloat y = 0 ;
    if (self.pathArray.count <=0) {
    }else
    {
        if (!scrollerVC) {
            scrollerVC = [[ScrollerTimerViewController alloc] init];
            scrollerVC.delegate = self;
        }
        
        NSMutableArray *paths = [NSMutableArray array];
        
        for (NSInteger i=0; i<self.pathArray.count; i++) {
            [paths addObject:self.pathArray[i][@"O_pic"]];
        }
        scrollerVC.pathArray = paths;
        [bgView addSubview:scrollerVC.view];
        y=150 ;
    }
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal ;
    _flowerHeaderView = [[FlowerHeaderBtnView alloc]initWithFrame:CGRectMake(0,y,SCREENWIDTH,flowserviceHei) collectionViewLayout:layout];
    _flowerHeaderView.scrollEnabled = YES;
    //设置取消滑动弹性
    self.flowerHeaderView.bounces = YES;
    //隐藏横向滚动条
    self.flowerHeaderView.showsHorizontalScrollIndicator = NO ;
    [bgView addSubview:self.flowerHeaderView];
    self.flowerHeaderView.dataShops = self.titleARR ;
    self.flowerHeaderView.flowerDelegate = self ;
    _flowerServiceView = [[FlowerServiceView alloc]initWithFrame:CGRectMake(0, VIEW_BY(_flowerHeaderView), SCREENWIDTH, 45)];
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
    
    
    
    if (self.pathArray.count == 0 && self.titleARR.count ==0) {
        [bgView setFrame:CGRectMake(0, 0, SCREENWIDTH, _flowerServiceView.height)];
    }else if (self.pathArray.count ==0){
        [bgView setFrame:CGRectMake(0, 0, SCREENWIDTH, _flowerServiceView.height+_flowerHeaderView.height)];
        
    }else{
        [bgView setFrame:CGRectMake(0, 0, SCREENWIDTH,  _flowerHeaderView.height+ _flowerServiceView.height +150 )];
    }
    self.tableView.tableHeaderView = bgView ;
}

/**
 * 创建商品信息视图
 */
-(void)createTableview
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , SCREENWIDTH , SCREENHEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = aView;
    //
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
       [_tableView.legendHeader beginRefreshing];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshings)] ;
}

-(void)headerRefreshings
{
    self.currentPage = 1 ;
    [self loadProductList] ;
}

-(void)footerRefreshings
{
    self.currentPage ++ ;
    [self loadProductList] ;
}


//商品分类button的点击事件
-(void)priceBtnCLC:(UIButton *)sender
{
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
    [self loadProductList] ;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"FlowerServiceCell";
    FlowerServiceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[FlowerServiceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    FlowerSeverModel * model = self.dataArr[indexPath.row] ;
    cell.model = model ;
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
    FlowerSeverModel * model = self.dataArr[indexPath.row];
    NSString *webUrl = [NSString stringWithFormat:@"Products/Detail?product_id=%@&platform=app",model.Product_id];
    NSString *urlpin = [NSString stringWithFormat:@"Products/Detail?product_id=%@&token=%@&user_id=%@&platform=app",model.Product_id,[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kUserId]] ;
    
    GMQWebViewController * web = [[GMQWebViewController alloc]init];
    if ([USER_DEFAULT objectForKey:kGetIntoVC] == nil) {
        //第一次进入网页时候token的参数需要拼接
        web.Webtitle= model.Product_name ;
        web.InPutUrl = urlpin ;
    }else{
        //第二次进入网页时候token的参数不需要拼接
        web.InPutUrl = webUrl ;
        web.Webtitle = model.Product_name ;
    }
    web.wailianURL = model.Product_url ;
    
    [self.navigationController pushViewController:web animated:YES];
    
}


#pragma -mark FLowerViewDelegate   返回点击的是第几个item
-(void)flowerView:(FlowerHeaderBtnView *)flowerHeaderView didIndexCellClick:(NSInteger)index
{
    NSLog(@"%ld",(long)index) ;
    if (self.titleARR.count>0) {
        FlowerHeadModel * model = self.titleARR[index] ;
        self.Cat_id = model.Cat_id ;
        [self loadProductList] ;
    }
    
}

-(void)clickImage:(NSInteger)index
{
    NSDictionary *dic = nil;
    dic = _pathArray[index];
    
    if ([[dic objectForKey:@"O_url"] isEqualToString:@""]) {
        
    }else{

        self.hidesBottomBarWhenPushed=YES;
        TheChainViewController *webVC = [[TheChainViewController alloc] init];
        webVC.titleStr = [dic objectForKey:@"O_title"];
        webVC.Shop_url = [dic objectForKey:@"O_url"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

-(void)dealloc
{
    self.tableView = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.titleARR = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aaaa" object:nil];
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
