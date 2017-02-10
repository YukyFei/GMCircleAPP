//
//  NSString+SizeLayout.h
//  iHummingBird
//
//  Created by Tang Shilei on 14-10-4.
//  Copyright (c) 2014年 HummingBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SizeLayout)

//text 适应高度
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;
@end
