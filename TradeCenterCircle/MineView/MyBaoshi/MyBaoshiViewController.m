//
//  MyBaoshiViewController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/11/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyBaoshiViewController.h"
#import "AppDelegate.h"
#import "YMRefreshTableView.h"
//#import "MfTableViewCell.h"
//#import "FmTableViewCell.h"
#import "AffairRecordItem.h"
//#import "LocationHelper.h"
//#import "MeToServiceCell.h"
#import "ForMeServiceCell.h"
//#import "EvaluationOwernController.h"
//#import "EvaluationController.h"
#import "GMQTabBarController.h"
#define SEG_HEIGHT 30
#define kHeadheight 50

@interface MyBaoshiViewController ()<YMRefreshTableDelegate>

{
    NSInteger currentPageFm;
    NSInteger pageSizeFm;
    NSInteger currentPageM;
    NSInteger pageSizeM;
}
@property(nonatomic,strong)YMRefreshTableView *fmTableView;//我提供服务
@property(nonatomic,strong)YMRefreshTableView *mTableView;//为我服务
@property(nonatomic,strong)NSMutableArray *dataArrayM;//为我服务记录数据源
@property(nonatomic,strong)NSMutableArray *dataArrayFm;//我提供服务纪录数据源


@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong) NSArray *imageArray;
@property(nonatomic,assign)NSInteger pageCount;

@property(nonatomic,weak)UILabel *tipLabelFm;

@property(nonatomic,weak)UILabel *tipLabelM;

@property(nonatomic,assign)BOOL isMTableView;
@end


@implementation MyBaoshiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"我的报事"];
    
    [self createUI];
    currentPageM = 1 ;
    [self loadServiceData];
    [self notification];

}


-(void)createUI
{
//    [self createSegment];
//    [self addLabelTipFm];
    [self addLabelTipM];
    [self.view addSubview:self.mTableView];
//    [self.view addSubview:self.fmTableView];
//    self.fmTableView.hidden = YES;
    
}

-(void)notification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updataData) name:KNotificationEvaluationOwner object:nil];
}
-(void)updataData{
    
    self.isMTableView = NO;
    [self loadHeader];
    
}

//为我服务
-(void)loadServiceData
{
    
//    currentPageM=1;
    pageSizeM=3;
//    NSDictionary *dict =@{@"Page":@(currentPageM),@"Page_size":@(pageSizeM),@"User_id":[USER_DEFAULT objectForKey:USER_ID],@"Community_id":@[[USER_DEFAULT objectForKey:COMMUNITY_ID]],@"Status":@(2)};
//    {
//        "Community_id" =     (
//                              "13319532-57C7-481E-922E-00D651B3151A"
//                              );
//        Page = 1;
//        "Page_size" = 30;
//        Status = 2;
//        "User_id" = "14672A3C-E317-D9DE-9973-0F3DA66AB8F3";
//    }
    NSDictionary *dict =@{@"Page":@(currentPageM),@"Page_size":@(pageSizeM),@"User_id":[USER_DEFAULT objectForKey:kUserId],@"Community_id":@[[USER_DEFAULT objectForKey:kCommunityId]],@"Status":@(1)};
    
//    {"Status":"1","Page":"1","Page_size":"3","User_id":"765CCA91-1870-15F6-9054-B9C44448D187","Community_id":["D3D05D0A-9AC4-4C83-B648-39D6469C380C","07EC5D27-59FF-4A76-ACA7-0C3539577D7B","283CBBF9-4DE2-4E9D-D995-0AFC6F6FA7BF"]}
    
    [HttpService postWithServiceCode:@"My_Event_List" params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict=(NSDictionary*)jsonObj;
        
        [self.mTableView finishLoadHeaderRefresh];
        [self.mTableView finishLoadFooterRefresh];
        if([dict validateOk])
        {
            
            NSArray *arr=[[dict objectForKey:@"Data"] objectForKey:@"Event_List"];
            NSString *page=[[dict objectForKey:@"Data"] objectForKey:@"Page_count"];
            self.pageCount=[page integerValue];
            NSLog(@"。。。。%d",self.pageCount);
            if (!(arr.count>0)) {
                self.tipLabelM.hidden = NO;
//                self.mTableView.hidden = YES;
//                return ;
            }
            
            if(currentPageM>1)
            {
                [self.dataArrayM  addObjectsFromArray:[self arrayWithItemArray:arr]];
                [self.mTableView finishLoadFooterRefresh];
            }
            else
            {
                [self.mTableView finishLoadHeaderRefresh];
                self.dataArrayM=(NSMutableArray*)[self arrayWithItemArray:arr];
            }
            self.mTableView.items=self.dataArrayM;
            [self.mTableView reloadData];
            
        }
        NSLog(@"%@",jsonObj);
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络请求失败"] ;
        NSLog(@"%@",error);
    }];
    
}


-(void)addLabelTipM
{
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"身为业主，您还没有已经完结的服务单和报事单~";
    
    [tipLabel setTextColor:RGBCOLOR(0, 165, 145)];
    [tipLabel setFont:[UIFont systemFontOfSize:18]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    CGFloat tipH = 50;
    CGFloat tipY = ([UIScreen mainScreen].bounds.size.height-NavigationBar_HEIGHT-StatusBar_Height-kHeadheight-tipH)/2;
    tipLabel.frame = CGRectMake(Origin_x, tipY, VIEW_W(self.view), tipH);
    tipLabel.hidden = YES;
    [self.view addSubview:tipLabel];
    self.tipLabelM = tipLabel;
}



//为我服务
-(YMRefreshTableView*)mTableView
{
    if(!_mTableView)
    {
        __weak typeof(self) weakSelf=self;
        _mTableView =[YMRefreshTableView configTableViewframe:CGRectMake(Origin_x, 64, VIEW_W(self.view), VIEW_H(self.view)) style:UITableViewStylePlain items:self.dataArrayM configureCellBlock:^(id cell, id item) {
            ForMeServiceCell *mCell=(ForMeServiceCell*)cell;
            mCell.item=item;
            mCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            AffairRecordItem *affItem = (AffairRecordItem *)item;
            
            mCell.btnClick = ^(UIButton *btn){
                
                UIWebView * callWebview=[[UIWebView alloc]init];
                NSURL * telUrl=[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",affItem.Mobile]];
                [[AppDelegate sharedInstance].topMostViewContrller.view addSubview:callWebview];
                [callWebview loadRequest:[NSURLRequest requestWithURL:telUrl]];
                
                NSLog(@"打电话 ------- %@",affItem.Mobile);
            };
            mCell.evaluationBtnClick = ^(UIButton *btn){
                
//                EvaluationController *evaluationVc = [[EvaluationController alloc]init];
//                evaluationVc.Order_id = affItem.Order_id;
//                [self.navigationController pushViewController:evaluationVc animated:YES];
                
            };
        } selectCellBlock:^(NSIndexPath *indexPath) {
            
            
        } heightBlock:^CGFloat(NSIndexPath *indexPath) {
            
            AffairRecordItem *item = weakSelf.dataArrayM[indexPath.row];
            
            CGFloat rowHeight = [[ForMeServiceCell alloc] rowHeightForItem:item];
            //            NSLog(@"每一行的高度%f",rowHeight);
            return rowHeight;
        }];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        _mTableView.tableFooterView = view ;
        [_mTableView registerClass:[ForMeServiceCell class] forCellReuseIdentifier:@"cell"];
        
        _mTableView.enableHeader=YES;
        _mTableView.enableFooter=YES;
        _mTableView.refreshDelegate=self;
        
    }
    return _mTableView;
}



-(NSArray*)arrayWithItemArray:(NSArray*)data
{
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
    for(NSUInteger i=0;i<data.count;i++)
    {
        NSDictionary *dict=data[i];
        
        AffairRecordItem *item =[[AffairRecordItem alloc] init];
        item.createTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Creat_time"]] ;
        item.startTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Start_time"]] ;
        item.endTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"End_time"]];
        item.title= [dict objectForKey:@"Type_name"] ;
        item.Event_status =[NSString stringWithFormat:@"%@",[dict objectForKey:@"Event_status"]]  ;
        item.headImageUrl=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Type_icon"]] ;
        item.address= [NSString stringWithFormat:@"%@",[dict objectForKey:@"User_addr"]] ;
        item.desc =[NSString stringWithFormat:@"%@",[dict objectForKey:@"Event_title"]];
        item.eventPics=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Event_pic"]] ;
        
        item.Cancel_msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Cancel_msg"]] ;
        item.Status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Status"]];
        
        item.Order_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Order_id"]];
        item.Extra_info = [dict objectForKey:@"Extra_info"];
        if (item.Extra_info.count>0) {
            item.Nick_name = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"Extra_info"] objectForKey:@"Nick_name"]];
            item.Server_count = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"Extra_info"] objectForKey:@"Server_count"]];
            
        }
        NSString *complainfo = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Wo_complainInfo"]];
        if ([complainfo isEqualToString:@"(null)"]) {
            item.Wo_complainInfo = @"";
        }else{
            item.Wo_complainInfo = complainfo;
        }
        if ([item.Server_count isEqualToString:@"(null)"]) {
            item.Server_count = @"0";
        }
        
        NSLog(@"=====>%@  %@",item.Wo_complainInfo,complainfo);
        //        if (self.isMTableView) {
        if (self.isMTableView) {
            
            item.Nick_name = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"Extra_info"] objectForKey:@"Nick_name"]];
        }else{
            
            item.Nick_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Nick_name"]];
            
        }
        item.Rank_star = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"Extra_info"] objectForKey:@"Rank_star" ]];
        item.Ta_evaluationDesc = [NSString stringWithFormat:@"%@",[[[dict objectForKey:@"Evaluation_data"] objectForKey:@"Ta_evaluation" ] objectForKey:@"Desc"]];
        item.Ta_evaluationStar = [NSString stringWithFormat:@"%@",[[[dict objectForKey:@"Evaluation_data"] objectForKey:@"Ta_evaluation" ] objectForKey:@"Star"]];
        item.Wo_evaluationDesc = [NSString stringWithFormat:@"%@",[[[dict objectForKey:@"Evaluation_data"] objectForKey:@"Wo_evaluation" ] objectForKey:@"Desc"]];
        item.Wo_evaluationStar = [NSString stringWithFormat:@"%@",[[[dict objectForKey:@"Evaluation_data"] objectForKey:@"Wo_evaluation" ] objectForKey:@"Star"]];
        
        if ([item.Ta_evaluationDesc isEqualToString:@"(null)"]) {
            item.Ta_evaluationDesc = @"";
        }
        if ([item.Wo_evaluationDesc isEqualToString:@"(null)"]) {
            item.Wo_evaluationDesc = @"";
        }
        if ([item.Nick_name isEqualToString:@"(null)"]) {
            item.Nick_name = @"";
        }
        
        
        item.Cancel_msg = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Cancel_msg"]];
        item.Mobile = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"Extra_info"] objectForKey:@"Mobile"]];;
        
        if([item.title isKindOfClass:[NSNull class]]){
            item.title=@"";
        }
        if([item.desc isKindOfClass:[NSNull class]]){
            item.desc=@"";
        }
        if([item.address isKindOfClass:[NSNull class]]){
            item.address=@"";
        }
        if([item.Wo_complainInfo isEqualToString:@" "]){
            item.Wo_complainInfo=@"";
        }
        if([item.Wo_complainInfo isKindOfClass:[NSNull class]]){
            item.Wo_complainInfo=@"";
        }
        
        [arr addObject:item];
    }
    return arr;
}


-(void)loadHeader
{
//    if (self.isMTableView) {
        currentPageM=1;
        pageSizeM=30;
        NSLog(@"下拉刷新");
        [self loadServiceData];
//    }else{
//        currentPageFm=1;
//        pageSizeFm=30;
//        NSLog(@"下拉刷新");
//        [self request];
    
//        
//    }
}

-(void)loadFooter
{
//    if (self.isMTableView) {
        currentPageM++;
    bool a = NO ;
    if (self.pageCount %3 ==0) {
        a= currentPageM <= self.pageCount/3  ;
    }else{
       a= currentPageM<=self.pageCount/3 +1 ;
    }
    
    if (currentPageM<=self.pageCount) {
            [self loadServiceData];
        }
        else{
            NSLog(@"已经没有数据了");
            [self.mTableView finishLoadFooterRefresh];
            [ProgressHUD showUIBlockingIndicatorWithText:@"已经没有数据了" withTimeout:1.0f];
       }
//    }else{
//        currentPageFm++;
//        if(currentPageFm<=self.pageCount){
//            [self request];
//        }
//        else{
//            NSLog(@"已经没有数据了");
//            [self.fmTableView finishLoadFooterRefresh];
//            [ProgressHUD showUIBlockingIndicatorWithText:@"已经没有数据了" withTimeout:1.0f];
//        }
//    }
}

-(void)backClick
{
    if ([self.signStr isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.signStr isEqualToString:@"2"]){
        GMQTabBarController *mainView = [[GMQTabBarController alloc] init];
        [self.navigationController pushViewController:mainView animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
