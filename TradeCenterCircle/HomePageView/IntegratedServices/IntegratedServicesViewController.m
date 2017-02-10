//
//  IntegratedServicesViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "IntegratedServicesViewController.h"
#import "IntegratedServicesCell.h"
#import "ScrollerTimerViewController.h"
#import "FlowerServiceViewController.h"
#import "BaoShiViewController.h"
#import "IdentityViewController.h"
#import "TheChainViewController.h"
#import "IdentityverifyViewController.h"
#import "ChangeAddressController.h"

@interface IntegratedServicesViewController ()<UITableViewDelegate,UITableViewDataSource,ScrollerBannerDelegate>
{
    ScrollerTimerViewController *scrollerVC;
}

@property(nonatomic,strong) UITableView     *tableView;
@property(nonatomic,strong) NSMutableArray  *dataArray; //存储轮播图
@property(nonatomic,strong) NSMutableArray  *logoArray; //存储综合服务图标

@end

@implementation IntegratedServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"综合服务"];
        
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

-(void)headerRefreshings
{
    [self loadData];
}

-(void)loadData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary] ;
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"service" forKey:@"Position"];
    
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

-(void)loadLogoData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"service" forKey:@"Shop_type"];
    
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"DeliciousFoodCell";
    IntegratedServicesCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[IntegratedServicesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    if (self.logoArray.count<=0) {
        
    }else{
        cell.title.text = @"   综合服务";
        [cell refreshCellWithModel:self.logoArray];
    }
    
    __weak __typeof(self)weakSelf = self;
    
    [cell logoTapVCBlock:^(NSInteger indexTag,NSString *titleStr,NSString *shopID,NSString *Shop_out,NSString *Shop_url) {
        __weak __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf) {
            if ([Shop_out isEqualToString:@"ok"]) {
                
                //1 是外链
                self.hidesBottomBarWhenPushed = YES;
                TheChainViewController * thchain = [[TheChainViewController alloc]init];
                thchain.Shop_url = Shop_url ;
                thchain.titleStr = titleStr ;
                [self.navigationController pushViewController:thchain animated:YES];

            }else{
                //报事界面跳转
                if ([titleStr isEqualToString:@"报事"]) {
                    //判断权限
                    
                    [self checkIdentity] ;
                    
                }else{
                    self.hidesBottomBarWhenPushed = YES;
                    FlowerServiceViewController * flower = [[FlowerServiceViewController alloc]init];
                    flower.titleStr = titleStr ;
                    flower.Shop_id = shopID ;
                    [self.navigationController pushViewController:flower animated:YES];
                }
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
    IntegratedServicesCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[IntegratedServicesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    return [cell cellHeight:self.logoArray] + 70;
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

//中间按钮的点击事件
-(void)checkIdentity
{
    //    "IdentityViewController.h"
    // "IdentityverifyViewController.h"
    //判断是否有spaceID 没有的话跳转到切换小区页面
    NSString * spaceID = [USER_DEFAULT objectForKey:kSpace_id] ;
    
    if (spaceID ==nil ||[spaceID isEqualToString:@""]) {
          self.hidesBottomBarWhenPushed=YES;
        ChangeAddressController * change = [[ChangeAddressController alloc]init];
        //  IdentityViewController * dengji = [[IdentityViewController alloc]init];
        //当前小区没有spaceid 跳转到切换小区页面
        [self.navigationController pushViewController:change animated:YES] ;
    }else{
        NSString *Address_valid_status = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:kAddress_valid_status]];
        NSString *community_status = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:kCommunity_status]];
        //审核中
        if ([Address_valid_status isEqualToString:@"3"]) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"您提交的资料正在审核中，暂不能使用该功能，请您耐心等待。";
            hud.detailsLabelFont = [UIFont systemFontOfSize:15];
            hud.margin = 10.f;
            hud.yOffset = ([UIScreen mainScreen].bounds.size.height-StatusBar_Height-NavigationBar_HEIGHT-TABBAR_HEIGHT)/2-50;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            return;
        }else if ([Address_valid_status isEqualToString:@"1"]){
            //验证通过
            if ([community_status isEqualToString:@"1"]) {
                self.hidesBottomBarWhenPushed = YES;
                BaoShiViewController * BS = [[BaoShiViewController alloc]init];
                BS.titleName = @"物业报事" ;
                BS.url = [NSString stringWithFormat:@"%@/community_id/%@",BSURL,[USER_DEFAULT objectForKey:kCommunityId]] ;
                [self.navigationController pushViewController:BS animated:YES];
            }else{
                //提示不是合作的小区
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabelText = @"很抱歉，该项目尚未合作";
                hud.detailsLabelFont = [UIFont systemFontOfSize:15];
                hud.margin = 10.f;
                hud.yOffset = ([UIScreen mainScreen].bounds.size.height-StatusBar_Height-NavigationBar_HEIGHT-TABBAR_HEIGHT)/2-50;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];

            }
        }else{
            IdentityverifyViewController * yanzheng = [[IdentityverifyViewController alloc]init];
            //提示去审核身份信息
            [self.navigationController pushViewController:yanzheng animated:YES];
        }
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
