//
//  LogisticSuccessController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/18.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "LogisticSuccessController.h"

@interface LogisticSuccessController ()

@end

@implementation LogisticSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"提交成功"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"] ;
    [self createUI] ;
}

-(void)createUI
{
    CGFloat fonSize ;
    if (SCREENWIDTH==320) {
        fonSize = 17.0f ;
    }else{
        fonSize = 18.0f ;
    }
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBar_Height+TABBAR_HEIGHT, VIEW_W(self.view), VIEW_H(self.view))];
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60*SCREENHEIGHT/667, 100*SCREENWIDTH/375 ,100*SCREENWIDTH/375)];
    image.image = [UIImage imageNamed:@"shopping_icon_success"] ;
    image.center = CGPointMake(VIEW_W(view)/2, 110*SCREENHEIGHT/667) ;
    [view addSubview:image];
    [self.view addSubview:view];
    UILabel * label = [UILabel labelWithFrame:CGRectMake(0, VIEW_BY(image)+32*SCREENHEIGHT/667, VIEW_W(self.view), 20*SCREENHEIGHT/667) withText:@"下单成功" withFont:
                       [UIFont systemFontOfSize:fonSize] withTextColor:[UIColor colorWithHexString:@"#666666"] withBackgroundColor:nil] ;
    label.textAlignment = NSTextAlignmentCenter ;
    [view addSubview:label];
    
    UILabel * waitLab =[UILabel labelWithFrame:CGRectMake(0, VIEW_BY(label)+24*SCREENHEIGHT/667, VIEW_W(self.view), 20*SCREENHEIGHT/667) withText:@"请等待你快递小哥与您联系" withFont:
                        [UIFont systemFontOfSize:fonSize] withTextColor:[UIColor colorWithHexString:@"#999999"] withBackgroundColor:nil] ;
    waitLab.textAlignment = NSTextAlignmentCenter ;
    
    [view addSubview:waitLab] ;
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(30*SCREENWIDTH/375, VIEW_BY(waitLab)+64*SCREENHEIGHT/667, SCREENWIDTH-2*SCREENWIDTH*30/375, 50*SCREENHEIGHT/667)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter ;
    [button setTitle:@"回国贸圈|CHINAWORLD" forState:UIControlStateNormal];
    button.layer.borderWidth = 1.0f ;
    button.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor ;
    button.layer.cornerRadius = 2.0f ;
    [button addTarget:self action:@selector(BUTTONCLC) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor] ;
    button.titleLabel.font = [UIFont systemFontOfSize:fonSize] ;
    [view addSubview:button];
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(0, VIEW_BY(button)+42*SCREENHEIGHT/667, VIEW_W(self.view), 20*SCREENHEIGHT/667)  andTag:@"" andTitle:@"关闭窗口"] ;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:fonSize-2] ;
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter ;
    [view addSubview:cancelBtn] ;
    [self.view addSubview:view];
    [cancelBtn addTarget:self action:@selector(CancelBtnCLC) forControlEvents:UIControlEventTouchUpInside] ;
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
}
-(void)BUTTONCLC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)CancelBtnCLC
{
    [self popVC];
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
