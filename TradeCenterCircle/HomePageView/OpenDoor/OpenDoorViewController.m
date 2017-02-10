//
//  OpenDoorViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/9/5.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "OpenDoorViewController.h"

@interface OpenDoorViewController ()

@property(nonatomic,strong) UIImageView * door ;

@end

@implementation OpenDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNaviback:YES];
    [self setNaviBarTitle:@"开门"];
    [self openDoorShow] ;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    [_door stopAnimating] ;
    [_door performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:_door.animationDuration] ;
    
}

/**
 *  开门动画
 */

-(void)openDoorShow
{
    _door = [[UIImageView alloc]initWithFrame:CGRectMake(0, StatusBar_Height, SCREENWIDTH, SCREENHEIGHT-TABBAR_HEIGHT)];
    NSMutableArray * arr = [NSMutableArray array] ;
    
    for (int i = 1; i<=6; i++) {
        UIImage * imag = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [arr addObject: imag];
    }
    [_door setAnimationImages:arr] ;
    //    [door setAnimationRepeatCount:2] ;
    [_door setAnimationDuration:3.0f];
    [_door startAnimating];
    [self.view addSubview:_door] ;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_door stopAnimating] ;
    [_door performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:_door.animationDuration] ;
    
    if (arc4random()%10 >5) {
        _door.image = [UIImage imageNamed:@"fail"] ;
        
    }else{
        
        _door.image = [UIImage imageNamed:@"success"] ;
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
