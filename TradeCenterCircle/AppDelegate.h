//
//  AppDelegate.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenDoorTool.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)OpenDoorTool * openDoorTool;

@property(nonatomic,strong) NSMutableArray * phoneNum_cardNum; //模拟数据，手机号对应的卡号

+ (AppDelegate*)sharedInstance;
- (UIViewController*)topMostViewContrller;

// 开启蓝牙扫描
- (BOOL)bluetoothStartOpenDoor;
- (BOOL)bluetoothStopOpenDoor;
@end

