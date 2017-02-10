//
//  AffairRecordItem.h
//  YourMate
//
//  Created by Tang Shilei on 15/6/15.
//  Copyright (c) 2015年 Yourmate. All rights reserved.
//

//报事记录item
#import <Foundation/Foundation.h>

@interface AffairRecordItem : NSObject
typedef NS_ENUM(NSInteger, Service_Status)
{
    Service_In = 0,//进行中
    SerVices_Provide,//服务中
    Service_Grabbed,//待抢单
    Service_Provide,//我提供的服务
    Service_Be_Provided,//为我服务的
    Complaint_Service, //投诉服务者
    Complaint_Owner//投诉业主
    
};
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *headImageUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *Event_status;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *Order_user_id;
@property(nonatomic,copy)NSString *eventPics;
@property(nonatomic,copy)NSString *Nick_name;
@property(nonatomic,copy)NSString *Rank_star;
@property(nonatomic,copy)NSString *Mobile;
//取消原因
@property(nonatomic,copy)NSString *Cancel_msg;
@property(nonatomic,assign)Service_Status serviceStatus;
//投诉
@property(nonatomic,copy)NSString *Wo_complainInfo;

@property(nonatomic,copy)NSString *Order_id;

//工单状态
@property(nonatomic,copy)NSString *Status;

//服务单数量
@property(nonatomic,copy)NSString *Server_count;


//服务这对我的评价
@property(nonatomic,copy)NSString *Ta_evaluationDesc;
@property(nonatomic,copy)NSString *Ta_evaluationStar;

//我对服务者的评价
@property(nonatomic,copy)NSString *Wo_evaluationDesc;
@property(nonatomic,copy)NSString *Wo_evaluationStar;

@property(nonatomic,strong)NSArray *Extra_info;

@end
