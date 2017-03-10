//
//  HomeViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "HomeLogoCell.h"
#import "HomeModel.h"
#import "ScrollerTimerViewController.h"
#import "GMQNaviBarView.h"
#import "GGCMTView.h"
#import "CustomTableViewCell.h"
#import "KuaiDIViewController.h"
#import "TheChainViewController.h"
#import "DeliciousFoodViewController.h"
#import "IntegratedServicesViewController.h"
#import "DeliciousFoodReserveController.h"
#import "ParkingServiceViewController.h"
#import "HomeNoticeModel.h"
#import "NoticeViewController.h"
#import "ChangeAddressController.h"
#import "AirQualityViewController.h"
#import "AeroplaneViewController.h"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,ScrollerBannerDelegate,cmtViewDataSource,cmtViewDelegate>
{
    ScrollerTimerViewController *scrollerVC;
   UIView *titleView ;
    
}
@property(nonatomic,strong)   GGCMTView * WordScrollView ;

@property(nonatomic,strong) UITableView            *tableView;
@property(nonatomic,strong) NSMutableArray         *dataArray; //存储轮播图
@property(nonatomic,strong) NSMutableArray         *noticeArray;//存储通知列表
@property(nonatomic,strong) NSMutableArray         *logoArray; //存储首页图标
@property(nonatomic,strong) NSMutableArray         *wailianArray; //存储外链
@property(nonatomic,copy) NSMutableString * Noticeid ;

@end

@implementation HomeViewController
-(NSMutableArray *)noticeArray
{
    if (!_noticeArray) {
        _noticeArray = [NSMutableArray array];
    }
    return _noticeArray ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated] ;
    [titleView removeFromSuperview] ;
    [self createTitleView] ;
    [self.tableView.header beginRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNaviback:YES];
    [self createTitleView] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTitle" object:nil];

    self.dataArray = [NSMutableArray array];
    self.logoArray = [NSMutableArray array];
  
    self.wailianArray = [NSMutableArray array];
    self.Noticeid = [[NSMutableString alloc]init];
    [self initSubviews];
    
    //轮播图
    [self loadBannerData];
    
    //通知轮播
    [self loadnotification] ;
    
    //首页logo
    [self loadLogoData];
    
    //外链
    [self loadWailianData];
    [self notification] ;
}

-(void)rightBarButtonPress
{
    self.hidesBottomBarWhenPushed=YES;
    DeliciousFoodReserveController *deliciousVC = [[DeliciousFoodReserveController alloc] init];
    [self.navigationController pushViewController:deliciousVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

-(void)notification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(relodataHome) name:KNotificationReloDataHome object:nil];
}
-(void)relodataHome
{
    [titleView removeFromSuperview] ;
    [self createTitleView] ;
    [self.tableView.header beginRefreshing];
}

- (void)initSubviews
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , SCREENWIDTH , SCREENHEIGHT-64-[SizeUtility textFontSize:default_TabBar_height_size]) style:UITableViewStyleGrouped];
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

//导航栏的titleView
-(void)createTitleView
{
    titleView = [[UIView alloc]init];
    NSString *titleMes = [USER_DEFAULT objectForKey:kCommunity_name];
    CGSize titleSize = [self sizeWithText:titleMes WithFont:[UIFont systemFontOfSize:[SizeUtility textFontSize:default_NavBar_title_size]] WithMaxSize:CGSizeMake(MAXFLOAT, [SizeUtility textFontSize:default_NavBar_title_size])];
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.userInteractionEnabled = NO;
    titleBtn.frame = CGRectMake(Origin_x, Origin_y, titleSize.width, titleSize.height);
    [titleBtn setTitle:titleMes forState:UIControlStateNormal];
    titleBtn.tag = 100 ;
    [titleView addSubview:titleBtn];
    
    UIImageView *titleImageView = [[UIImageView alloc]init];
    titleImageView.image = [UIImage imageNamed:@"title_jiantou"];
    titleImageView.frame = CGRectMake(VIEW_BX(titleBtn)+5, (titleSize.height-titleImageView.image.size.height)/2, 10, titleImageView.image.size.height);
    [titleView addSubview:titleImageView];
    titleView.frame = CGRectMake(Origin_x, Origin_y, titleSize.width+5+10, titleSize.height);
    
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cilckTitleBtn)];
    [titleView addGestureRecognizer:titleTap];
    [self setNaviBarTitleView:titleView];
}
-(CGSize)sizeWithText:(NSString *)text WithFont:(UIFont *)font WithMaxSize:(CGSize )maxSize
{
    NSDictionary *attri = @{NSFontAttributeName :font};
    return  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
}

//点击titleview跳转到选择小区
-(void)cilckTitleBtn
{
    self.hidesBottomBarWhenPushed = YES ;
    ChangeAddressController * change = [[ChangeAddressController alloc]init];
    [self.navigationController pushViewController:change animated:YES];
    self.hidesBottomBarWhenPushed = NO ;

}


-(void)headerRefreshings
{
    [self loadBannerData];
    [self loadnotification] ;
    [self loadLogoData] ;
    [self loadWailianData] ;
}

-(void)loadBannerData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"index" forKey:@"Position"];
    
    [HttpService postWithServiceCode:kGetFigure params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            self.dataArray = dicresult[@"Data"];

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

-(void)loadnotification
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"1" forKey:@"Page"] ;
    [dic setValue:@"10" forKey:@"Page_size"] ;
    [dic setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"];
    
    [HttpService postWithServiceCode:kRoll_Notice params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            if (self.noticeArray.count>0) {
                [self.noticeArray removeAllObjects];
            }
            int count = 0 ;
            for (NSDictionary * dic in dicresult[@"Data"][@"list"]) {
                if (count == 0) {
                    [self.noticeArray addObject:dic[@"Notice_info"]] ;
                    self.Noticeid = dic[@"Notice_id"] ;
                }else{
                
                    [self.noticeArray addObject:dic[@"Title"]];
                }
                count ++ ;
            }
            [self.WordScrollView prepareScroll];
            [self.WordScrollView startScroll] ;
            
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
      
    }];



}


-(void)loadWailianData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"outside" forKey:@"Position"];
    
    [HttpService postWithServiceCode:kGetFigure params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;

        [self.wailianArray removeAllObjects];
        if ([dicresult validateOk]) {
            
            NSArray *data = [dicresult objectForKey:@"Data"];
            
            for (NSDictionary * dict in data) {
                HomeModel * model = [HomeModel modelWithDic:dict] ;
                [self.wailianArray addObject:model];
            }
            
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

-(void)loadLogoData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    
    [HttpService postWithServiceCode:kGetIndex params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.wailianArray.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *indentifier = @"HomeLogoCell";
        HomeLogoCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[HomeLogoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        
        if (self.logoArray.count<=0) {
        }else{
            [cell refreshCellWithModel:self.logoArray];
        }
        
        __weak __typeof(self)weakSelf = self;
        
        [cell logoTapVCBlock:^(NSInteger indexTag ,NSString *titleStr,NSString *url,NSString *parentID,NSString *outLink) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf) {
                
                if ([self.logoArray[indexTag][@"out_link"] isEqualToString:@"1"]) {
                    //1 是外链
                    self.hidesBottomBarWhenPushed=YES;
                    TheChainViewController *webVC = [[TheChainViewController alloc] init];
                    webVC.titleStr = titleStr;
                    webVC.Shop_url = url;
                    [self.navigationController pushViewController:webVC animated:YES];
                    self.hidesBottomBarWhenPushed=NO;
                    
                }else{
                    //2 不是外链
                    if ([self.logoArray[indexTag][@"name"] isEqualToString:@"物流快递"]) {
                        self.hidesBottomBarWhenPushed=YES;
                        KuaiDIViewController *kudiVC = [[KuaiDIViewController alloc] init];
                        [self.navigationController pushViewController:kudiVC animated:YES];
                        self.hidesBottomBarWhenPushed=NO;
                        
                    }else if ([self.logoArray[indexTag][@"name"] isEqualToString:@"美食上门"]) {
                        self.hidesBottomBarWhenPushed=YES;
                        DeliciousFoodViewController *deliciousVC = [[DeliciousFoodViewController alloc] init];
                        [self.navigationController pushViewController:deliciousVC animated:YES];
                        self.hidesBottomBarWhenPushed=NO;
                        
                    }else if ([self.logoArray[indexTag][@"name"] isEqualToString:@"停车服务"] || [self.logoArray[indexTag][@"name"] isEqualToString:@"出行服务"])
                    {
                        self.hidesBottomBarWhenPushed=YES;
                        ParkingServiceViewController *parkServiceVC = [[ParkingServiceViewController alloc] init];
                        parkServiceVC.titleStr = titleStr;
                        [self.navigationController pushViewController:parkServiceVC animated:YES];
                        self.hidesBottomBarWhenPushed=NO;
                    }
                    else if ([self.logoArray[indexTag][@"name"] isEqualToString:@"综合服务"]) {
                        self.hidesBottomBarWhenPushed=YES;
                        IntegratedServicesViewController *integratedVC = [[IntegratedServicesViewController alloc] init];
                        [self.navigationController pushViewController:integratedVC animated:YES];
                        self.hidesBottomBarWhenPushed=NO;
                        
                    }else if ([self.logoArray[indexTag][@"name"] isEqualToString:@"美食预定"]){
                        self.hidesBottomBarWhenPushed=YES;
                        DeliciousFoodReserveController *deliciousVC = [[DeliciousFoodReserveController alloc] init];
                        [self.navigationController pushViewController:deliciousVC animated:YES];
                        self.hidesBottomBarWhenPushed=NO;
                    }else{
                        self.hidesBottomBarWhenPushed=YES;
                        AeroplaneViewController *  air = [[AeroplaneViewController alloc]init];
                        air.titleStr = self.logoArray[indexTag][@"name"] ;
                        air.serviceCode = self.logoArray[indexTag][@"url"] ;
                        air.shopid = self.logoArray[indexTag][@"i_id"];
                        
                        [self.navigationController pushViewController:air animated:YES];
                         self.hidesBottomBarWhenPushed=NO;
                    
                    }
                }
            }
        }];
        
        cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        static NSString *indentifier = @"HomeCell";
        HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        
        HomeModel *model = self.wailianArray[indexPath.row];
        [cell refreshCellWithModel:model];
        
        cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.000001f;

    }else{
        return [SizeUtility textFontSize:default_HomeCell_height_size] ;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return SCREENWIDTH/2 + 40*SCREENWIDTH/375;
    }else{
        return 14;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *indentifier = @"HomeLogoCell";
        HomeLogoCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[HomeLogoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        
        return [cell cellHeight:self.logoArray] ;

    }else{
        return [SizeUtility textFontSize:default_HomeCell_height_size] + 14;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        HomeModel *model = self.wailianArray[indexPath.row];

        self.hidesBottomBarWhenPushed=YES;
        TheChainViewController *webVC = [[TheChainViewController alloc] init];
        webVC.titleStr = model.O_title;
        webVC.Shop_url = model.O_url;
        [self.navigationController pushViewController:webVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    if (section == 0) {
        
        bgView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2+40*SCREENWIDTH/375+1);
        
        if (_dataArray.count <=0)
        {
        }else
        {
//            if (!scrollerVC) {
                scrollerVC = [[ScrollerTimerViewController alloc] init];
                scrollerVC.delegate = self;
//           }
            
            NSMutableArray *paths = [NSMutableArray array];
            
            for (NSInteger i=0; i<_dataArray.count; i++) {
                [paths addObject:_dataArray[i][@"O_pic"]];
            }
            scrollerVC.pathArray = paths;
            [bgView addSubview:scrollerVC.view];
            UIImageView * noticeimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH/2, 43*SCREENWIDTH/375, 40*SCREENWIDTH/375)];
            noticeimage.image = [UIImage imageNamed:@"home_icon_notice"] ;
            noticeimage.backgroundColor = [UIColor whiteColor] ;
            [bgView addSubview:noticeimage];
//            if (!_WordScrollView) {
                _WordScrollView = [[GGCMTView alloc]initWithFrame:CGRectMake(VIEW_BX(noticeimage), SCREENWIDTH/2, SCREENWIDTH-43*SCREENWIDTH/375, 40*SCREENWIDTH/375) andCMTViewStyle:CMTViewVerticalStyle];
//            }
            _WordScrollView.backgroundColor = [UIColor whiteColor] ;
            [bgView addSubview:self.WordScrollView];
            UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_BY(_WordScrollView), SCREENWIDTH, 1)];
            lineview.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"] ;
            [bgView addSubview:lineview];
            _WordScrollView.timeInterval = 3.0f;
            _WordScrollView.enableUserScroll = YES;
            _WordScrollView.dataSource = self;
            _WordScrollView.delegate = self;
            [_WordScrollView prepareScroll];
            [_WordScrollView startScroll];
            
        }
        bgView.userInteractionEnabled = YES ;
        return bgView;
    }else{
        
        bgView.frame = CGRectMake(0, 0, SCREENWIDTH, 20);
        bgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        return bgView;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, [SizeUtility textFontSize:default_HomeCell_height_size] )];
    [btn setBackgroundImage:[UIImage imageNamed:@"home_ad_09"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cilckTitleBtn) forControlEvents:UIControlEventTouchUpInside];
    if (section == 0) {
        return nil ;
    }
    return btn ;
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
        self.hidesBottomBarWhenPushed=NO;
    }
}


//点击通知条跳转到通知列表页

- (UITableViewCell *)cmtView:(GGCMTView *)cmtView cellForIndex:(NSInteger)index{
   CustomTableViewCell * cell = [CustomTableViewCell customTableViewCellWithTableView:cmtView];
    cell.titleLab.text = self.noticeArray[index];
    return cell;
}


//点击通知的跳转
-(void)cmtView:(GGCMTView *)cmtView didSelectIndex:(NSInteger)index
{
    if (index == 0) {
//             空气质量开关由后台控制是否显示修改
//        if (self.noticeArray.count>0) {
//            if ([self.Noticeid isEqualToString:@"0"]) {
//                return;
//            }
//        }

        
        AirQualityViewController * airQu = [[AirQualityViewController alloc]init];
        [self.navigationController pushViewController:airQu animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        self.hidesBottomBarWhenPushed = YES;
        NoticeViewController * noticeVC = [[NoticeViewController alloc]init];
        
        [self.navigationController pushViewController:noticeVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}

//返回通知轮播的数量
- (NSInteger)numberOfPageInCmtView:(GGCMTView *)cmtView{

    return self.noticeArray.count ;
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
    self.logoArray = nil;
    self.noticeArray = nil ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTitle" object:nil];
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
