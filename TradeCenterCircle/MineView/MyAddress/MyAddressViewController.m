//
//  MyAddressViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyAddressViewController.h"
#import "MyAddressADDController.h"
#import "MyAddresseViewCell.h"
#import "MyAddressModel.h"

@interface MyAddressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView   *tabView;
@property(nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic,assign) NSInteger currentpage ;



@end
//CGFloat font  ;
@implementation MyAddressViewController

-(NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array] ;
    }
    return _dataList ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"我的收货地址"];

    self.currentpage = 1 ;
    [self initSubTableViews];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [_tabView.legendHeader beginRefreshing];
}



-(void)initSubTableViews
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,SCREENWIDTH,SCREENHEIGHT) style:UITableViewStylePlain];
        _tabView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.delegate = self;
        _tabView.dataSource = self;
        [self.view addSubview:_tabView];
        
        //下拉刷新
        [_tabView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
//        [_tabView.legendHeader beginRefreshing];
        [self createHeadView] ;
    }
}

-(void)createHeadView
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_W(self.view), 180*SCREENHEIGHT/667)];
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_W(self.view)/4, 30, VIEW_W(self.view)/2, 35*SCREENHEIGHT/667)];
    addBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor ;
    addBtn.layer.borderWidth = 1 ;
    addBtn.backgroundColor = [UIColor whiteColor] ;
    addBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_ExpressFee_SubTitle_size]+1] ;
    [addBtn setTitle:@"添加新的收货地址" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnCLC) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addBtn.layer.cornerRadius = 2 ;
    [aView addSubview:addBtn];
    self.tabView.tableFooterView = aView;
}

-(void)headerRefreshings
{
    [self loadMessage] ;
}
-(void)loadMessage
{
    [self.tabView.legendHeader endRefreshing];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    [dict setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"] ;
    
    [HttpService postWithServiceCode:GET_ADRESS_LIST params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *resultDic = (NSDictionary *)jsonObj ;
        if ([resultDic validateOk]) {
            if (self.dataList.count >0) {
                [self.dataList removeAllObjects];
            }
            
            for (NSDictionary * dic in jsonObj[@"Data"]) {
                MyAddressModel * model = [MyAddressModel modelWithDic:dic] ;
                [self.dataList addObject:model];
            }
            [self.tabView.legendHeader endRefreshing];
            [self.tabView reloadData];
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


/**
 * 删除地址 设为默认地址
 */
-(void)deleteBtnloadWithCode:(NSString *)code andAddressId:(NSString *)addressId
{
    //    {"User_id":"37F92C4E-64DD-7EC7-DBA6-B8496824864D","Operation":"delete","Address_id":"8E1A9FC8-EA0B-4EAC-9497-5BE4DF3766B5"}
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    [dict setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"] ;
    [dict setValue:code forKey:@"Operation"] ;
    //    [dict setValue:addressId forKey:@"Address_id"] ;
    [dict setValue:addressId forKey:@"Address_id"] ;
    [HttpService postWithServiceCode:ADDRESS_DEFAULT params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        if ([resultDic validateOk]) {
            [self loadMessage] ;
            
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

/**
 * 添加地址的点击事件
 */
-(void)addBtnCLC
{
    self.hidesBottomBarWhenPushed = YES;
    MyAddressADDController *addressAddVC = [[MyAddressADDController alloc] init];
    [self.navigationController pushViewController:addressAddVC animated:YES];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyAddressCell";
    MyAddresseViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID] ;
    
    if (cell == nil) {
        cell = [[MyAddresseViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MyAddressModel *model = self.dataList[indexPath.row];
    cell.addressmodel = model ;
    [cell.editBtn addTarget:self action:@selector(EditButtonCLC:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = indexPath.row ;
    [cell.deleteBtn addTarget:self action:@selector(DeleButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = indexPath.row ;
    [cell.defaultBtn addTarget:self action:@selector(DefauButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.defaultBtn.tag = indexPath.row ;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAddresseViewCell * cell = [[MyAddresseViewCell alloc]init];
    
    return [cell returnCellHei] ;
    
}


/**
 * 按钮的点击事件
 */
-(void)EditButtonCLC:(UIButton *)sender
{
    MyAddressModel * model = self.dataList[sender.tag] ;
    self.hidesBottomBarWhenPushed = YES;
    MyAddressADDController * add = [[MyAddressADDController alloc]init];
    add.addressId = model.ID ;
    [self.navigationController pushViewController:add animated:YES];
}

-(void)DeleButton:(UIButton *)sender
{
    MyAddressModel * model = self.dataList[sender.tag] ;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确认删除该地址" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [self deleteBtnloadWithCode:@"delete" andAddressId:model.ID] ;
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];

    
}

-(void)DefauButton:(UIButton * )sender
{
     MyAddressModel * model = self.dataList[sender.tag] ;
    [self deleteBtnloadWithCode:@"default" andAddressId:model.ID] ;
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
