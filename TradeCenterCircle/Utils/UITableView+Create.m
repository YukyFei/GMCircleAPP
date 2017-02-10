//
//  UITableView+Create.m
//  YourMate
//
//  Created by Tang Shilei on 14-12-9.
//  Copyright (c) 2014年 Yourmate. All rights reserved.
//

#import "UITableView+Create.h"
#import "YMTableViewCell.h"
#define myCellIdentifier @"cell"

@implementation UITableView (Create)

+ (UITableView*)plainTableViewWithFrame:(CGRect)frame
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    return tableView ;
    
}
+ (UITableView*)groupTableViewWithFrame:(CGRect)frame
{
    UITableView *tableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    return tableView;
}

@end


@implementation YMTableViewCell(Create)

+(UITableViewCell*)configCellForTableView:(UITableView*)tableView
{
    static NSString *cellName=myCellIdentifier;
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    return cell;
    
}


+(id<YMTableViewCellDelegate>)cellForTableView:(UITableView*)tableView
{
    static NSString *cellName=myCellIdentifier;
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    return (id<YMTableViewCellDelegate>)cell;
    
}


@end
