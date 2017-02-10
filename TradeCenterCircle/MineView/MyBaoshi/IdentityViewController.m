//
//  IdentityViewController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/11/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "IdentityViewController.h"
#import "BaoShiViewController.h"
#import "HouseholdViewController.h"

@interface IdentityViewController ()
@property(nonatomic,assign)CGFloat marginX;
@property(nonatomic,assign)CGFloat marginY;
@end

@implementation IdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"提示"] ;
    [self creatUI];
}

-(void)creatUI
{
    
    self.marginX = 40 * SCREENWIDTH/320 ;
    self.marginY = 80*SCREENHEIGHT/480 ;
    //背景图
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.frame = CGRectMake(Origin_x, Origin_y, VIEW_W(self.view), [UIScreen mainScreen].bounds.size.height);
    bgImageView.image = [UIImage imageNamed:@"bg_fail"];
    [self.view addSubview:bgImageView];
    
    CGFloat marginX = self.marginX;
    CGFloat marginY = self.marginY;
    CGFloat imageW = [UIScreen mainScreen].bounds.size.width-2*marginX;
    CGFloat imageH = [UIScreen mainScreen].bounds.size.height-2*marginY;
    
    UIImageView *IdimageView = [[UIImageView alloc]init];
    IdimageView.userInteractionEnabled = YES;
    IdimageView.frame = CGRectMake(marginX, marginY, [UIScreen mainScreen].bounds.size.width-2*marginX, [UIScreen mainScreen].bounds.size.height-2*marginY);
    IdimageView.image = [UIImage imageNamed:@"dengjiyanzheng_bg"];
    [bgImageView addSubview:IdimageView];
    
    UILabel *mesLabel = [[UILabel alloc]init];
    mesLabel.text = @"您还没有登记地址，还不能使用该功能,请先登记";
    mesLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    mesLabel.textColor = [UIColor blackColor];
    mesLabel.numberOfLines = 0;
    CGSize textSize = [self sizeWithText:mesLabel.text WithFont:mesLabel.font WithMaxSize:CGSizeMake(imageW-2*marginX, MAXFLOAT)];
    mesLabel.frame = CGRectMake(marginX, imageH/2-textSize.height/2, textSize.width, textSize.height);
    [IdimageView addSubview:mesLabel];
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    CGSize btnSize = CGSizeMake(2*marginX, marginX);
    backBtn.frame = CGRectMake(marginX/2, imageH-btnSize.height-marginX/2, btnSize.width, btnSize.height);
    [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [IdimageView addSubview:backBtn];
    
    UIButton *goBtn = [[UIButton alloc]init];
    [goBtn setBackgroundImage:[UIImage imageNamed:@"btn_dengji"] forState:UIControlStateNormal];
    goBtn.frame = CGRectMake(imageW-marginX/2-btnSize.width, imageH-btnSize.height-marginX/2, btnSize.width, btnSize.height);
    [goBtn addTarget:self action:@selector(clickgoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [IdimageView addSubview:goBtn];
    
}
-(void)clickBackBtn:(UIButton *)btn
{
    [self popVC];
}


//点击登记的跳转按钮点击事件
-(void)clickgoBtn:(UIButton *)btn
{
    HouseholdViewController *Household = [[HouseholdViewController alloc]init];
    Household.titleName = @"物业报事" ;
    [self.navigationController pushViewController:Household animated:YES];
    
}


-(CGSize)sizeWithText:(NSString *)text WithFont:(UIFont *)font WithMaxSize:(CGSize )maxSize
{
    NSDictionary *attri = @{NSFontAttributeName :font};
    return  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
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