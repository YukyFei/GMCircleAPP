//
//  SizeUtility.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/31.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "SizeUtility.h"

@implementation SizeUtility

+ (CGFloat)textFontSize:(NSString *)titleName
{
    NSString *iphoneSetType = @"iphone4";
    CGFloat size = 0.0f;
    
    if (IS_IPHONE_4_OR_LESS){
        iphoneSetType = @"iphone4";
        size = [fontSize(titleName)[iphoneSetType] floatValue];
    }
    else if (IS_IPHONE_5){
        iphoneSetType = @"iphone5";
        size = [fontSize(titleName)[iphoneSetType] floatValue];
    }
    else if (IS_IPHONE_6){
        iphoneSetType = @"iphone6";
        size = [fontSize(titleName)[iphoneSetType] floatValue];
    }
    else if (IS_IPHONE_6P){
        iphoneSetType = @"iphone6p";
        size = [fontSize(titleName)[iphoneSetType] floatValue];
    }
    
    return size;
}

@end
