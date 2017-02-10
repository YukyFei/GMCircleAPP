//
//  GMQBasicModel.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GMQBasicModel.h"

@implementation GMQBasicModel

+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    GMQBasicModel *model=[[self alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    
    return model;
}

//为了不蹦 清空为定义的key
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
