//
//  GMQTabBarController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQTabBarController.h"
#import "GMQNavigationController.h"
#import "HomeViewController.h"
#import "ShopCartViewController.h"
#import "OpenDoorViewController.h"
#import "GMQOpenDoorController.h"
#import "OpenDoorController.h"

#import "MineViewController.h"
#import "MyShopCartViewController.h"

@interface GMQTabBarController ()

@end

@implementation GMQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createViewControllerS];
    [self createToolBar];
}

-(void)createViewControllerS
{
    //首页
    HomeViewController *homeView = [[HomeViewController alloc] init];
    GMQNavigationController *navHome = [[GMQNavigationController alloc] initWithRootViewController:homeView];
    
    //开门
//    OpenDoorViewController *opendoorView = [[OpenDoorViewController alloc] init];
//    GMQNavigationController *navopendoor = [[GMQNavigationController alloc] initWithRootViewController:opendoorView];

//    GMQOpenDoorController *opendoorView = [[GMQOpenDoorController alloc] init];
//    GMQNavigationController *navopendoor = [[GMQNavigationController alloc] initWithRootViewController:opendoorView];
    
    OpenDoorController * openDoorVC = [[OpenDoorController alloc] init];
    GMQNavigationController * navOpenDoor = [[GMQNavigationController alloc] initWithRootViewController:openDoorVC];
    
    
    //购物车
    MyShopCartViewController *shopView = [[MyShopCartViewController alloc] init];
    GMQNavigationController *navShopCart = [[GMQNavigationController alloc] initWithRootViewController:shopView];
    shopView.hidesBottomBarWhenPushed = YES;
    navShopCart.tabBarItem.tag =2;
    
    //我的
    MineViewController *mineView = [[MineViewController alloc] init];
    GMQNavigationController *navMine  = [[GMQNavigationController alloc] initWithRootViewController:mineView];
    self.viewControllers = @[navHome,navOpenDoor,navShopCart,navMine];
}

- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = [SizeUtility textFontSize:default_TabBar_height_size];
    tabFrame.origin.y = self.view.frame.size.height - [SizeUtility textFontSize:default_TabBar_height_size];
    self.tabBar.frame = tabFrame;
}

-(void)createToolBar
{
    //未选中
    NSArray *unSelectArray = @[@"common_btn_home_n",@"common_btn_door_n",@"common_btn_shoppingcart_n",@"common_btn_mine_n"];
    
    //选中
    NSArray *selectArray = @[@"common_btn_home_s",@"common_btn_door_s",@"common_btn_shoppingcart_s",@"common_btn_mine_s"];
    
//    NSArray *nameArray = @[@"首页",@"购物车",@"我的"];
    
    for (int i = 0; i<selectArray.count; i++) {
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary
                                                           dictionaryWithObjectsAndKeys: [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0],
                                                           NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary
                                                           dictionaryWithObjectsAndKeys: [UIColor colorWithRed:234.0/255.0 green:86.0/255.0 blue:42.0/255.0 alpha:1.0],
                                                           NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        UINavigationController *nc = self.viewControllers[i];
        UIImage *unSelectImage = [UIImage imageNamed: unSelectArray[i]];
        unSelectImage = [unSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImage = [UIImage imageNamed:selectArray[i]];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nc.tabBarItem = [nc.tabBarItem initWithTitle:@"" image:unSelectImage selectedImage:selectImage];
        
        if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 || IS_IPHONE_6){
            nc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        }
        else {
           nc.tabBarItem.imageInsets = UIEdgeInsetsMake(([SizeUtility textFontSize:default_TabBar_height_size]-50)/2, 0, -([SizeUtility textFontSize:default_TabBar_height_size]-50)/2, 0);
        }
        nc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
      
    }
}

-(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, 32, 50)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
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
