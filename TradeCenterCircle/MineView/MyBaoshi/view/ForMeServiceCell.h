//
//  ForMeServiceCell.h
//  YourMate
//
//  Created by apple on 15/11/27.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AffairRecordItem.h"
@interface ForMeServiceCell : UITableViewCell
@property(nonatomic,strong)AffairRecordItem *item;
@property(strong,nonatomic)void(^btnClick)(UIButton *);
@property(strong,nonatomic)void(^CancleOrderBtnClick)(UIButton *);
-(CGFloat)rowHeightForItem:(AffairRecordItem*)item;

//完结和评价服务单
@property(strong,nonatomic)void(^evaluationBtnClick)(UIButton *);

@end
