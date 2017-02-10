//
//  CommunityList.h
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet UILabel *addressName;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
