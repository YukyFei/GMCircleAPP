//
//  UITableView+Create.h
//  YourMate
//
//  Created by Tang Shilei on 14-12-9.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTableViewCell.h"
@interface UITableView (Create)

+(UITableView*)groupTableViewWithFrame:(CGRect)frame;
+(UITableView*)plainTableViewWithFrame:(CGRect)frame;

@end


@interface YMTableViewCell(Create)

+(UITableViewCell*)configCellForTableView:(UITableView*)tableView;
+(id<YMTableViewCellDelegate>)cellForTableView:(UITableView*)tableView;

@end