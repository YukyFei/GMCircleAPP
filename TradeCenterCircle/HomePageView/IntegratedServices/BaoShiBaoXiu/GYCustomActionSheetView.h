//
//  GYCustomActionSheetView.h
//  TradeCenterCircle
//
//  Created by 张广义 on 2016/11/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppIconView.h"

typedef void (^CustomActionSheetViewBlock)(NSInteger index);
typedef void (^DatePickerActionSheetBlock)(UIDatePicker *picker);
typedef void (^DatePickerControllerBlock)(NSString* dateStr,NSString *dateTime);
typedef void (^AddressPickerControllerBlock)(NSString *address,NSString*spaceID);
typedef void (^CellPickerControllerBlock)(NSString *address,NSString*spaceID,NSString *spaceType);

@interface GYCustomActionSheetView : UIView<AppIconViewDelegate>
{
    UIView *view;
    UIButton *cancelBtn;
    UIButton *selectBtn;
    UIControl *viewControl;
}



@property(nonatomic,copy)CustomActionSheetViewBlock block;
@property(nonatomic,retain)UIControl *viewControl;
@property(nonatomic,copy)DatePickerActionSheetBlock dateBlock;

@property(nonatomic,copy)DatePickerControllerBlock datePickBlock;
@property(nonatomic,copy)AddressPickerControllerBlock addressBlock;
@property(nonatomic,copy)CellPickerControllerBlock CellBlock;


//地址选择

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray*)array andAddressPickControllrtBlock:(AddressPickerControllerBlock)block;

//选择楼层
-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray*)array andCellPickControllrtBlock:(CellPickerControllerBlock)block;

//日期选择

-(id)initWithFrame:(CGRect)frame andDatePickControllerBlock:(DatePickerControllerBlock)block  Message:(NSString *)mes;

-(id)initWithFrame:(CGRect)frame andDatePickerBlock:(DatePickerActionSheetBlock)block;

-(id)initWithEndTimeFrame:(CGRect)frame andDatePickControllerBlock:(DatePickerControllerBlock)block  Message:(NSString *)mes;

//hud
-(id)initWithFrame:(CGRect)frame withTitle:(NSString*)title;
-(id)initWithFrame:(CGRect)frame  withSheetTitle:(NSString*)title andTitleArray:(NSArray*)titlesArray andImageArray:(NSArray*)imageArray andBlock:(CustomActionSheetViewBlock)block;

-(void)show;
-(void)hideAfterDelay:(NSInteger)delays;


@end
