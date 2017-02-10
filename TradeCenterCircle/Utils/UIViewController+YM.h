//
//  UIViewController+YM.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIViewController_block_void) (void);
typedef void(^UIViewController_block_view) (UIView *view);
@interface UIViewController (YM)

@property (nonatomic, strong) id parameters; // 参数

// 导航
- (void)pushVC:(NSString *)vcName;
- (void)pushVC:(NSString *)vcName object:(id)object;
- (void)popVC;


// 模态 带导航控制器
- (void)modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName;
- (void)modalVC:(NSString *)vcName withNavigationVC:(NSString *)navName object:(id)object succeed:(UIViewController_block_void)block;
- (void)dismissModalVC;
- (void)dismissModalVCWithSucceed:(UIViewController_block_void)block;

@end

@protocol GMQSwitchControllerProtocol <NSObject>

-(id)initWithObject:(id)object;

@end
