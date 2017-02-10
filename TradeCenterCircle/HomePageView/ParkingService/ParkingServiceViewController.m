//
//  ParkingServiceViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "ParkingServiceViewController.h"
#import "FlowerServiceViewController.h"
#import "ParkInformationController.h"
#import "TheChainViewController.h"
#import "AeroplaneViewController.h"
@interface ParkingServiceViewController ()
{
    int index;
}

@property(nonatomic,strong)UIView        *bgView;     //背景图片
@property(nonatomic,strong)UIButton      *titleBtn;   //首页logo按钮
@property(nonatomic,strong)UILabel       *titleLab;   //首页logo标题
@property(nonatomic,strong)UIView        *wlineView;  //横向分割线
@property(nonatomic,strong)UIView        *hlineView;  //竖向分割线

@property(nonatomic,strong)NSMutableArray  *logoArr;  //存储停车服务logo图标

@end

@implementation ParkingServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:self.titleStr];
    self.logoArr = [NSMutableArray array];
    
    if ([self.titleStr isEqualToString:@"停车服务"]) {
        [self loadLogoData];
    }else {
        [self loadChuxingData];
    }
}

-(void)loadChuxingData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"travel" forKey:@"Shop_type"];
    [dic setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"];

    
    [HttpService postWithServiceCode:kGetShopList params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;

        if ([dicresult validateOk]) {
            self.logoArr = dicresult[@"Data"];
            
            [self initUI];
            
            [SVProgressHUD dismiss];
            
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)loadLogoData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"car" forKey:@"Shop_type"];
    [SVProgressHUD showInView:self.view status:@"加载中..."];
    
    [HttpService postWithServiceCode:kGetShopList params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            self.logoArr = dicresult[@"Data"];
            
            [self initUI];
            
            [SVProgressHUD dismiss];
            
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)initUI
{
    UILabel *titleLab = [[UILabel alloc] init];
    if ([self.titleStr isEqualToString:@"停车服务"]){
        titleLab.text = @"   停车服务";
    }else{
        titleLab.text = @"   出行服务";
    }
    
    titleLab.frame = CGRectMake(0, 20+64, SCREENWIDTH, 45);
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:16.0];
    titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.view addSubview:titleLab];
    
    if ((float)self.logoArr.count/3<=1 && (float)self.logoArr.count>0) {
        index=2;
    }else if ((float)self.logoArr.count/3<=2 && (float)self.logoArr.count>1) {
        index=3;
    }else{
        index = 4;
    }
    
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + 45+64, SCREENWIDTH, 105*(index-1))];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgView];
    }
    
    for (int i = 0; i < index; i++) {
        _wlineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*105, SCREENWIDTH, 0.5)];
        _wlineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
        [_bgView addSubview:_wlineView];
    }
    
    for (int i = 0; i < 2; i++) {
        _hlineView = [[UIView alloc] initWithFrame:CGRectMake(((SCREENWIDTH)/3)*i + ((SCREENWIDTH)/3), 0, 0.5, 105*(index-1))];
        _hlineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
        [_bgView addSubview:_hlineView];
    }
    
    float width=50;
    float widthLab=100;
    
    for (int i=0; i<self.logoArr.count; i++) {
        
        if ([self.titleStr isEqualToString:@"停车服务"]) {
            _titleBtn = [ButtonControl creatButtonWithFrame:CGRectMake((SCREENWIDTH/3-width)/2+(SCREENWIDTH/3)*(i%3)+(i/self.logoArr.count)*SCREENWIDTH, (16+(210 + width -width*3-5)*(i/3%3)), width, width) Text:nil ImageName:nil bgImageName:nil Target:self Action:@selector(btnClick:)];
            [_titleBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,self.logoArr[i][@"S_logo"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"moren"]];
        }else {
            _titleBtn = [ButtonControl creatButtonWithFrame:CGRectMake((SCREENWIDTH/3-width)/2+(SCREENWIDTH/3)*(i%3)+(i/self.logoArr.count)*SCREENWIDTH, (16+(210 + width -width*3-5)*(i/3%3)), width, width) Text:nil ImageName:nil bgImageName:nil Target:self Action:@selector(btnClick:)];
            [_titleBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,self.logoArr[i][@"S_logo"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"moren"]];
        }
        
        _titleBtn.adjustsImageWhenHighlighted = NO;
        _titleBtn.tag = i;
        [_bgView addSubview:_titleBtn];
        
        if ([self.titleStr isEqualToString:@"停车服务"]){
            _titleLab = [ButtonControl creatLableWithFrame:CGRectMake((SCREENWIDTH/3-widthLab)/2+(SCREENWIDTH/3)*(i%3)+(i/self.logoArr.count)*SCREENWIDTH, (20 + width +(210 + width -width*3-5)*(i/3%3)), widthLab, 30) Text:self.logoArr[i][@"Shop_name"] font:[SizeUtility textFontSize:default_Logo_title_size] TextColor:[UIColor colorWithHexString:@"#5f3f2a"]];
        }else{
            _titleLab = [ButtonControl creatLableWithFrame:CGRectMake((SCREENWIDTH/3-widthLab)/2+(SCREENWIDTH/3)*(i%3)+(i/self.logoArr.count)*SCREENWIDTH, (20 + width +(210 + width -width*3-5)*(i/3%3)), widthLab, 30) Text:self.logoArr[i][@"Shop_name"] font:[SizeUtility textFontSize:default_Logo_title_size] TextColor:[UIColor colorWithHexString:@"#5f3f2a"]];
        }
        
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_titleLab];
    }
}

-(void)btnClick:(UIButton *)sender
{
    if ([self.logoArr[sender.tag][@"Shop_out"] isEqualToString:@"ok"]) {
        //外链
        self.hidesBottomBarWhenPushed=YES;
        TheChainViewController *webVC = [[TheChainViewController alloc] init];
        webVC.titleStr = self.logoArr[sender.tag][@"Shop_name"];
        webVC.Shop_url = self.logoArr[sender.tag][@"Shop_url"];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else{
        NSLog(@"%d"            @"%@",sender.tag,self.logoArr[sender.tag][@"Shop_name"] );
        if ([self.logoArr[sender.tag][@"Shop_name"] isEqualToString:@"洗车服务"]) {
            self.hidesBottomBarWhenPushed=YES;
            FlowerServiceViewController * flower = [[FlowerServiceViewController alloc]init];
            flower.titleStr = @"洗车服务" ;
            flower.Shop_id = self.logoArr[sender.tag][@"Shop_id"] ;
            [self.navigationController pushViewController:flower animated:YES];
            
        }
        else if([self.logoArr[sender.tag][@"Shop_name"] isEqualToString:@"停车信息"]){
            self.hidesBottomBarWhenPushed=YES;
            ParkInformationController * park = [[ParkInformationController alloc]init];
            park.shopID = self.logoArr[sender.tag][@"Shop_id"] ;
            [self.navigationController pushViewController:park animated:YES];

        }
        else if ([self.logoArr[sender.tag][@"Shop_name"] isEqualToString:@"机场服务"]){
            self.hidesBottomBarWhenPushed=YES;
              AeroplaneViewController *  air = [[AeroplaneViewController alloc]init];
            air.titleStr = @"机场服务" ;
            air.serviceCode = self.logoArr[sender.tag][@"Shop_url"] ;
            air.shopid = self.logoArr[sender.tag][@"Shop_id"] ;
          
            [self.navigationController pushViewController:air animated:YES];
            
        }
        else if ([self.logoArr[sender.tag][@"Shop_name"] isEqualToString:@"大V出行"]){
            self.hidesBottomBarWhenPushed=YES;
            AeroplaneViewController *  air = [[AeroplaneViewController alloc]init];
            air.titleStr = @"大V出行" ;
            air.serviceCode = self.logoArr[sender.tag][@"Shop_url"] ;
            air.shopid = self.logoArr[sender.tag][@"Shop_id"] ;
            [self.navigationController pushViewController:air animated:YES];
        }else{
            //其他
        }
    }
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
