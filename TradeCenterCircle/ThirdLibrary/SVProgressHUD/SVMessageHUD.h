//
//  SVMessageHUD.h
//  CompanyFactory
//
//  Created by 91aiche on 14-5-28.
//  Copyright (c) 2014年 AmorYin. All rights reserved.
//

/**
 *	该第三方库主要用于自定义视图弹出框
 */

enum {
    SVMessageHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    SVMessageHUDMaskTypeClear, // don't allow
    SVMessageHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    SVMessageHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

typedef NSUInteger SVMessageHUDMaskType;

@interface SVMessageHUD : UIView {
    UIView *_hudView;
}
/*
 showInView:(UIView*)                -> the view you're adding the HUD to. By default, it's added to the keyWindow rootViewController, or the keyWindow if the rootViewController is nil
 status:(NSString*)                  -> a loading status for the HUD (different from the success and error messages)
 networkIndicator:(BOOL)             -> whether or not the HUD also triggers the UIApplication's network activity indicator (default is YES)
 posY:(CGFloat)                      -> the vertical position of the HUD (default is viewHeight/2-viewHeight/8)
 maskType:(SVProgressHUDMaskType)    -> set whether to allow user interactions while HUD is displayed
 */
+ (SVMessageHUD*)sharedView;

+ (void)show;
+ (void)showInView:(UIView*)view;
+ (void)showInView:(UIView*)view status:(NSString*)string;
+ (void)showInView:(UIView*)view status:(NSString*)string afterDelay:(NSTimeInterval)seconds;
+ (void)showInView:(UIView*)view status:(NSString*)string afterDelay:(NSTimeInterval)seconds posY:(CGFloat)posY;
+ (void)showInView:(UIView*)view status:(NSString*)string afterDelay:(NSTimeInterval)seconds posY:(CGFloat)posY maskType:(SVMessageHUDMaskType)maskType;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing

+ (void)dismiss; // simply dismiss the HUD with a fade+scale out animation
+ (void)dismissWithSuccess:(NSString*)successString; // also displays the success icon image
+ (void)dismissWithSuccess:(NSString*)successString afterDelay:(NSTimeInterval)seconds;
+ (void)dismissWithError:(NSString*)errorString; // also displays the error icon image
+ (void)dismissWithError:(NSString*)errorString afterDelay:(NSTimeInterval)seconds;
@end
