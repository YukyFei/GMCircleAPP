//
//  HBCustomActionSheetView.h
//  iHummingBird
//
//  Created by Tang Shilei on 14-10-17.
//  Copyright (c) 2014年 HummingBird. All rights reserved.
//

#import <UIKit/UIKit.h>

/**guomao*/
//楼宇
typedef void (^BuildingPickerActionSheetBlock)(NSString *building,NSString * spaceid);
//房间
typedef void (^HousePickerActionSheetBlock)(NSString *house,NSString * houseid);

//快递类别
typedef void (^PostClassActionSheetBlock)(NSString *postclass,NSString * postid);
//目的地
typedef void (^DestinationPickerActionSheetBlock)(NSString *destination,NSString * destinationid);
/*********/

//性别
typedef void (^SexActionSheetBlock)(NSString * SEX,NSString * SEXID);

//报事地址
typedef void (^AddressPickerControllerBlock)(NSString *address,NSString*spaceID);
//报事时间
typedef void (^DatePickerActionSheetBlock)(UIDatePicker *picker);
typedef void (^DatePickerControllerBlock)(NSString* dateStr,NSString *dateTime);

@interface HBCustomActionSheetView : UIView
{
    UIView *view;
    UIButton *cancelBtn;
    UIButton *selectBtn;
    UIControl *viewControl;
    UILabel * label ;
}
/***/
@property(nonatomic,retain)UIControl *viewControl;
@property(nonatomic,copy)BuildingPickerActionSheetBlock buildBlock ;
@property(nonatomic,copy)HousePickerActionSheetBlock houseBlock ;
@property(nonatomic,copy)PostClassActionSheetBlock postBlock ;
@property(nonatomic,copy)DestinationPickerActionSheetBlock destinationBlock ;


@property(nonatomic,copy)AddressPickerControllerBlock addressBlock;
@property(nonatomic,copy)DatePickerActionSheetBlock dateBlock;

@property(nonatomic,copy)DatePickerControllerBlock datePickBlock;




/***/
@property(nonatomic,copy)SexActionSheetBlock SexBlock ;

/*****/
//楼宇
-(instancetype)initWithFrame:(CGRect)frame andtitle:(NSString *)title andData:(NSArray*)array andBuildingPickControllrtBlock:(BuildingPickerActionSheetBlock)block  ;
//房间
-(id)initWithFrame:(CGRect)frame andHousePickerActionSheetBlock:(HousePickerActionSheetBlock)block ;
//快递类别
-(id)initWithFrame:(CGRect)frame andData:(NSArray*)array andPostClassActionSheetBlock:(PostClassActionSheetBlock)block ;
-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andData:(NSArray *)array andPostClassActionSheetBlock:(PostClassActionSheetBlock)block ;
//目的地
-(id)initWithFrame:(CGRect)frame andDestinationPickerActionSheetBlock:(DestinationPickerActionSheetBlock)block ;
/**********/

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)array andSexActionSheetBlock:(SexActionSheetBlock)block ;


//地址选择

-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray*)array andAddressPickControllrtBlock:(AddressPickerControllerBlock)block;

-(id)initWithFrame:(CGRect)frame andDatePickControllerBlock:(DatePickerControllerBlock)block  Message:(NSString *)mes;

-(id)initWithFrame:(CGRect)frame andDatePickerBlock:(DatePickerActionSheetBlock)block;

-(id)initWithEndTimeFrame:(CGRect)frame andDatePickControllerBlock:(DatePickerControllerBlock)block  Message:(NSString *)mes;


//hud
-(id)initWithFrame:(CGRect)frame withTitle:(NSString*)title;

-(void)show;
-(void)hideAfterDelay:(NSInteger)delays;




@end
