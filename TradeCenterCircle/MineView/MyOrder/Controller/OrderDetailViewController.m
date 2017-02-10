//
//  OrderDetailViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/22.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderNumberCell.h"
#import "OrderDetailAddressCell.h"
#import "WepayCell.h"
#import "DeliveryHomeServiceCell.h"
#import "PlatformConcessCell.h"
#import "OrderDetailListCell.h"
#import "OrderDetailListModel.h"
#import "GMQTabBarController.h"
#import "GMQNavigationController.h"
#import "WeiPayUtil.h"

@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView       *tabView;
@property(nonatomic,strong) NSMutableArray    *dataList;
@property(nonatomic,strong) NSDictionary      *dic;
@property(copy,nonatomic)NSString *order_id;


@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"订单详情"];
    
    _dataList = [NSMutableArray array];
    _dic = [NSDictionary dictionary];
    
    [self loadData];
    [self notification] ;
}

/**
 *  接收支付结果的通知
 */
-(void)notification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderSuccess:) name:KNotificationOrderPayNotification object:nil];
}


-(void)orderSuccess:(NSNotification *)noti
{
    NSString * str =[[NSString alloc]init];
    if ([[noti.userInfo objectForKey:@"1"] isEqualToString:@"支付成功"]) {
        str = @" 支付成功" ;
    }else{
        str = @" 支付未成功" ;
    }
    
    UIAlertController * alertV = [UIAlertController alertControllerWithTitle:str message:@"" preferredStyle:UIAlertControllerStyleAlert] ;
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }] ;
    [alertV addAction:action];
    [self presentViewController:alertV animated:YES completion:^{
        
    }];

}

//重写返回按钮的方法
-(void)backClick
{
    if ([self.signStr isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.signStr isEqualToString:@"2"]){
        GMQTabBarController *mainView = [[GMQTabBarController alloc] init];
        [self.navigationController pushViewController:mainView animated:YES];
    }else if ([self.signStr isEqualToString:@"3"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationSwitchHome object:nil  userInfo:nil];

    }
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
    }
}

-(void)headerRefreshings
{
    [self loadData];
}

-(void)loadData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.orderId forKey:@"Order_id"];
    
    [HttpService postWithServiceCode:kOrderDetail params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        self.dic = dicresult[@"Data"];
        
        [self.dataList removeAllObjects];
        
        if ([dicresult validateOk]) {
            
            NSDictionary *dataList = [dicresult objectForKey:@"Data"];
            NSArray *array = dataList[@"detail_list"];
            
            for (NSDictionary * dict in array) {
                OrderDetailListModel * model = [OrderDetailListModel modelWithDic:dict] ;
                [self.dataList addObject:model];
            }
            
            [self.tabView.legendHeader endRefreshing];
            [self.tabView reloadData];
            
            [self initSubTableViews];
            
        }else{
            [self.tabView.legendHeader endRefreshing];
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tabView.legendHeader endRefreshing];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4) {
        return self.dataList.count;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.000001f;
    }else if (section == 4) {
        return 60;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 50;
    }else{
        return 0.000001f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    if (section == 4) {
        
        bgView.frame = CGRectMake(0, 0, SCREENWIDTH, 50);
        
        UILabel *totalAndPayLab = [[UILabel alloc] init];
        
        if (self.dataList.count <=0) {
            
        }else{
            for (int i=0; i<self.dataList.count; i++) {
                
                OrderDetailListModel *model = self.dataList[i];
                totalAndPayLab.text = [NSString stringWithFormat:@"总价：%@元     实际：%@元",model.total_amount,model.payed];
            }
        }
        
        totalAndPayLab.frame = CGRectMake(SCREENWIDTH - 10 - [self lableTextHeightWithSting:totalAndPayLab.text and:16.0].width, 0, [self lableTextHeightWithSting:totalAndPayLab.text and:16.0].width, 50);
        totalAndPayLab.font = [UIFont systemFontOfSize:16.0];
        totalAndPayLab.textAlignment = NSTextAlignmentRight;
        totalAndPayLab.textColor = [UIColor colorWithHexString:@"#666666"];
        [bgView addSubview:totalAndPayLab];
        
        return bgView;
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    
    if (section == 4) {
        bgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        bgView.frame = CGRectMake(0, 0, SCREENWIDTH, 50);
        
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 50)];
        subView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:subView];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 50)];
        titleLab.text = @"商品清单";
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        titleLab.font = [UIFont systemFontOfSize:16.0];
        [subView addSubview:titleLab];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [subView addSubview:lineView];
        
    }else{
        bgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        bgView.frame = CGRectMake(0, 0, SCREENWIDTH, 10);
    }
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        static NSString *identify = @"OrderNumberCell";
        
        OrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[OrderNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        return [cell cellHeight:self.dic];
        
    }else if (indexPath.section == 1) {
        static NSString *identify = @"OrderDetailAddressCell";
        
        OrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[OrderDetailAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        return [cell cellHeight:self.dic];
        
    }else if(indexPath.section == 2){
        return 50;
    }else if(indexPath.section == 3){
        return 50;
    }else if(indexPath.section == 4){
        
        static NSString *identify = @"OrderDetailListCell";
        
        OrderDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[OrderDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        OrderDetailListModel *model = self.dataList[indexPath.row];
        return [cell cellHeight:model];
    }
    else{
        static NSString *identify = @"PlatformConcessCell";
        
        PlatformConcessCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[PlatformConcessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        return [cell cellHeight:self.dic];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        static NSString *identify = @"OrderNumberCell";
        
        OrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[OrderNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
         OrderDetailListModel *model = self.dataList[indexPath.row];
        __weak __typeof(self)weakSelf = self;
        [cell weiPayBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf) {
                //微信支付
                [self csqPay:self.orderId] ;
            }
        }];
        
        [cell refreshCellWithData:self.dic];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *identify = @"OrderDetailAddressCell";
        
        OrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[OrderDetailAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        [cell refreshCellWithData:self.dic];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString *identify = @"WepayCell";
        
        WepayCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[WepayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 3) {
        static NSString *identify = @"DeliveryHomeServiceCell";
        
        DeliveryHomeServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[DeliveryHomeServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 4) {
        static NSString *identify = @"OrderDetailListCell";
        
        OrderDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[OrderDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        OrderDetailListModel *model = self.dataList[indexPath.row];
        [cell refreshCellWithModel:model];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        static NSString *identify = @"PlatformConcessCell";
        
        PlatformConcessCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[PlatformConcessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        [cell refreshCellWithData:self.dic];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-20, 999);
    CGSize user_newSize;
    user_newSize = [text boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return user_newSize;
}


/**
 * 微信支付的交互方法
 */
-(void)csqPay:(NSString *)orderId 
{
    self.order_id = orderId;
    NSDictionary *dictParam = [[NSDictionary alloc]init];
    dictParam = @{@"order_id":orderId,@"pay_platform":@"app",@"platform":@"ios",APP_ID:ZP_ID};
    [HttpService csqPricePostWithParams:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        
        NSDictionary *dict = (NSDictionary *)jsonObj;
        NSDictionary *dictData = [dict objectForKey:@"Data"];
        NSLog(@"dictData%@",dictData);
        if ([dict validateOk]) {
            //原来的Name是彩社区
            [[WeiPayUtil shareWeipay]weipayWithParams:dictData withNo:orderId andName:@"国贸圈" withSuccess:^(NSDictionary *resp) {
                NSLog(@"=====支付成功");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kSucess_Pay object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    NSLog(@"----------");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSucess_Pay object:nil];
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
