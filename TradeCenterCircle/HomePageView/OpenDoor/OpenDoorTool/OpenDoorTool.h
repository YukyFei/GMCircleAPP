//
//  OpenDoorTool.h
//  
//
//  Created by fyb on 2016/11/9.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <BabyBluetooth.h>
#import <UIKit/UIKit.h>
#include <notify.h>
#import "NearbyPeripheralInfo.h"
#import "SVProgressHUD.h"
#import "MacroDefinition.h"

typedef enum : NSUInteger {
    BT_CAN_CONNECT, //可以连接
    BT_DISCONNECT_CONNECT, //即将断开
    BT_KEEP_STATE, // 信号值均不符合要求，继续收集信号
} BT_STATE;

@class OpenDoorTool;
@protocol OpenDoorToolDelegate <NSObject>

@optional
- (void)openDoorTool:(OpenDoorTool *)openDoorTool refreshPeripherals:(NSMutableArray *)peripherals andRSSIArray:(NSMutableArray *)RSSIArray;


//蓝牙所有代理方法合集（暂时不用）
- (void)openDoorTool:(OpenDoorTool *)openDoorTool andBabyBlueTooth:(BabyBluetooth *)babyBlueTooth;


//蓝牙连接成功
- (void)openDoorTool:(OpenDoorTool *)openDoorTool didConnectBlueToothWithBabyBluetooth:(BabyBluetooth *)babyBlueTooth andBTName:(NSString *)btName;

//蓝牙断开成功
- (void)openDoorTool:(OpenDoorTool *)openDoorTool didDisconnectBlueToothWithBabyBluetooth:(BabyBluetooth *)babyBlueTooth;

//开门成功
- (void)openDoorTool:(OpenDoorTool *)openDoorTool didOpenDoorWithBabyBluetooth:(BabyBluetooth *)babyBlueTooth;


@optional //ibeacon CoreLocation相关

- (void)openDoorTool:(OpenDoorTool *)openDoorTool didRangingBeaconFailed:(NSError *)error;

@end





@interface OpenDoorTool : NSObject <CLLocationManagerDelegate>


@property(nonatomic,assign)id<OpenDoorToolDelegate>delegate;


//ibeacon相关属性

@property(nonatomic,strong)CLLocationManager * locationMgr; //定位服务管理

// 注册多个beacon区域，与蓝牙建立对应关系，为后台连接指定蓝牙做区分
@property(nonatomic,strong) NSMutableArray <CLBeaconRegion *> * mBeaconRegions;

@property(nonatomic,strong)NSMutableArray * beaconArr; //扫描到的ibeacon

@property(nonatomic,strong)NSMutableArray * scanedBeaconArray; //监控到的ibeacon

@property(nonatomic,assign)BOOL isMonitoringBeaconRegion; // 是否正在监控beaconRegion

@property(nonatomic,assign)BOOL isAccreditedBeaconRegion; // 是否被授权使用ibeacon

@property(nonatomic,strong) CBCentralManager * centralMgr; // 用于扫描ibeacon的Manager

@property(nonatomic,assign)BOOL isNear; // 靠近标志位，开始扫描后，如果还是靠近就不再开启扫描服务

// 定位服务是否可用
- (void)enableLocaitonService;

//开始监控ibeacon
- (void)beginMonitorBeacon;

// 停止监控ibeacon
- (void)stopMonitorForRegion:(CLBeaconRegion *)region;

//蓝牙相关属性

//连接成功标志位，监控此属性，一旦连接成功，立刻断开，测试断开连接慢问题（目前此属性没有使用）
@property(nonatomic,assign) BOOL isConnected;

@property(nonatomic,strong) BabyBluetooth *  babyBlueTooth; //蓝牙第三方实例化对象

@property(nonatomic,strong) NSMutableArray * peripherals; //扫描到的目的外设总和

@property(nonatomic,strong) CBPeripheral *   peripheral; //连接成功的外设

//@property(nonatomic,strong) NSMutableArray * devicesArray; //扫描到的所有蓝牙设备
//@property(nonatomic,strong) NSMutableArray * devicesRSSIArray; //与扫描到的所有蓝牙设备对应的信号值

/*
    CBCentralManagerScanOptionAllowDuplicatesKey
    CBCentralManagerScanOptionSolicitedServiceUUIDsKey
 */
@property(nonatomic,strong)NSDictionary * scanOptions; // 扫描参数（是否可以同时扫描多个）


/*
    CBConnectPeripheralOptionNotifyOnConnectionKey
    CBConnectPeripheralOptionNotifyOnDisconnectionKey
    CBConnectPeripheralOptionNotifyOnNotificationKey
 */
@property(nonatomic,strong)NSDictionary * connectOptions; // 连接参数


@property(nonatomic,copy)NSString * serviceStr; //服务uuid
@property(nonatomic,copy)NSString * readCharacterisicStr; //读特征值uuid
@property(nonatomic,copy)NSString * writeCharacterisicStr; //写特征值uuid

@property(nonatomic,copy)void(^block)(NSString *);

@property(nonatomic,strong)NSDate * beginConnectDate; //开始时间
@property(nonatomic,strong)NSDate * endConnectDate; //连接成功时间


// 设置扫描参数
- (void)setBTOptions;

// 设置babyBluetooth的代理
- (void)babyDelegateWithBabyBluetooth:(BabyBluetooth *)babyBT;



#pragma mark 卡号数据
@property(nonatomic,strong) NSString * cardNum;



+ (OpenDoorTool *)shareOpenDoorTool;

/**
 *  每次前后台切换和登录状态切换时，涉及到蓝牙的初始化，防止由于之前的操作对之后的逻辑状态有影响
 */
- (void)bluetoothCentralManagerInit;



@end
