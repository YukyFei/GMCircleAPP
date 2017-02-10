//
//  AddressManagerCell.h
//  YourMate
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressCell;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *houseBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *downBgView;

@property(strong,nonatomic)void(^btnClick)(UIButton *);
@property(strong,nonatomic)void(^houseBtnClick)(UIButton *);

@property(nonatomic,strong)void(^deleteBtnClick)(UIButton *) ;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
