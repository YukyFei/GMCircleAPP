//
//  Header.h
//  锁屏状态
//
//  Created by fyb on 2017/2/17.
//  Copyright © 2017年 fyb. All rights reserved.
//

#ifndef Header_h
#define Header_h

//用到的宏定义

#define NotificationLock CFSTR("com.apple.springboard.lockcomplete")

#define NotificationChange CFSTR("com.apple.springboard.lockstate")

#define NotificationPwdUI CFSTR("com.apple.springboard.hasBlankedScreen")

#define DEBUG

/*
 beacon2deviceRelations.put("00:CD:FF:00:35:34", "08:7C:BE:23:34:07");
 beacon2deviceRelations.put("00:CD:FF:0E:50:F7", "08:7C:BE:23:34:07");
 */

// beacon相关宏
#define BeaconUUID @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825" //iBeacon的uuid可以换成自己设备的uuid
//#define BeaconMacAddress1 @"00:cd:ff:00:35:34" // BR517301（广播出来的localName）  BRDA（出厂名字）

//#define BeaconMacAddress1  @"00:cd:ff:0e:4e:ae" // BR517377
//#define BeaconMacAddress2 @"00:cd:ff:00:35:94" // BR517302

#ifdef DEBUG //测试

#define BeaconMacAddress1  @"00:cd:ff:0e:50:e8" // BR518062
#define BeaconMacAddress2  @"00:cd:ff:00:50:e9" // BR518061
#define BTMacAddress1      @"08:7C:BE:23:34:A2" // 白盒子

#else   //现场
        // 0220闸机测试使用
#define BTMacAddress1      @"08:7C:BE:23:34:C3" //1号板
#define BTMacAddress2      @"08:7C:BE:23:34:07" //2号板
#define BTMacAddress3      @"08:7C:BE:23:34:03" //3号板
#define BTMacAddress4      @"08:7C:BE:23:34:D0" //4号板

#define BTMacAddress5      @"08:7C:BE:23:34:C3" //5号板
#define BTMacAddress6      @"08:7C:BE:23:34:C3" //6号板
#define BTMacAddress7      @"08:7C:BE:23:34:C3" //7号板
#define BTMacAddress8      @"08:7C:BE:23:34:C3" //8号板
#define BTMacAddress9      @"08:7C:BE:23:34:C3" //9号板
#define BTMacAddress10     @"08:7C:BE:23:34:C3" //10号板

#define BeaconMacAddress1_1  @"00:cd:ff:0e:50:f8" //BR518067
#define BeaconMacAddress1_2  @"00:cd:ff:0e:50:76" //BR518072

#define BeaconMacAddress2_1  @"00:cd:ff:00:35:34" //BR517301
#define BeaconMacAddress2_2  @"00:cd:ff:0e:50:f7" //BR518068

#define BeaconMacAddress3_1  @"00:cd:ff:0e:50:f0" //BR518066
#define BeaconMacAddress3_2  @"00:cd:ff:0e:50:44" //BR518074（无法配置minor）

#define BeaconMacAddress4_1  @"00:cd:ff:0e:50:f6" //BR518069
#define BeaconMacAddress4_2  @"00:cd:ff:0e:50:77" //BR518071
#endif

#define BeaconMajor   @"10"
#define BeaconMinor_1 @"1"
#define BeaconMinor_2 @"2"
#define BeaconMinor_3 @"3"
#define BeaconMinor_4 @"4"
#define BeaconMinor_5 @"5"
#define BeaconMinor_6 @"6"
#define BeaconMinor_7 @"7"
#define BeaconMinor_8 @"8"
#define BeaconMinor_9 @"9"
#define BeaconMinor_10 @"10"



//百思通蓝牙
#define SERVICE_UUID @"0000fee9-0000-1000-8000-00805f9b34fb"
#define NOTIFY_UUID  @"d44bc439-abfd-45a2-b575-925416129601"
#define WRITE_UUID   @"d44bc439-abfd-45a2-b575-925416129600"

//#define BTMacAddress1 @"08:7C:BE:23:33:E4" // 老板子
//#define BTMacAddress1 @"08:7C:BE:23:34:A2" // 白盒子 蓝牙mac（以后从服务器接受，要和对应的beacon对应） --- 广播出来的是逆序的
//#define BTMacAddress1 @"08:7C:BE:23:32:C9"

//#define BTMacAddress1 @"08:7C:BE:23:35:FC" // 闸机内部
//#define BTMacAddress2 @"08:7C:BE:23:34:A2"

#define RSSI_Count 2
#define RSSI_Standard (-80.0)

#define NSDictionary(dict,phoneNum) [dict objectForKey:phoneNum]







#endif /* Header_h */
