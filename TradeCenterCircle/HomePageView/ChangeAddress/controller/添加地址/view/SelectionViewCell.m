//
//  CommunityList.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "SelectionViewCell.h"

@implementation SelectionViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    //创建一个标识
    static NSString *ID = @"selectionCell";
    //确定缓存池中是否有cell
    SelectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //如果没有就重新创建一个cell
    if (cell == nil ) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectionViewCell" owner:nil options:nil] lastObject];
        
    }
    return cell;
    
}

@end
