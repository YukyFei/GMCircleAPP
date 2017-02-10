//
//  ProgressHUD.h
//  iHummingBird
//
//  Created by Tang Shilei on 14-10-8.
//  Copyright (c) 2014年 HummingBird. All rights reserved.
//

// HUD 显示 (错误提示信息)
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface ProgressHUD : NSObject
{
    MBProgressHUD *hud;
    CGFloat offsetY;
}

+(void)showActionSheetViewMeg:(NSString*)msg hideAffterDelay:(NSTimeInterval)time;
+(void)showActionWithMessage:(NSString*)msg hiddenAffterDelay:(NSTimeInterval)time;
+ (id)sharedInstance;
- (void)showProgressHD:(BOOL)tf inView:(UIView *)inView info:(NSString *)info;
- (void)CompletedProgressHD:(BOOL)tf inView:(UIView *)inView msg:(NSString *)msg;
- (void)setOffsetY:(CGFloat)y;

+(MBProgressHUD*)showUIBlockingIndicator;
+(MBProgressHUD*)showUIBlockingIndicatorWithText:(NSString*)str;
+(MBProgressHUD*)showUIBlockingIndicatorWithText:(NSString*)str withTimeout:(int)seconds;
+(MBProgressHUD*)showUIBlockingProgressIndicatorWithText:(NSString*)str andProgress:(float)progress;

+(MBProgressHUD*)showAlertWithTitle:(NSString*)titleText text:(NSString*)text;
+(MBProgressHUD*)showAlertWithTitle:(NSString*)titleText text:(NSString*)text target:(id)t action:(SEL)sel;
+(void)hideUIBlockingIndicator;


@end
