//
//  RefreshManager.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/9/21.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefreshManager : NSObject<UIAlertViewDelegate>

+(RefreshManager *)manager;

-(void)isRefreshToken;

@end
