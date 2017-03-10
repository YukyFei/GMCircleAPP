//
//  OpenDoorController.m
//  TradeCenterCircle
//
//  Created by fyb on 2017/3/6.
//  Copyright © 2017年 weiwei-zhang. All rights reserved.
//

#import "OpenDoorController.h"

@interface OpenDoorController ()

@end

@implementation OpenDoorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNaviback:YES];
    [self setNaviBarTitle:@"开门"];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"door"]];
    imageView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-44);
    [self.view addSubview:imageView];
    
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
