//
//  GMQBasicModel.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMQBasicModel : NSObject

+(instancetype)modelWithDic:(NSDictionary *)dic;

//为了不蹦 清空为定义的key
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
