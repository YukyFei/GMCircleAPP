//
//  CustomTableViewCell.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "CustomTableViewCell.h"

#import "GGCMTView.h"
static NSString * cellId = @"TableViewCell";
@implementation CustomTableViewCell

+ (instancetype)customTableViewCellWithTableView:(GGCMTView *)cmtView
{
    CustomTableViewCell * cell = [cmtView dequeueReusableCMTViewCellWithIdentifier:cellId] ;
    
    if (!cell) {
        cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell initUI];
    }
    
    return cell;
}



- (void)initUI
{

    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH- 43*SCREENWIDTH/375, 40*SCREENWIDTH/375)];
    _titleLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Minecell_title_size]] ;
    _titleLab.userInteractionEnabled = YES ;
    _titleLab.textColor = [UIColor colorWithHexString:@"5f3f2a"] ;
    [self.contentView addSubview:_titleLab];
}



@end
