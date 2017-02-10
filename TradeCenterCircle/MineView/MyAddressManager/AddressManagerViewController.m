//
//  AddressManagerViewController.m
//  YourMate
//
//  Created by 进击的老鱼 on 15/7/16.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

#import "AddressManagerViewController.h"
//#import "YMRefreshTableView.h"
//#import "AddressManagerTableViewCell.h"
#import "SelectionCellViewController.h"
#import "AddressManagerCell.h"
#import "AddressManager.h"
#import "MJExtension.h"

#import "HouseholdsController.h"
@interface AddressManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,weak)UIView *buttonView;
@property(nonatomic,strong)NSMutableArray *communitiesArray;
@property(nonatomic,copy)NSString *plistPath;
@property(nonatomic,strong) UITableView * tableView ;


@end

@implementation AddressManagerViewController
#pragma mark -lifeStyle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"地址管理"];
    [self setBaseData];
    [self creatUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   self.tabBarController.tabBar.hidden = YES;
    self.buttonView.hidden = NO;
    [self.tableView.header beginRefreshing];

  
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.buttonView.hidden = YES;
    
}
-(void)backClick
{
      self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)headerRefreshings
{
    [self loadData];
}
-(NSMutableArray *)communitiesArray
{
    if (_communitiesArray == nil) {
        _communitiesArray = [[NSMutableArray alloc]init];
    }
    return _communitiesArray;
}

-(void)setBaseData
{
    
    //    self.tableView.scrollEnabled = NO;
    self.navigationController.navigationBar.barTintColor=HexRGB(0xfafafa);
    //导航栏标题
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:HexRGB(0x00b4a2),NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
    
//    self.tableView.rowHeight = 100;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviBarHeight, SCREENWIDTH, SCREENHEIGHT-NaviBarHeight-60) style:UITableViewStylePlain];
    _tableView.delegate = self ;
    _tableView.dataSource = self ;
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshings)];
    [_tableView.header beginRefreshing];
    [self.view addSubview:_tableView];

    self.view.backgroundColor=RGBCOLOR(237,233,229);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)loadData
{
    NSString *user_id = [USER_DEFAULT objectForKey:kUserId];
    NSString *community = [USER_DEFAULT objectForKey:kCommunityId];
    NSDictionary *dictParam = @{@"User_id":user_id,kCommunityId:@""};
    [HttpService postWithServiceCode:kReg_Space_List params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;
        NSDictionary *dictData = [dict objectForKey:@"Data"];
        [self.tableView.header endRefreshing];
        if ([dict validateOk]) {
            
            self.communitiesArray = [dictData objectForKey:@"Spaces"];
            
            //如果没有数据，就显示暂无数据
            if (self.communitiesArray.count > 0) {
                
                [self.tableView reloadData];
            }else{
                [self addLabelAddress];
            }

            NSLog(@"commun %@",self.communitiesArray);
        }else{
            if ([[dict objectForKey:@"Message"] isEqualToString:@"user not select address"]) {
                            [self addLabelAddress];

            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"加载失败，请刷新重试"] ;
        [self addLabelAddress];
    }];
}

/**
 *  删除地址
 */

-(void)addLabelAddress
{
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"您还没有添加地址~";
    [tipLabel setTextColor:[UIColor colorWithHexString:@"#a6873b"]];
    [tipLabel setFont:[UIFont systemFontOfSize:18]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    CGFloat tipH = 50;
    CGFloat tipY = (VIEW_H(self.view)-tipH-64-49)/2;
    tipLabel.frame = CGRectMake(Origin_x, tipY, VIEW_W(self.view), tipH);
    [self.view addSubview:tipLabel];

}
-(void)creatUI
{
    UIView *buttonView = [[UIView alloc]init];
    buttonView.backgroundColor = RGBCOLOR(226, 226, 226);
    CGFloat marginX = 20;
    CGFloat marginY = 10;
    CGFloat buttonVH = 60;
    CGFloat buttonVY = VIEW_H(self.view) - buttonVH ;
    CGFloat addBtnW = VIEW_W(self.view) - 2*marginX;
    CGFloat addBtnH = buttonVH - 2*marginY;
    buttonView.frame = CGRectMake(Origin_x, buttonVY, VIEW_W(self.view), buttonVH);
    
    [self.navigationController.view addSubview:buttonView];
    self.buttonView = buttonView;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateHighlighted];
    addButton.backgroundColor = [UIColor colorWithHexString:@"#a6873b"];
    addButton.frame = CGRectMake(marginX, marginY, addBtnW, addBtnH);
    [addButton addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:addButton];
    
}

-(void)clickAddBtn
{
//     self.hidesBottomBarWhenPushed=YES;
    SelectionCellViewController *selectionCell = [[SelectionCellViewController alloc]init];
    [self.navigationController pushViewController:selectionCell animated:YES];
//      self.hidesBottomBarWhenPushed=NO;
    NSLog(@"点击了添加地址按钮");
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.communitiesArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressManager *addressM = [AddressManager mj_objectWithKeyValues:self.communitiesArray[indexPath.row]];
    
    AddressManagerCell *cell = [AddressManagerCell cellWithTableView:tableView];
    if (!cell) {
        cell = [[[NSBundle  mainBundle] loadNibNamed:@"AddressManagerCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressCell.text = addressM.Space_name;
    cell.addressCell.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    if (SCREENWIDTH>375) {
        cell.addressCell.font = [UIFont systemFontOfSize:([SizeUtility textFontSize:default_Sub_Express_title_size]-1)] ;

    }
    
    //(1,验证通过 2，验证拒绝，3验证中,4;未提交资料)'
    if ([addressM.Address_valid_status isEqualToString:@"1"]) {
        
        [cell.houseBtn setTitle:@"住户" forState:UIControlStateNormal];
        [cell.houseBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        cell.houseBtn.enabled = NO;
        
    }else if ([addressM.Address_valid_status isEqualToString:@"3"]){
        cell.houseBtn.enabled = YES;
        [cell.houseBtn setTitle:@"审核中" forState:UIControlStateNormal];
        [cell.houseBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        cell.houseBtnClick = ^(UIButton *btn){
            [MBProgressHUD showError:@"正在审核您提交的资料，请耐心等待。"];
        };
  
    }else{
        cell.houseBtn.enabled = YES;
        [cell.houseBtn setTitle:@"登记住户" forState:UIControlStateNormal];
        [cell.houseBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        cell.houseBtnClick = ^(UIButton *btn){
            NSInteger row = indexPath.row;
            [self labelTapHouses:row];
        };
    }
   
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.addressCell.text];
    NSInteger a = [[str string] rangeOfString:@"【"].location;
    NSInteger b = [[str string] rangeOfString:@"】"].location;
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0, 165, 145) range:NSMakeRange(a+1,b-a-1)];
    cell.addressCell.attributedText = str;
    
    
    if(indexPath .row == 0){
        
        cell.bgView.hidden = YES;
        cell.downBgView.hidden = YES;
        [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"icon_xuanzhong_green"] forState:UIControlStateNormal];
        UIImageView *iamgeView = [[UIImageView alloc]init];
        iamgeView.frame = CGRectMake(Origin_x, Origin_y, VIEW_W(self.view), 100);
        iamgeView.image = [UIImage imageNamed:@"dizhi_bg"];
        cell.backgroundView = iamgeView;
       
        if ([addressM.Is_default_space isEqualToString:@"1"] ) {
            cell.deleteBtn.hidden = YES ;
//            NSLog(@"%@     %@",addressM.Community_name,addressM.Is_default_space) ;
        }
    }else{
        
        cell.bgView.hidden = NO;
        cell.downBgView.hidden = NO;
        cell.deleteBtn.hidden = NO ;
        [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"icon_weixuanzhong_gray"] forState:UIControlStateNormal];
        cell.backgroundView = nil;
    }
    cell.btnClick = ^(UIButton *btn){

        if (![addressM.Is_default_space isEqualToString:@"1"]) {
            NSString *space_id = addressM.Space_id;
            NSString *space_name = addressM.Space_name;
            NSString *community_id = addressM.Community_id;
            NSString *community_name = addressM.Community_name;
            NSString *Address_valid_status = addressM.Address_valid_status;
            NSString *Community_status = addressM.Community_status;
            NSString *Community_valid_status = addressM.Community_valid_status;
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_xuanzhong_green"] forState:UIControlStateNormal];
            [self setDefAddressWithSpaceId:space_id SpaceName:space_name CommunityId:community_id Community_name:community_name Address_valid_status:Address_valid_status Community_status:Community_status Community_valid_status:Community_valid_status];
            [USER_DEFAULT setObject:addressM.Community_id forKey:kCommunityId];
        }
       
    };
    cell.deleteBtnClick = ^(UIButton *btn){
         NSString *space_id = addressM.Space_id;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确认删除该地址" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
             [self deleteAddressWithSpaceId:space_id] ;
        }]];
        
      [self presentViewController:alertController animated:YES completion:^{
          
      }];
        
    } ;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100 ;
    
}
-(void)labelTapHouses:(NSInteger)row
{
    self.hidesBottomBarWhenPushed=YES;
    AddressManager *addressM = [AddressManager mj_objectWithKeyValues:self.communitiesArray[row]];
    HouseholdsController *houseVC = [[HouseholdsController alloc]init];
    houseVC.community_id = addressM.Community_id;
    
    houseVC.space_id = addressM.Space_id;
    houseVC.isGoBtn = NO;
    [self.navigationController pushViewController:houseVC animated:YES];
   self.hidesBottomBarWhenPushed=NO;

}

-(void)setDefAddressWithSpaceId:(NSString *)space_id SpaceName:(NSString *)space_name CommunityId:(NSString *)community_id Community_name:(NSString *)community_name Address_valid_status:(NSString *)Address_valid_status Community_status:(NSString *)Community_status Community_valid_status:(NSString *)Community_valid_status
{
    NSString *user_id = [USER_DEFAULT objectForKey:kUserId];
    NSDictionary *dictParam = [[NSDictionary alloc]init];
    dictParam = @{@"User_id":user_id,kSpace_id:space_id};
    [HttpService postWithServiceCode:kDEFAULT_ADDRESS_SET params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;
        
        if ([dict validateOk]) {
            [self headerRefreshings];
            
            //设置默认地址成功后，存储默认地址相关信息
            [USER_DEFAULT setObject:space_id forKey:kSpace_id];
            [USER_DEFAULT setObject:space_name forKey:kSpace_name];
            [USER_DEFAULT setObject:community_id forKey:kCommunityId];
            [USER_DEFAULT setObject:community_name forKey:kCommunity_name];
            
            [USER_DEFAULT setObject:Address_valid_status forKey:kAddress_valid_status];
            [USER_DEFAULT setObject:Community_status forKey:kCommunity_status];
            [USER_DEFAULT setObject:Community_valid_status forKey:kCommunity_valid_status];

            
            [USER_DEFAULT synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showSuccess:@"设置默认地址成功"];
                
            });
            
        }else{
            
            NSString *mes = [dict objectForKey:@"Message"];
            [MBProgressHUD showError:mes];
        }
        
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


/**
 * 删除地址的方法
 */
//问题1 如果删除的是默认地址

-(void)deleteAddressWithSpaceId:(NSString *)space_id
{
    NSString *user_id = [USER_DEFAULT objectForKey:kUserId];
    NSDictionary *dictParam = [[NSDictionary alloc]init];
    dictParam = @{@"User_id":user_id,kSpace_id:space_id};
    [HttpService postWithServiceCode:kUSER_DEL_ADDRESS params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;
        
        if ([dict validateOk]) {
            
            [self headerRefreshings];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showSuccess:@"删除地址成功"];
                
            });
            
        }else{
            
            NSString *mes = [dict objectForKey:@"Message"];
            [MBProgressHUD showError:mes];
        }
        
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error) ;
        
    }];
}


@end
