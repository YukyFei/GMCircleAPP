//
//  ParkInfoPICController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "ParkInfoPICController.h"

@interface ParkInfoPICController ()
@property(nonatomic,strong) UIScrollView * mScrollview ;
@property(nonatomic,strong) UIImageView * imageView ;
@end

@implementation ParkInfoPICController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [ProgressHUD showUIBlockingIndicator] ;
    [self loadMessage] ;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"传进来的停车场路线图"] ;
    [self createUI] ;
}
-(void)loadMessage
{
    [ProgressHUD hideUIBlockingIndicator] ;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
  [HttpService postWithServiceCode:@"" params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
      NSDictionary * resultDic = (NSDictionary *)jsonObj ;
      if ([resultDic validateOk]) {
          [ProgressHUD hideUIBlockingIndicator] ;
      }
      
   } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
       [ProgressHUD hideUIBlockingIndicator] ;
        [SVMessageHUD showInView:self.view status:@"服务器响应异常" afterDelay:1.5f] ;
  }];


}
-(void)createUI
{
    _mScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StatusBar_Height+TABBAR_HEIGHT, SCREENWIDTH, SCREENHEIGHT) ];
    [self.view addSubview:_mScrollview];
   _mScrollview.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT+60);

   //弹性效果 默认是YES
    _mScrollview.bounces = YES;
   _mScrollview.showsVerticalScrollIndicator = YES;
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10*SCREENWIDTH/320, 5*SCREENHEIGHT/568, VIEW_W(_mScrollview)-20*SCREENWIDTH/320, VIEW_H(_mScrollview)-10*SCREENHEIGHT/568)];
    _imageView.backgroundColor = [UIColor orangeColor] ;
    [_mScrollview addSubview:_imageView];
    
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
