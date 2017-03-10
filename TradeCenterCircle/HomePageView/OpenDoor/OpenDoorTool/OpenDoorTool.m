//
//  OpenDoorTool.m
//  
//
//  Created by fyb on 2016/11/9.
//
//

#import "OpenDoorTool.h"

@interface OpenDoorTool ()<CBCentralManagerDelegate>


@property(nonatomic,assign) BOOL hasSendData;


//  @[@{mac1:array1},@{mac2:array2},@{mac3:array3}]
@property(nonatomic,strong) NSMutableArray * BTMac_RSSIs;     //每个蓝牙模块对应的靠近信号值集合

@property(nonatomic,strong) NSMutableDictionary * beaconMac_BTMac; // 从服务器拿到的beacon对应的蓝牙

@property(nonatomic,strong) NSMutableArray * beaconMacs;      // 所有的beacon地址，beaconMac_BTMac字典取出所有的值

@property(nonatomic,strong) NSMutableArray * BTMacs;          // 服务器获得的所有的蓝牙mac

@property(nonatomic,strong) NSString       * currentBTMac;    // 当前可以连接的蓝牙MAC


@property(nonatomic,strong) NSMutableDictionary * minor_BTMac;       // beaconRegion的Minor对应的Mac
@property(nonatomic,strong) NSMutableArray * mMinors;

@end


static OpenDoorTool * tool = nil;
static BOOL isScreenLocked; //屏幕是否锁屏
@implementation OpenDoorTool


#pragma mark 懒加载

#pragma mark 多对一数组初始化

- (NSMutableArray *)BTMac_RSSIs
{
    if (!_BTMac_RSSIs) {
        
        _BTMac_RSSIs = [NSMutableArray array];
        
        for (NSString * btMac in self.BTMacs) {
            
            NSMutableArray * beaconRssiArray = [NSMutableArray array]; //存储ibeacon信号值
            
            NSDictionary * dict = [NSDictionary dictionaryWithObject:beaconRssiArray forKey:btMac];
            
            [_BTMac_RSSIs addObject:dict];
        }
    }
    return _BTMac_RSSIs;
}

- (NSMutableDictionary *)beaconMac_BTMac
{
    if (!_beaconMac_BTMac) {
        
//        _beaconMac_BTMac = [NSDictionary dictionaryWithObjectsAndKeys:BTMacAddress1,BeaconMacAddress1,BTMacAddress1, BeaconMacAddress2,nil];
        
        _beaconMac_BTMac = [NSMutableDictionary dictionary];

#ifdef OpenDoor_Debug
        
        [_beaconMac_BTMac setObject:BTMacAddressTest1 forKey:BeaconMacAddressTest1_1];
        [_beaconMac_BTMac setObject:BTMacAddressTest1 forKey:BeaconMacAddressTest1_2];
        
#else
        [_beaconMac_BTMac setObject:BTMacAddressTest1 forKey:BeaconMacAddressTest1_1];
        [_beaconMac_BTMac setObject:BTMacAddressTest1 forKey:BeaconMacAddressTest1_2];
        
        [_beaconMac_BTMac setObject:BTMacAddress3 forKey:BeaconMacAddress3_1];
        [_beaconMac_BTMac setObject:BTMacAddress3 forKey:BeaconMacAddress3_2];
        
        [_beaconMac_BTMac setObject:BTMacAddress4 forKey:BeaconMacAddress4_1];
        [_beaconMac_BTMac setObject:BTMacAddress4 forKey:BeaconMacAddress4_2];
#endif
        
        
        
        
//        [_beaconMac_BTMac setObject:BTMacAddress2 forKey:BeaconMacAddress1];
//        [_beaconMac_BTMac setObject:BTMacAddress2 forKey:BeaconMacAddress1];
//        [_beaconMac_BTMac setObject:BTMacAddress3 forKey:BeaconMacAddress1];
//        [_beaconMac_BTMac setObject:BTMacAddress3 forKey:BeaconMacAddress1];
//        [_beaconMac_BTMac setObject:BTMacAddress4 forKey:BeaconMacAddress1];
//        [_beaconMac_BTMac setObject:BTMacAddress4 forKey:BeaconMacAddress1];
//        [_beaconMac_BTMac setObject:BTMacAddress5 forKey:BeaconMacAddress1];
//        [_beaconMac_BTMac setObject:BTMacAddress5 forKey:BeaconMacAddress1];
        
    }
    return _beaconMac_BTMac;
}

- (NSMutableArray *)beaconMacs
{
    if (!_beaconMacs) {
        
        _beaconMacs = [NSMutableArray arrayWithArray:[self.beaconMac_BTMac allKeys]];
    }
    return _beaconMacs;
}


- (NSMutableArray *)BTMacs
{
    if (!_BTMacs) {
        
        NSArray * temp = [self.beaconMac_BTMac allValues];
        
        _BTMacs = [[NSMutableArray alloc]init];
        for (NSString *str in temp) {
            if (![_BTMacs containsObject:str]) {
                [_BTMacs addObject:str];
            }
        }
        NSLog(@"所有的蓝牙mac：%@",_BTMacs);

    }
    return _BTMacs;
}

#pragma mark BeaconRegion和蓝牙的对应关系

- (NSMutableDictionary *)minor_BTMac
{
    if (!_minor_BTMac) {
        
//        _minor_BTMac = [NSDictionary dictionaryWithObjectsAndKeys:BTMacAddress1,BeaconMinor_1,BTMacAddress1, BeaconMinor_2,nil];
        
        _minor_BTMac = [NSMutableDictionary dictionary];
#ifdef OpenDoor_Debug
        [_minor_BTMac setValue:BTMacAddressTest1 forKey:BeaconMinorTest];
#else
        [_minor_BTMac setValue:BTMacAddress1 forKey:BeaconMinor_1];
        [_minor_BTMac setValue:BTMacAddress2 forKey:BeaconMinor_2];
#endif
        
        
        
        
    }
    return _minor_BTMac;
}

- (NSMutableArray *)mMinors
{
    if (!_mMinors) {
        
        _mMinors = [NSMutableArray arrayWithArray:[self.minor_BTMac allKeys]];
    }
    return _mMinors;
}

- (NSMutableArray *)mBeaconRegions
{
    if (!_mBeaconRegions) {
        
        _mBeaconRegions = [NSMutableArray array];
        for (NSString * minor in self.mMinors) {
            
            NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:BeaconUUID];
            CLBeaconRegion * region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[BeaconMajor integerValue] minor:[minor integerValue] identifier:[NSString stringWithFormat:@"BeaconRegion%@",minor]];
            
            [_mBeaconRegions addObject:region];
        }
    }
    return _mBeaconRegions;
}

- (CBCentralManager *)centralMgr
{
    if (!_centralMgr) {
        
        _centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    }
    return _centralMgr;
}

- (BabyBluetooth *)babyBlueTooth
{
    if (!_babyBlueTooth) {
        
        _babyBlueTooth = [BabyBluetooth shareBabyBluetooth];
        [self setBTOptions];
        [self babyDelegateWithBabyBluetooth:_babyBlueTooth];
    }
    return _babyBlueTooth;
}

- (NSMutableArray *)peripherals
{
    if (!_peripherals) {
        
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

- (NSMutableArray *)scanedBeaconArray
{
    if (!_scanedBeaconArray) {
        
        _scanedBeaconArray = [NSMutableArray array];
    }
    return _scanedBeaconArray;
}

//- (NSMutableArray *)devicesArray
//{
//    if (!_devicesArray) {
//        
//        _devicesArray = [NSMutableArray array];
//    }
//    return _devicesArray;
//}

//- (NSMutableArray *)devicesRSSIArray
//{
//    if (!_devicesRSSIArray) {
//        
//        _devicesRSSIArray = [NSMutableArray array];
//    }
//    return _devicesRSSIArray;
//}




#pragma mark 方法
+ (OpenDoorTool *)shareOpenDoorTool
{
    if (!tool) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            tool = [[OpenDoorTool alloc] init];

        });
    }
    return tool;
}


- (instancetype)init
{
    if (self = [super init]) {
        
        _locationMgr = [[CLLocationManager alloc] init];
        _locationMgr.delegate = self;
        [self enableLocaitonService];
        _babyBlueTooth = [BabyBluetooth shareBabyBluetooth];
        [self babyDelegateWithBabyBluetooth:_babyBlueTooth];
    }
    return self;
}

#pragma mark ibeacon定位相关方法

/*----激活定位服务----*/
- (void)enableLocaitonService
{
    BOOL enable=[CLLocationManager locationServicesEnabled]; //定位服务是否可用
    
    int status=[CLLocationManager authorizationStatus];// 返回当前的定位授权状态
    
    if(!enable || status<3){
        
        [_locationMgr requestAlwaysAuthorization];  //请求权限，注意和info.plist NSLocationAlwaysUsageDescription文件中的对应
    }
    
}

// 开始扫描ibeacon
- (void)beginMonitorBeacon
{
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
    {
        [self startMonitorForRegion:nil];
    }
    else
    {
        self.isMonitoringBeaconRegion = NO;
        [SVProgressHUD dismissWithError:@"版本不支持CLBeaconRegion监控"];
    }
}

//定位服务开启后，开始监控
- (void)startMonitorForRegion:(CLBeaconRegion *)region
{
    if(self.isAccreditedBeaconRegion)
    {
        if (self.mBeaconRegions.count) {
            
            self.isMonitoringBeaconRegion = YES;
            
            for (CLBeaconRegion * tmpRegion in self.mBeaconRegions) {
                
                [self.locationMgr startMonitoringForRegion:tmpRegion];
                [self.locationMgr requestStateForRegion:tmpRegion]; //当在区域范围内的时候，在监测信号强度；此方法调用后，会调用didDetermineState，获取当前手机的位置，判断是否在ibeacon区域内部
            }

        }
        else {
            NSLog(@"self.mBeaconRegions = %@",self.mBeaconRegions);
            //[SVProgressHUD showErrorWithStatus:@"没有注册监控区域"];
            [SVProgressHUD dismissWithError:@"没有注册监控区域"];
        }
        
    }
    else {
        //[SVProgressHUD showErrorWithStatus:@"没有授权监控ibeacon"];
        [SVProgressHUD dismissWithError:@"没有授权监控ibeacon"];
    }
}
/**
 *  仅在退出登录时，才会关闭对所有region的监控
 *
 *  注意：停止监控ibeacon 停止监控时，要考虑是否处于连接状态，如果是，先断开连接再停止监控beacon
 */
- (void)stopMonitorForRegion:(CLBeaconRegion *)region
{
    //region不为空时，关闭对region的监控
    if(region != nil) {
        [self.locationMgr stopMonitoringForRegion:region];
        [self.locationMgr stopRangingBeaconsInRegion:region];
        return;
    }
    
    // 关闭所有的监控
    if (self.isMonitoringBeaconRegion) {
        
        for (CLBeaconRegion * region in self.mBeaconRegions) {
            
            [self.locationMgr stopMonitoringForRegion:region];
            [self.locationMgr stopRangingBeaconsInRegion:region];
        }
        
        self.isMonitoringBeaconRegion = NO;
        
        // 停止ibeacon扫描（处于前台模式时，ibeacon信号值是通过蓝牙扫描拿到的）
        if([self.centralMgr isScanning])
            [self.centralMgr stopScan];
        // 停止蓝牙设备扫描
        if([self.babyBlueTooth.centralManager isScanning])
            [self.babyBlueTooth.centralManager stopScan];
        // 断开所有连接的蓝牙设备
        if(self.babyBlueTooth.findConnectedPeripherals.count)
            [self.babyBlueTooth cancelAllPeripheralsConnection];
       
    }
}

//判断是否为正在检测的beacon，收集beacon信号使用
- (BOOL)isMonitorBeaconWithBeacon:(CLBeacon *)beacon
{
    if ([beacon.proximityUUID.UUIDString isEqualToString:BeaconUUID]) {
        
        if (beacon.major) {
            
            if ([[beacon.major stringValue] isEqualToString:BeaconMajor]) {
                
                if(beacon.minor)
                {
                    if ([self.mMinors containsObject:[beacon.minor stringValue]]) {
                     
                        return YES;
                    }
                    return NO;
                }
                return YES;
            }
            return NO;
        }
        return YES;
    }
    return NO;
}


// 达到条件后，扫描蓝牙,并记录记录开始时间
- (void)scanBTWhenRssiOK
{
//    if(![self.babyBlueTooth.centralManager isScanning])
//    {
        [self setBTOptions];
        
        NSLog(@"+++++++++++++++++++++++开始扫描++++++++++++++++++++");
        self.babyBlueTooth.scanForPeripherals().and.then.connectToPeripherals().discoverServices().discoverCharacteristics().begin();
        
        //    self.babyBlueTooth.scanForPeripherals().begin();
        NSDate * currentDate = [NSDate date];
        
        self.beginConnectDate = currentDate;
//    }
    
}

#pragma mark -- locationManager代理方法

//应用程序的授权状态更改时调用 Invoked when the authorization status changes for this application.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
#warning 只有用户定位始终开启可用，需优化
    if (!(status == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //NSLog(@"定位服务未开启！");
        [_locationMgr requestAlwaysAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateUnknown:
            NSLog(@"CLRegionStateUnknown");
            break;
        case CLRegionStateInside:
        {
            NSLog(@"CLRegionStateInside");
            if([CLLocationManager isRangingAvailable] && [region isKindOfClass:[CLBeaconRegion class]])
            {
                [self.locationMgr startRangingBeaconsInRegion:(CLBeaconRegion *)region]; //专门用来开始监控ibeacon的
                [self.scanedBeaconArray addObject:region]; //扫描到的beaconRegion，当前self.scanedBeaconArray无用
            } else {
                
                [SVProgressHUD dismissWithError:@"当前版本不支持"];
            }
            
            break;
        }
        case CLRegionStateOutside:
            NSLog(@"CLRegionStateOutside");
            break;
        default:
            break;
    }
}

//找到ibeacon后扫描它的信息
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region
{
    if (!([[region.proximityUUID UUIDString] isEqualToString:BeaconUUID])) {
        
        [self stopMonitorForRegion:region];
        
        return;
    }
    NSLog(@"--------------------分割线------------------------");
    // 后台情况,通过babybluetooth扫描到的ibeacon信号作为参考值
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        if(![self.babyBlueTooth.centralManager isScanning] && [self.babyBlueTooth findConnectedPeripherals].count == 0)
        {
            [self setBTOptions];
            self.babyBlueTooth.scanForPeripherals().begin();
        }
    }
    else //前台：通过新的centralMgr扫描ibeacon作为信号参考值
    {
        //前台情况：授权，蓝牙没有扫描，且没有靠近的状态下，才允许连接
        if(self.isAccreditedBeaconRegion)
        {
            if(![self.centralMgr isScanning] && self.isNear == NO) {
            
                if(self.centralMgr.state == CBCentralManagerStatePoweredOn) {
                    [self.centralMgr scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
                } else {
                    
                    [SVProgressHUD dismissWithError:@"请查看蓝牙是否打开！"];
                }
   
            }
            
        }
    }
}

- (void)test{
    {
//        NSLog(@"监控到的区域:%@",region);
//        
//        NSArray * btMacs = [self.minor_BTMac allValues];
//        
//        NSLog(@"btMacs = %@",btMacs);
//        for (CLBeacon * beacon in beacons) {
//            
//            NSLog(@"beacon.minor = %@",beacon.minor);
//            if (beacon.rssi >= -18) {
//                
//                continue;
//            }
//            NSString * btMacStr = [btMacs objectAtIndex:[beacon.minor integerValue]-1]; // 从蓝牙地址数组中取出beacon.minor对应的蓝牙mac
//            
//            for (NSDictionary * dict in self.BTMac_RSSIs) {
//                
//                if([dict objectForKey:btMacStr])
//                {
//                    BT_STATE state = [self isRssiOKWithRssi:[NSNumber numberWithInteger:beacon.rssi] andBeaconRssiArray:[dict objectForKey:btMacStr]];
//                    if(state == BT_CAN_CONNECT)
//                    {
//                        self.currentBTMac = btMacStr;
//                        [self scanBTWhenRssiOK]; //信号合格，扫描蓝牙
//                        break;
//                    }
//                }
//            }
//            
//            
//        }
    }
}

//发现进入ibeacon的回调
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    //NSLog(@"didEnterRegion");
    //    [self babyDelegateWithBabyBluetooth:_babyBlueTooth];
//    self.babyBlueTooth.scanForPeripherals().begin();
    
}


//离开区域的回调 离开区域，扫描ibeacon的蓝牙停止扫描
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"didExitRegion");
    
    if([self.centralMgr isScanning])
       [self.centralMgr stopScan];
}

#warning 此处报错
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
//    NSLog(@"%@--error:%@",NSStringFromSelector(_cmd),error);
//    
//    if ([self.delegate respondsToSelector:@selector(openDoorTool:didRangingBeaconFailed:)]) {
//        
//        [self.delegate openDoorTool:self didRangingBeaconFailed:error];
//    }
}

//ragineBeacon失败
- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    //NSLog(@"%@--error:%@",NSStringFromSelector(_cmd),error);
    
//    if ([self.delegate respondsToSelector:@selector(openDoorTool:didRangingBeaconFailed:)]) {
//        
//        [self.delegate openDoorTool:self didRangingBeaconFailed:error];
//    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //NSLog(@"Location manager failed: %@", error);
}






/* 分割线-------------------------------------------*/

#pragma mark Babybluetooth代理方法
//蓝牙所有代理方法合集
- (void)babyDelegateWithBabyBluetooth:(BabyBluetooth *)babyBT
{
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(babyBT) weakBabyBT = babyBT;
    
    // 设置取消扫描回调
    [babyBT setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"取消扫描");
    }];
    
    [babyBT setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        
        if (central.state == CBCentralManagerStatePoweredOn) {
            
            NSLog(@"蓝牙打开成功，开始扫描设备");
        } else {
            
            [SVProgressHUD dismissWithError:@"请打开蓝牙" afterDelay:1.0];
        }
        
    }];
    
    
    // 设备扫描到设备的委托
    [babyBT setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        if(RSSI.integerValue >= -18) return;
        
         NSString * btMacStr = [self getBTMacFromAdvertisementData:advertisementData];
        // 后台直接通过拿蓝牙设备的信号值作为是否连接的判断依据
        if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
        {
            NSLog(@"name = %@ , advertisementData = %@",peripheral.name,advertisementData);
            
           
            
            // 扫描到的蓝牙设备是闸机内的蓝牙
            if ([self.BTMacs containsObject:btMacStr]) {
                
                for (NSDictionary * dict in self.BTMac_RSSIs) {
                    
                    if([dict objectForKey:btMacStr])
                    {
                        BT_STATE state = [self isRssiOKWithRssi:RSSI andBeaconRssiArray:[dict objectForKey:btMacStr]];
                        if(state == BT_CAN_CONNECT)
                        {
                            self.currentBTMac = btMacStr;
                           
                            weakSelf.babyBlueTooth.having(peripheral).and.then.connectToPeripherals().discoverServices().discoverCharacteristics().begin();
                            break;
                        }
                    }
                }

            }
            
        }
        else
        {
            
            if([self.currentBTMac isEqualToString:btMacStr])
            {
                self.isNear = YES;
                if((![weakSelf.peripherals containsObject:peripheral]) && peripheral.services.count!=0)
                {
                    
                    [weakSelf.peripherals addObject:peripheral];
                }
            }

        }
    }];
    
    [babyBT setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
//        BOOL returnData;
//        if(self.BTMac_Address)
//            returnData = [self isScanedBTMacOKWith:advertisementData andGivenBTMac:self.BTMac_Address];
//        else
//            returnData = [self isScanedBTMacOKWith:advertisementData andGivenBTMac:BTMacAddress1];
//        
//        return returnData;
        return YES;

    }];
    
    [babyBT setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
    
        NSLog(@"self.currentBTMac = %@",self.currentBTMac);
        if(self.currentBTMac && self.currentBTMac.length>0)
        {
            return [self isScanedBTMacOKWith:advertisementData andGivenBTMac:self.currentBTMac];
        }
        else if(self.BTMac_Address && self.BTMac_Address.length>0)
        {
            return YES;
        }
        else
        {
            return NO;
        }

    }];
    
    [babyBT setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        
        NSLog(@"连接成功");
        self.isConnected = YES;

        [weakSelf.babyBlueTooth cancelScan];
        
        self.currentBTMac = nil;
        

        self.peripheral = peripheral;
//        if([self.delegate respondsToSelector:@selector(openDoorTool:didConnectBlueToothWithBabyBluetooth:andBTName:)])
//        {
//            [self.delegate openDoorTool:self didConnectBlueToothWithBabyBluetooth:self.babyBlueTooth andBTName:(NSString *)peripheral.name];
//        }
        
    }];
    
    
    [babyBT setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        //NSLog(@"连接失败:%@,%@",peripheral.name,error);
        self.isNear = NO; //标志位复位，靠近后可以开始蓝牙扫描
        
        [SVProgressHUD dismissWithError:@"蓝牙连接失败！！"];
//        [SVProgressHUD showErrorWithStatus:@"蓝牙连接失败！！"];
//        [SVProgressHUD dismissWithDelay:1.0];
        
//        [weakSelf.locationMgr startMonitoringForRegion:weakSelf.beaconRegion];
//        [weakSelf.locationMgr startRangingBeaconsInRegion:weakSelf.beaconRegion];
        [weakSelf startMonitorForRegion:nil];
        
    }];
    
    // 发现外设的service
    [babyBT setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        
        NSLog(@"发现services");
    }];
    
    // 发现外设的characteristic
    [babyBT setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        
        NSLog(@"发现特征值");
        
        for (CBCharacteristic * tempChar in service.characteristics) {
            
            if ([[tempChar.UUID.UUIDString lowercaseString] isEqualToString:NOTIFY_UUID]) {
                NSLog(@"READ");
                
                CBCharacteristicProperties property = tempChar.properties;
                //NSLog(@"property -- %lu",(unsigned long)property); // -- 16 --> 0x10
                //                [peripheral setNotifyValue:YES forCharacteristic:tempChar];
                //通知方式监听一个characteristic的值
                [weakBabyBT notify:peripheral characteristic:tempChar block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                    
                    
                    if(error)
                    {
                        //NSLog(@"设置Notify失败:%@",error);
                    }
                    //NSLog(@"设置notify");
                }];
                
            }
            else if ([[tempChar.UUID.UUIDString lowercaseString] isEqualToString:WRITE_UUID]) {
                NSLog(@"发现写特征。。。");
                
                //property=12，0x08 | 0x04 ---> 确定写数据的type = CBCharacteristicWriteWithoutResponse
                CBCharacteristicProperties property = tempChar.properties;

                if(!self.hasSendData)
                {
                    NSData * openDoorData = nil;
                    if(self.cardNum && ![self.cardNum isEqualToString:@""])
                    {
                        if([self.cardNum containsString:@"0x"])
                        {
                            NSString *str = self.cardNum;
                            //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
                            unsigned long cardNumber = strtoul([str UTF8String],0,16);
                            //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
//                            unsigned long red2 = strtoul([str UTF8String],0,0);
                            NSLog(@"转换完的数字为：%lx",cardNumber);
                            
                            int testNum = (int)cardNumber;
                            openDoorData = [self setPackageWithCardNum:testNum];
                        }
                        else
                        {
                            openDoorData = [self setPackageWithCardNum:[self.cardNum intValue]];
                        }
                    }
                    else
                        openDoorData = [self setPackageWithCardNum:0x12345678];
                    
                    NSLog(@"发送卡号数据...");
                    //                [peripheral writeValue:openDoorData forCharacteristic:tempChar type:CBCharacteristicWriteWithoutResponse];
                    
                    [peripheral writeValue:openDoorData forCharacteristic:tempChar type:CBCharacteristicWriteWithoutResponse];
                    self.hasSendData = YES; //发送过数据后，置为YES，在重新扫描连接时，延时执行
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bluetoothOpenDoorSuccess" object:nil];
//                    if([self.delegate respondsToSelector:@selector(openDoorTool:didOpenDoorWithBabyBluetooth:)])
//                    {
//                        [self.delegate openDoorTool:self didOpenDoorWithBabyBluetooth:self.babyBlueTooth];
//                        
//                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        self.hasSendData = NO;
                    });

                }
                
                Byte cancelByte[] = {0xa5,0xc3};
                
                NSData * cancelData = [NSData dataWithBytes:cancelByte length:2];
                
                NSLog(@"发送关闭蓝牙数据...");
                [peripheral writeValue:cancelData forCharacteristic:tempChar type:CBCharacteristicWriteWithoutResponse];
            }
        }
        
        
    }];
    
    [babyBT setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        
        //NSLog(@"setBlockOnReadValueForCharacteristic");
    }];
    
    // 订阅状态改变的block
    [babyBT setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        
        //NSLog(@"setBlockOnDidUpdateNotificationStateForCharacteristic");
    }];
    
    // 向蓝牙设备写数据成功回调
    [babyBT setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        
        if (error) {
            NSLog(@"写数据报错：%@",error);
        }
        
//        [SVProgressHUD showSuccessWithStatus:@"发送开门数据成功"];
        [SVProgressHUD dismissWithSuccess:@"发送开门数据成功"];
        
    }];
    
    // 从蓝牙设备读数据或收到Notify更新回调
    [babyBT setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        
        if (error) {
            
            NSLog(@"读数据失败原因:%@",error);
            return;
        }
        NSLog(@"读数据成功");
        
        [weakBabyBT cancelNotify:peripheral characteristic:characteristic];
        
    }];
    

    // 设置取消所有设备连接回调
    [babyBT setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        
        NSLog(@"成功取消所有设备连接");
        self.peripheral = nil;
        self.isConnected = NO;
        self.isNear = NO; //标志位复位，靠近后可以开始蓝牙扫描
        
//        [self startMonitorForRegion:nil]; // 断开连接后，不重新启动监控
        
//        if([self.delegate respondsToSelector:@selector(openDoorTool:didDisconnectBlueToothWithBabyBluetooth:)])
//        {
//            [self.delegate openDoorTool:self didDisconnectBlueToothWithBabyBluetooth:self.babyBlueTooth];
//        }
    }];
    
    
    
    // 取消扫描回调
    [babyBT setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        
        //NSLog(@"取消扫描");
    }];
    
    // 特征描述回调
    [babyBT setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        
    }];
    
}

/**
 *  刷新信号值
 *
 *  @return 无
 */

//- (void)updateBTDeviceInfoWithPeripheral:(CBPeripheral *)peripheral andRssi:(NSNumber *)RSSI {
//    for (CBPeripheral * temp in self.devicesArray) {
//        
//        if ([temp.name isEqualToString:peripheral.name]) {
//            
//            //已经扫描过某个设备,将最新的信号值更新
//            NSUInteger index = [self.devicesArray indexOfObject:temp];
//            [self.devicesRSSIArray replaceObjectAtIndex:index withObject:RSSI];
//        }
//        else if(temp == [self.devicesArray lastObject])
//        {
//            //新增设备，添加到devicesArray中
//            [self.devicesArray addObject:peripheral];
//            [self.devicesRSSIArray addObject:RSSI];
//        }
//        else
//        {
//            continue;
//        }
//        
//        
//    }
//    
////    if ([self.delegate respondsToSelector:@selector(openDoorTool:refreshPeripherals:andRSSIArray:)]) {
////        
////        [self.delegate openDoorTool:self refreshPeripherals:self.devicesArray andRSSIArray:self.devicesRSSIArray];
////    }
//}

#pragma mark 设置扫描参数：涉及到后台要扫描的蓝牙service，查找的Characteristic，扫描和连接的Options，程序一开始初始化
// 设置扫描参数
- (void)setBTOptions
{
    NSDictionary * scanOptions = nil;
    NSDictionary * connectOptions = nil;
    CBUUID * serviceUUID = nil;
    CBUUID * readCharUUID = nil;
    CBUUID * writeCharUUID = nil;
    
    NSMutableArray * servicesArray = [NSMutableArray array];
    NSMutableArray * characteristicsArray = [NSMutableArray array];
    
    
    scanOptions = self.scanOptions; //扫描参数
    connectOptions = self.connectOptions; //连接参数
    
    
    if (self.serviceStr) {
        serviceUUID = [CBUUID UUIDWithString:self.serviceStr];
        [servicesArray addObject:serviceUUID];
    }
    
    if (!servicesArray.count) {
        
        servicesArray = nil;
    }
    
    if (self.readCharacterisicStr) {
        
        readCharUUID = [CBUUID UUIDWithString:self.readCharacterisicStr];
        [characteristicsArray addObject:readCharUUID];
    }
    if (self.writeCharacterisicStr) {
        
        writeCharUUID = [CBUUID UUIDWithString:self.writeCharacterisicStr];
        [characteristicsArray addObject:writeCharUUID];
    }
    
    if (!characteristicsArray.count) {
        
        characteristicsArray = nil;
    }
    
    //NSLog(@"servicesArray : %@",servicesArray);
    [self.babyBlueTooth setBabyOptionsWithScanForPeripheralsWithOptions:scanOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:servicesArray discoverWithServices:servicesArray discoverWithCharacteristics:characteristicsArray];
}

//刷新蓝牙设备信息，用于显示给用户信号值的变化
//- (void)refreshDevicesDataWithPeripheral:(CBPeripheral *)peripheral andRSSI:(NSNumber *)RSSI andAdvertisementData:(NSDictionary *)advertisementData {
//    NearbyPeripheralInfo * info = [[NearbyPeripheralInfo alloc] init];
//    
//    info.name = peripheral.name;
//    info.RSSI = RSSI;
//    info.advertisementData = advertisementData;
//    
//    __weak typeof(self) weakSelf = self;
//    // 用于显示蓝牙信号值
//    if (weakSelf.devicesArray.count) {
//        
//        NSArray * array = [NSArray arrayWithArray:weakSelf.devicesArray];
//        for (NearbyPeripheralInfo * temp in array) {
//            
//            if ([temp.name isEqualToString:peripheral.name]) {
//                
//                [weakSelf.devicesArray replaceObjectAtIndex:[array indexOfObject:temp] withObject:info];
//                break;
//            }
//            else if(temp == [array lastObject])
//            {
//                [weakSelf.devicesArray addObject:info];
//            }
//            else
//                continue;
//        }
//    }
//    else
//    {
//        [weakSelf.devicesArray addObject:info];
//    }
//    
//    if([weakSelf.delegate respondsToSelector:@selector(openDoorTool:refreshPeripherals:andRSSIArray:)])
//    {
//        [weakSelf.delegate openDoorTool:self refreshPeripherals:self.devicesArray andRSSIArray:nil];
//    }
//    
//}




#warning 系统蓝牙代理方法,用于前台运行时，通过蓝牙扫描，收集信号速度更快
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //    CBCentralManagerStateUnknown = 0,
    //    CBCentralManagerStateResetting,
    //    CBCentralManagerStateUnsupported,
    //    CBCentralManagerStateUnauthorized,
    //    CBCentralManagerStatePoweredOff,
    //    CBCentralManagerStatePoweredOn,
    NSLog(@"CentralManager state = %d",central.state);
    if (!(central.state == CBCentralManagerStatePoweredOn)) {
        
        [SVProgressHUD dismissWithError:@"关闭蓝牙，会导致不能使用开门功能"];
    }
}

/* *
 功能：获取ibeacon的信号强度，判断是不是要靠近的ibeacon
 
 */
// 注意：peripheral.name是蓝牙外设的初始化名字  应以广播里的localName为准
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    // 为防止信号值有大于0的情况
    if([RSSI integerValue] >= 0)
        return;

    NSDictionary * dict = advertisementData[@"kCBAdvDataServiceData"];
    NSString * beaconMacAddress = nil;
    //获取ibeacon的mac地址
    if (dict) {
        
        if ([dict objectForKey:[CBUUID UUIDWithString:@"5242"]]) {
            
            NSString * str = [NSMutableString stringWithFormat:@"%@",[dict objectForKey:[CBUUID UUIDWithString:@"5242"]]];
            str = [str substringWithRange:NSMakeRange(5, 13)];
            //            str = [str substringFromIndex:5];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSString * retStr = [str substringWithRange:NSMakeRange(0, 2)];
            for(int i=2;i<str.length;i=i+2)
            {
                NSString * tmpStr = [str substringWithRange:NSMakeRange(i, 2)];
                retStr = [NSString stringWithFormat:@"%@:%@",retStr,tmpStr];
            }
            beaconMacAddress = retStr;
        }
        
    }
    
//    NSLog(@"所有的beacon地址：%@",self.beaconMacs);
    
    //所有的beaconMac是否包含当前扫描到的
    if ([self.beaconMacs containsObject:beaconMacAddress]) {
        
        NSString * tempBTMac = [self.beaconMac_BTMac objectForKey:beaconMacAddress]; // 拿到beacon对应的蓝牙mac
        
        for (NSDictionary * dict in self.BTMac_RSSIs) {
            
            NSMutableArray * mBeaconRssiArray = [dict objectForKey:tempBTMac];
            if(mBeaconRssiArray)
            {
                BT_STATE state = [self isRssiOKWithRssi:RSSI andBeaconRssiArray:mBeaconRssiArray];
                
                if(state == BT_CAN_CONNECT)
                {
                    self.currentBTMac = tempBTMac;
                    [self cancelScanBeaconAndStopRangeBeacon];
                    [self scanBTWhenRssiOK]; //信号合格，扫描蓝牙
                    break;
                }
                break;
            }
            
        }
        
    }
}

- (BT_STATE)isRssiOKWithRssi:(NSNumber *)RSSI andBeaconRssiArray:(NSMutableArray *)mBeaconRssiArray
{
    //    BT_CAN_CONNECT, //可以连接
    //    BT_DISCONNECT_CONNECT, //即将断开
    //    BT_KEEP_STATE,
    
    // 1. 收集信号值
    if (mBeaconRssiArray.count >= RSSI_Count) {
        
        [mBeaconRssiArray removeObjectAtIndex:0];
    }
    [mBeaconRssiArray addObject:RSSI];
    
    NSLog(@"当前信号值:%@",RSSI);
    NSLog(@"当前信号集合:%@",mBeaconRssiArray);
    
    int standardRssi = RSSI_Standard_Fore;
    int strongRssi = RSSI_Strong_Fore;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        
        standardRssi = RSSI_Standard_Back;
        strongRssi = RSSI_Strong_Back;
    }
    
    
    if([RSSI floatValue] >= strongRssi)      // 2. 信号值够强，可以直接连接，不需要获取三次求平均值
    {
        NSLog(@"beacon信号足够强，扫描指定蓝牙设备");
        [self cancelScanBeaconAndStopRangeBeacon];
        return BT_CAN_CONNECT;
    }
    else if([RSSI floatValue] < -90.0)  // 3. 信号值够强，可以直接连接，不需要获取三次求平均值
    {
        NSLog(@"beacon信号太弱");
        return BT_DISCONNECT_CONNECT;
    }
    else                                // 4. 算平均值，确定连接还是断开
    {
        if (mBeaconRssiArray.count == RSSI_Count) {
            
            float sum = 0;
            
            for (NSNumber * temp in mBeaconRssiArray) {
                
                sum += [temp floatValue];
            }
            
            if (sum/RSSI_Count > standardRssi) {
                
                NSLog(@"beacon信号合格，扫描指定蓝牙设备");
                //                [self cancelScanBeaconAndStopRangeBeacon];
                return BT_CAN_CONNECT;
            }
            else if(sum/RSSI_Count < -90.0)
            {
                NSLog(@"beacon信号远离，断开蓝牙设备连接");
                return BT_DISCONNECT_CONNECT;
            }
            else
                return BT_KEEP_STATE;
        }
        else
        {
            NSLog(@"信号收集还没有完成");
            return BT_KEEP_STATE;
        }
    }
}



#pragma mark 拼包---开门数据
- (NSData *)setPackageWithCardNum:(int)cardNum
{
    //包头（0xa3,0xef），有效数据，包尾(oxef,oxa3)，校验位（异或结果）
    
    int a = cardNum; //卡号
    
    //NSLog(@"卡号：%02x",a);
    Byte contentData[4] = {0}; //有效数据
    
    Byte * tmp = (Byte *)&a;
    contentData[3] = *tmp;
    contentData[2] = *(tmp+1);
    contentData[1] = *(tmp+2);
    contentData[0] = *(tmp+3);
    
    Byte openData[9] = {0}; //整个包
    
    Byte headData[] = {0xa3,0xef}; //包头
    
    Byte tailData[] = {0xfe,0x3a}; // 包尾
    
    memcpy(openData, headData, sizeof(headData));
    memcpy(openData+sizeof(headData), contentData, sizeof(contentData));
    memcpy(openData+sizeof(headData)+sizeof(contentData), tailData, sizeof(tailData));
    
    //计算校验位
    Byte checkData = 0x00;
    for (int i = 0; i < sizeof(openData)-1; i++) {
        
        checkData ^= openData[i];
    }
    
    checkData ^= 0xe1;
    checkData ^= 0xe2;
    
    memcpy(openData+2+4+2, &checkData, 1);
    
    for (int i = 0; i < 9; i++) {
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%02x",openData[i]]);
    }
    
    NSData * openDoorData = [NSData dataWithBytes:openData length:sizeof(openData)];
    return openDoorData;
}

/**
 功能：判断扫描到的蓝牙mac是否是已知的mac
 参数1：advisementData 广播数据
 参数2：givenBTMac 已知的蓝牙mac地址
 
 */
- (BOOL)isScanedBTMacOKWith:(NSDictionary *)advertisementData andGivenBTMac:(NSString *)givenBTMac
{
    // 拿到当前广播到的蓝牙地址
    NSString * btMacAddress = [self getBTMacFromAdvertisementData:advertisementData];
    
    // 已知mac地址
    NSMutableString * macStr = [NSMutableString string];

    macStr = (NSMutableString *)givenBTMac;
    
    // 当前mac地址和已知mac列表对比，相等则可连接
    if([btMacAddress isEqualToString:macStr]) // 扫描到的蓝牙mac是已知的mac地址
    {
        return YES;
    }
    else if(self.BTMac_Address && self.BTMac_Address.length > 0)
    {
        return YES;
    }
    
    return NO;
}

/**
    功能：广播数据提取蓝牙mac地址
    参数：（NSDictionary *）广播数据
 */
- (NSMutableString *)getBTMacFromAdvertisementData:(NSDictionary *)advertisementData
{
    NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
    if(!data) return nil;
    NSMutableString * btMacAddress = [NSMutableString string];
    Byte * byte = (Byte *)[data bytes];
    NSString * str = nil;
    for (int i = (int)data.length-1; i>=0; i--) {
        
        if (i==0) {
            
            str = [NSString stringWithFormat:@"%02x",byte[i]];
        }
        else
        {
            str = [NSString stringWithFormat:@"%02x:",byte[i]];
        }
        [btMacAddress appendString:str];
        
    }
    btMacAddress = (NSMutableString *)[btMacAddress uppercaseString];
    
//    NSLog(@"从广播数据中获取mac:%@",btMacAddress);
    return btMacAddress;
}


#warning 01-10添加关闭蓝牙扫描，貌似对于获取信号好些
- (void)cancelScanBeaconAndStopRangeBeacon
{
    if ([self.centralMgr isScanning]) {
        
        NSLog(@"停止蓝牙扫描beacon");
        [self.centralMgr stopScan];
    }
    
//    [self stopMonitorForRegion:self.beaconRegion];
}

- (void)bluetoothCentralManagerInit
{
    // 蓝牙设备扫描初始化
    if ([self.babyBlueTooth.centralManager isScanning]) {
        
        [self.babyBlueTooth cancelScan];
    }
    
    // ibeacon蓝牙扫描初始化
    if([self.centralMgr isScanning]) {
        
        [self.centralMgr stopScan];
    }
    
    // 连接状态初始化，保证每次处于未连接状态
    if([self.babyBlueTooth findConnectedPeripherals].count)
    {
        [self.babyBlueTooth cancelAllPeripheralsConnection];
    }
}

@end
