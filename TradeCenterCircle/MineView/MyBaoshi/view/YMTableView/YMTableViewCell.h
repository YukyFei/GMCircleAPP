//
//  YMTableViewCell.h
//  YourMate
//
//  Created by Tang Shilei on 15/7/3.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol YMTableViewCellDelegate <NSObject>

-(void)configForCellWithData:(id)data;
@optional
-(CGFloat)heightForData:(id)data;

@end


@interface YMTableViewCell : UITableViewCell


@end


