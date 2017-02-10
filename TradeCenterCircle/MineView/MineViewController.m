//
//  MineViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "MyBaoshiViewController.h"
#import "MyShopCartViewController.h"
#import "MyOrderViewController.h"
#import "MyExpressViewController.h"
#import "MyExpressFeeViewController.h"
#import "MyAddressViewController.h"
#import "MyCouponsViewController.h"
#import "MyInformationViewController.h"
#import "AddressManagerViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong) UITableView     *tableView;
@property(nonatomic,strong) NSArray         *titleArrOne;   //存储组一标题
@property(nonatomic,strong) NSArray         *titleArrTwo;   //存储组二标题

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断token是否失效
    [[RefreshManager manager] isRefreshToken];
    
    [self hideNaviback:YES];
    [self setNaviBarTitle:@"我的"];
    
    [self initSubviews];
    
    self.titleArrOne = [NSArray arrayWithObjects:@"我的订单",@"我的报事",@"我的快递",@"我的快递费",@"我的住址管理", @"我的收货地址",nil];
    self.titleArrTwo = [NSArray arrayWithObjects:@"我的优惠券",@"我的购物车",@"我的资料",@"退出登录",nil];
    
}

- (void)initSubviews
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , SCREENWIDTH , SCREENHEIGHT-64-[SizeUtility textFontSize:default_TabBar_height_size]) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(SCREENWIDTH/2, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = aView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -(SCREENWIDTH/2)-1, SCREENWIDTH, SCREENWIDTH/2)];
    imageView.image = [UIImage imageNamed:@"me_title_pic"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 101;
    [self.tableView addSubview:imageView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }else{
        return 4;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"MineCell";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.titleLab.text = [NSString stringWithFormat:@"%@",self.titleArrOne[indexPath.row]];

    }else{
        cell.titleLab.text = [NSString stringWithFormat:@"%@",self.titleArrTwo[indexPath.row]];
    }
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        cell.lineView.frame = CGRectMake(0, 43.5, SCREENWIDTH, 0.5);
    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        cell.lineView.frame = CGRectMake(0, 43.5, SCREENWIDTH, 0.5);
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 57;
    }else{
        return 12;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //我的订单
            self.hidesBottomBarWhenPushed=YES;
            MyOrderViewController *orderVC = [[MyOrderViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            
        }else if (indexPath.row == 1 ){
            //我的报事
            self.hidesBottomBarWhenPushed=YES;
            MyBaoshiViewController * mybaoshi = [[MyBaoshiViewController alloc]init];
            mybaoshi.signStr = @"1" ;
            [self.navigationController pushViewController:mybaoshi animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
        else if (indexPath.row == 2){
            //我的快递
            self.hidesBottomBarWhenPushed=YES;
            MyExpressViewController *myExpressVC = [[MyExpressViewController alloc]init];
            [self.navigationController pushViewController:myExpressVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
        else if (indexPath.row == 3){
            //我的快递费
            self.hidesBottomBarWhenPushed=YES;
            MyExpressFeeViewController *myExpressFeeVC = [[MyExpressFeeViewController alloc]init];
            [self.navigationController pushViewController:myExpressFeeVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }else if (indexPath.row == 4){
            //我的住址管理
            self.hidesBottomBarWhenPushed=YES;
            AddressManagerViewController * address = [[AddressManagerViewController alloc]init];
            [self.navigationController pushViewController:address animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        
        }
        else{
            //我的地址
            self.hidesBottomBarWhenPushed=YES;
            MyAddressViewController *myAddressVC = [[MyAddressViewController alloc]init];
            [self.navigationController pushViewController:myAddressVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
        
        
    }else{
        if (indexPath.row == 0){
            //我的优惠券
            self.hidesBottomBarWhenPushed=YES;
            MyCouponsViewController *myCouponsVC = [[MyCouponsViewController alloc]init];
            [self.navigationController pushViewController:myCouponsVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            
        }else if (indexPath.row == 1) {
            //我的购物车
            MyShopCartViewController *myShopCarVC = [[MyShopCartViewController alloc] init];
            myShopCarVC.differentStr = @"1";
            self.hidesBottomBarWhenPushed=YES;
            if ([USER_DEFAULT objectForKey:kGetIntoVC] == nil) {
                myShopCarVC.signStr = @"1";
            }else{
                myShopCarVC.signStr = @"2";
            }
            [self.navigationController pushViewController:myShopCarVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            
        }else if (indexPath.row == 2){
            //我的资料
            self.hidesBottomBarWhenPushed=YES;
            MyInformationViewController *myInformateVC = [[MyInformationViewController alloc]init];
            [self.navigationController pushViewController:myInformateVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
        else{
            //退出登录
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    if (section == 0) {
        bgView.frame = CGRectMake(0, 0, SCREENWIDTH, 57);
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 45)];
        lab.text = [NSString stringWithFormat:@"   欢迎回来, %@",[USER_DEFAULT objectForKey:kPhoneNum]];
        lab.backgroundColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor colorWithHexString:@"#666666"];
        lab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Minecell_title_size]];
        [bgView addSubview:lab];
        
        UIView *uplineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SCREENWIDTH, 0.5)];
        uplineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [bgView addSubview:uplineView];
        
        UIView *downlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 56.5, SCREENWIDTH, 0.5)];
        downlineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [bgView addSubview:downlineView];
        
        return bgView;
    }else{
        bgView.frame = CGRectMake(0, 0, SCREENWIDTH, 12);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 11.5, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [bgView addSubview:lineView];
        
        return bgView;
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //取消
    }else{
        //确定
        [USER_DEFAULT setBool:NO forKey:kLoginSuccess];
        [USER_DEFAULT removeObjectForKey:kGetIntoVC];
        [USER_DEFAULT synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationSwitchUserLogin object:nil userInfo:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < - (SCREENWIDTH/2)) {
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
    }
}

-(void)dealloc
{
    self.tableView = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
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
