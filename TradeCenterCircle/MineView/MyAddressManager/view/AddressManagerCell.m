//
//  AddressManagerCell.m
//  YourMate
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

#import "AddressManagerCell.h"

@implementation AddressManagerCell
- (IBAction)selectionAddress:(UIButton *)btn {
    
    if (self.btnClick) {
        self.btnClick(btn);
    }
    NSLog(@"选中设置默认按钮");
}

- (IBAction)houseBtn:(UIButton *)btn {
    
    if (self.houseBtnClick) {
        self.houseBtnClick(btn);
    }
    
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    if (self.deleteBtnClick) {
        self.deleteBtnClick(sender) ;
    }
    
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    //创建一个标识
    static NSString *ID = @"AddressManagerCell";
    //确定缓存池中是否有cell
    AddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //如果没有就重新创建一个cell
    if (cell == nil ) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddressManagerCell" owner:nil options:nil] lastObject];
        
    }
    
    return cell;
    
}

@end
