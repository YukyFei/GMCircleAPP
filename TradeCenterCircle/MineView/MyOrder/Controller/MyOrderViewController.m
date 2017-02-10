//
//  MyOrderViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderCell.h"
#import "MyOrderMorePicCell.h"
#import "MyOrderListModel.h"
#import "OrderDetailViewController.h"

@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger index;
    NSString  *ID;
}

@property(nonatomic,strong) UITableView       *tabView;
@property(nonatomic,strong) NSMutableArray    *dataList;
@property(nonatomic,strong) NSDictionary      *data;
@property(nonatomic,copy)   NSString          *pageSize;
@property(nonatomic,copy)   NSString          *refundStr;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"我的订单"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kSucess_Pay object:nil];
    
    _dataList = [NSMutableArray array];
    
    [self loadData];
    
    [self initSubTableViews];
    
    [self showRefundView];
}

-(void)showRefundView
{
    UIView *hiddenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    hiddenView.backgroundColor = [UIColor blackColor];
    hiddenView.tag = 102;
    [self.view addSubview:hiddenView];
    hiddenView.alpha = 0.0;
    
    UIView *refundView = [[UIView alloc] initWithFrame:CGRectMake(10, (SCREENHEIGHT - 245)/2, SCREENWIDTH - 20, 245)];
    refundView.backgroundColor = [UIColor whiteColor];
    refundView.tag = 200;
    refundView.layer.cornerRadius = 5.0;
    [self.view addSubview:refundView];
    refundView.alpha = 0.0;
    
    UILabel *refundPrice = [[UILabel alloc] init];
    refundPrice.text = @"退款金额：";
    refundPrice.font = [UIFont systemFontOfSize:16.0];
    refundPrice.textColor = [UIColor colorWithHexString:@"#666666"];
    refundPrice.frame = CGRectMake(10, 20, [self lableTextHeightWithSting:refundPrice.text and:16].width, 40);
    [refundView addSubview:refundPrice];
    
    UITextField *refundPriceTf=[[UITextField alloc]initWithFrame:CGRectMake(refundPrice.right + 10, 20, SCREENWIDTH-20-10-10-10-[self lableTextHeightWithSting:refundPrice.text and:16].width, 40)];
    refundPriceTf.borderStyle=UITextBorderStyleNone;
    refundPriceTf.layer.borderColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    refundPriceTf.layer.borderWidth= 0.5;
    refundPriceTf.font = [UIFont systemFontOfSize:14.0];
    refundPriceTf.tag = 300;
    refundPriceTf.keyboardType = UIKeyboardTypeDefault;
    [refundView addSubview:refundPriceTf];
    
    UILabel *refundReason = [[UILabel alloc] init];
    refundReason.text = @"退款理由：";
    refundReason.font = [UIFont systemFontOfSize:16.0];
    refundReason.textColor = [UIColor colorWithHexString:@"#666666"];
    refundReason.frame = CGRectMake(10, refundPriceTf.bottom + 10, [self lableTextHeightWithSting:refundPrice.text and:16].width, 40);
    [refundView addSubview:refundReason];
    
    UITextView *refundReasonText = [[UITextView alloc] initWithFrame:CGRectMake(refundReason.right+ 10, refundPriceTf.bottom + 10, SCREENWIDTH-20-10-10-10-[self lableTextHeightWithSting:refundPrice.text and:16].width, 100)];
    refundReasonText.layer.borderColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    refundReasonText.layer.borderWidth= 0.5;
    refundReasonText.tag = 400;
    [refundView addSubview:refundReasonText];
    
    UIButton *querenBtn = [ButtonControl creatButtonWithFrame:CGRectMake(10, 245 - 10 - 44, (SCREENWIDTH - 20 - 20 - 20)/2, 35) Text:@"确认" ImageName:nil bgImageName:nil Target:self Action:@selector(querenClick)];
    querenBtn.backgroundColor = [UIColor colorWithHexString:@"#a6873b"];
    querenBtn.tag = index;
    querenBtn.layer.cornerRadius = 3.0;
    [refundView addSubview:querenBtn];
    
    UIButton *quxiaoBtn = [ButtonControl creatButtonWithFrame:CGRectMake(refundView.width - (SCREENWIDTH - 20 - 20 - 20)/2 - 10, 245 - 10 - 44, (SCREENWIDTH - 20 - 20 - 20)/2, 35) Text:@"取消" ImageName:nil bgImageName:nil Target:self Action:@selector(quxiaoClick)];
    quxiaoBtn.backgroundColor = [UIColor colorWithHexString:@"#a6873b"];
    quxiaoBtn.layer.cornerRadius = 3.0;
    [refundView addSubview:quxiaoBtn];
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
    
    [HttpService postWithServiceCode:kGetOrderList params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            
            NSArray *data = [dicresult objectForKey:@"Data"];
            
            if ([self.pageSize isEqualToString:@"1"]) {
                [self.dataList removeAllObjects];
            }
            
            for (NSDictionary * dict in data) {
                MyOrderListModel * model = [MyOrderListModel modelWithDic:dict] ;
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

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyOrderCell";
    static NSString *identifyMorePic = @"MyOrderMorePicCell";
    
    MyOrderListModel *model = self.dataList[indexPath.row];
    
    if (model.goods.count == 1 && model.goods.count > 0) {
        MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[MyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
    
        return [cell cellHeight] + 10;
    }else{
        MyOrderMorePicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyMorePic];
        if (cell == nil) {
            cell = [[MyOrderMorePicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyMorePic];
        }
        
        return [cell cellHeight] + 10;
        
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderListModel *model = self.dataList[indexPath.row];
    
    if (model.goods.count == 1 && model.goods.count > 0) {
        static NSString *identify = @"MyOrderCell";
        
        MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[MyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        __weak __typeof(self)weakSelf = self;

        [cell OrderStatisBlock:^(NSString *orderPrice){
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (strongSelf) {

                ID = [NSString stringWithFormat:@"%ld",(long)index];
                ID = model.order_id;
                self.refundStr = orderPrice;
                
                UIView *hiddenView = [self.view viewWithTag:102];
                UIView *refundView = [self.view viewWithTag:200];
                [UIView animateWithDuration:0.3 animations:^{
                    hiddenView.alpha = 0.5;
                    refundView.alpha = 1.0;
                }];
            }
        }];
        
        MyOrderListModel *model = self.dataList[indexPath.row];
        [cell refreshCellWithModel:model];
        
        cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        static NSString *identify = @"MyOrderMorePicCell";
        
        MyOrderMorePicCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[MyOrderMorePicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        __weak __typeof(self)weakSelf = self;
        
        [cell OrderStatisBlock:^(NSString *orderPrice){
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (strongSelf) {
                
                ID = [NSString stringWithFormat:@"%ld",(long)index];
                ID = model.order_id;
                self.refundStr = orderPrice;
                
                UIView *hiddenView = [self.view viewWithTag:102];
                UIView *refundView = [self.view viewWithTag:200];
                [UIView animateWithDuration:0.3 animations:^{
                    hiddenView.alpha = 0.5;
                    refundView.alpha = 1.0;
                }];
            }
        }];
        
        MyOrderListModel *model = self.dataList[indexPath.row];
        [cell refreshCellWithModel:model];
        
        cell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderListModel *model = self.dataList[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    OrderDetailViewController *detailView = [[OrderDetailViewController alloc] init];
    detailView.signStr = @"1";
    detailView.orderId = model.order_id;
    [self.navigationController pushViewController:detailView animated:YES];
}

-(void)querenClick
{
    UITextField *textField = [self.view viewWithTag:300];
    UITextView  *textView = [self.view viewWithTag:400];

    if (textField==nil||textField.text.length==0) {
        [SVMessageHUD showInView:self.view status:@"请填写退款金额" afterDelay:1.0];
        return;
    }
    
    if ([textField.text compare:self.refundStr options:NSNumericSearch] == NSOrderedDescending) {
        [SVMessageHUD showInView:self.view status:@"退款金额不对，请重新输入" afterDelay:1.0];
        return;
    }
    
    if (textView==nil||textView.text.length==0) {
        [SVMessageHUD showInView:self.view status:@"请填写退款理由" afterDelay:1.0];
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"];
    [dic setValue:ID forKey:@"order_id"];
    [dic setValue:textField.text forKey:@"tui_money"];
    [dic setValue:textView.text forKey:@"reason"];
    
    [HttpService postWithServiceCode:kTuiFee params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        
        NSDictionary *dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            [MBProgressHUD showSuccess:@"我们已收到您的退款请求！"];
            [self hiddenBoxView];
            
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)quxiaoClick
{
    [self hiddenBoxView];
}

-(void)hiddenBoxView
{
    UIView *hiddenView = [self.view viewWithTag:102];
    UIView *refundView = [self.view viewWithTag:200];
    [UIView animateWithDuration:0.3 animations:^{
        hiddenView.alpha = 0.0;
        refundView.alpha = 0.0;
    }];
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-20, 999);
    CGSize user_newSize;
    user_newSize = [text boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return user_newSize;
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
