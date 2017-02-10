//
//  UIButtonExt.h
//  motoon
//
//  Created by xiongfei on 15/5/11.
//  Copyright (c) 2015年 mthk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGTypes+Extension.h"
@interface UIButtonExt : UIButton
- (void)setText:(NSString *)text;

@end
@interface UIImage (extension)

// 自动使用中心点拉大图片
+ (UIImage*)stretchImage:(NSString*)name;

- (UIImage*)imageBlur:(CGBlur*)blur maskImage:(UIImage*)maskImage;
@end
@interface YKBadge : UIView

@property (nonatomic,assign) BOOL hiddenWhenZero;
@property (nonatomic,assign) NSUInteger num;

@end
@interface UIBarButtonItem(ext)

+ (instancetype)initWithImage:(NSString *)image delegate:(id)delegate action:(SEL)action;
+ (instancetype)initWithTitle:(NSString *)title delegate:(id)delegate action:(SEL)action;

- (void)setBadgeNum:(NSUInteger)num;

@end
@interface NSString (extension)
- (NSString *) md5;
@end
