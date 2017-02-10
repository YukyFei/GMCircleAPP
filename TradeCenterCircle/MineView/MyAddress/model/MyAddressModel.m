//
//  MyAddressModel.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/26.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyAddressModel.h"

@implementation MyAddressModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}



@end
