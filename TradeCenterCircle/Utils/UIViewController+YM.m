//
//  UIViewController+YM.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "UIViewController+YM.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "CoreAnimationEffect.h"
#undef	UIViewController_key_parameters
#define UIViewController_key_parameters	"UIViewController.parameters"
@implementation UIViewController (YM)

-(id)parameters
{
    id object =objc_getAssociatedObject(self, UIViewController_key_parameters);
    return object;
    
}

- (void)setParameters:(id)anObject
{
    [self willChangeValueForKey:@"parameters"];
    objc_setAssociatedObject(self, UIViewController_key_parameters, anObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"parameters"];
}
- (void)pushVC:(NSString *)vcName
{
    [self pushVC:vcName object:nil];
}

- (void)pushVC:(NSString *)vcName object:(id)object
{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class 必须存在");
    UIViewController *vc = nil;
    
    if ([class conformsToProtocol:@protocol(GMQSwitchControllerProtocol)])
    {
        vc = [[NSClassFromString(vcName) alloc] initWithObject:object];
    }
    else
    {
        vc = [[NSClassFromString(vcName) alloc] init];
        vc.parameters = object;
    }
    
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];

    /* 以下页面是跳转到公司服务器外链地址
     ** 美食上门商品详情DeliciousFoodIndexDetailView
     **综合服务商品详情GMQWebViewController
     **停车服务停车信息详情GMQWebViewController
     **首页-购物车ShopCartViewController
     **我的购物车MyShopCartViewController
     */
    
    
    NSArray *vcNameArr = @[@"DeliciousFoodIndexDetailView",@"GMQWebViewController",@"ShopCartViewController",@"MyShopCartViewController"];
    
    [vcNameArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        if([vcName rangeOfString:vcNameArr[idx]].location !=NSNotFound){
            
            [USER_DEFAULT setObject:@"1" forKey:kGetIntoVC];
            [USER_DEFAULT synchronize];
            
        }else{
        }
    }];
}

- (void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName
{
    [self modalVC:vcName withNavigationVC:navName object:nil succeed:nil];
}


- (void)modalVC:(NSString *)vcName withNavigationVC:(NSString *)nvcName object:(id)object succeed:(UIViewController_block_void)block
{
    Class class = NSClassFromString(vcName);
    NSAssert(class != nil, @"Class 必须存在");
    
    UIViewController *vc = nil;
    
    if ([class conformsToProtocol:@protocol(GMQSwitchControllerProtocol)])
    {
        vc = [[NSClassFromString(vcName) alloc] initWithObject:object];
    }
    else
    {
        vc = [[NSClassFromString(vcName) alloc] init];
        vc.parameters = object;
    }
    
    UINavigationController *nvc = nil;
    if (nvcName)
    {
        nvc = [[NSClassFromString(nvcName) alloc] initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:block];
        
        return;
    }
    
    [self presentViewController:vc animated:YES completion:block];
}


- (void)dismissModalVC
{
    [self dismissModalVCWithSucceed:nil];
}
- (void)dismissModalVCWithSucceed:(UIViewController_block_void)block{
    [self dismissViewControllerAnimated:YES completion:block];
}

@end
