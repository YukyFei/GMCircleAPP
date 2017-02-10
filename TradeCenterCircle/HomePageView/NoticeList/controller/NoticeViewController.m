//
//  NoticeViewController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/13.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableviewCell.h"
#import "YMRefreshTableView.h"
#import "NoticeModel.h"

#define SEG_HEIGHT 30
#define kHeadheight 50

@interface NoticeViewController ()<YMRefreshTableDelegate>
{
    NSInteger currentPage;
    NSInteger pageSize;
}

@property(nonatomic,strong)YMRefreshTableView * mTableView;//通知列表
@property(nonatomic,strong)NSMutableArray * dataArray;//数据源
@end

@implementation NoticeViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array ];
    }
    return _dataArray ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self loadData];
    [self start];
    [self createUI];
    [self setNaviBarTitle:@"近期通知"] ;

}


#pragma mark- Custom View
-(void)createUI
{
    [self.view addSubview:self.mTableView];
}


#pragma mark -loadData
- (void)start
{
    if (self.dataArray.count==0) {
        [self.mTableView beginRefreshing];
        [self request];
    }
    
}
-(void)request
{
    NSDictionary * dict =@{@"Page":@(currentPage),@"Page_size":@(pageSize),@"User_id":[USER_DEFAULT objectForKey:kUserId],@"Community_id":[USER_DEFAULT objectForKey:kCommunityId]};
    
    [HttpService postWithServiceCode:kRecent_Notice params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dict =(NSDictionary*)jsonObj;
        [self.mTableView finishLoadHeaderRefresh];
        NSLog(@"%@",jsonObj);
        if ([dict validateOk]) {
            NSArray * ArrayData=[[dict objectForKey:@"Data"]objectForKey:@"Notice_list"];
            if (currentPage>1) {
                [self.dataArray addObjectsFromArray:[self arrayWithItemArray:ArrayData]];
                [self.mTableView finishLoadFooterRefresh];
            }
            else
            {
                [self.mTableView finishLoadHeaderRefresh];
                self.dataArray=(NSMutableArray*)[self arrayWithItemArray:ArrayData];
                
            }
            self.mTableView.items=self.dataArray;
            [self.mTableView reloadData];
        }else{
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"暂无通知";
            hud.detailsLabelFont = [UIFont systemFontOfSize:18];
            hud.margin = 10.f;
            hud.yOffset = ([UIScreen mainScreen].bounds.size.height-StatusBar_Height-NavigationBar_HEIGHT-TABBAR_HEIGHT)/2-50;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            self.mTableView.hidden = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        }
        NSLog(@"%@",jsonObj);
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.mTableView finishLoadHeaderRefresh];
        NSLog(@"%@",error);
    }];
    
}
- (void)loadData
{
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    currentPage=1;
    pageSize=30;
    
}


- (NSArray*)arrayWithItemArray:(NSArray*)data
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    for (NSUInteger i=0; i<data.count; i++) {
        NSDictionary * dict = data[i];
        NoticeModel * item = [[NoticeModel alloc] init];
        item.Property_logo=[dict objectForKey:@"Property_logo"];
        item.Property_name=[dict objectForKey:@"Property_name"];
        item.Title=[dict objectForKey:@"Title"];
        item.Time=[dict objectForKey:@"Time"];
        item.Content=[dict objectForKey:@"Content"];
        item.Level=[dict objectForKey:@"Level"];
        
        [arr addObject:item];
    }
    return  arr;
    
}
#pragma mark  - delegate

#pragma mark - Custom Accessors
//通知列表
- (YMRefreshTableView*)mTableView
{
    if (!_mTableView)
    {
        //        __weak typeof(self) weakSelf=self;
        _mTableView =[YMRefreshTableView configTableViewframe:CGRectMake(Origin_x,NavigationBar_HEIGHT, VIEW_W(self.view), VIEW_H(self.view)-NavigationBar_HEIGHT) items:self.dataArray selectCellBlock:^(NSIndexPath *indexPath) {
            
            NSLog(@"点击cell");
        }];
        [_mTableView registerClass:NSClassFromString(@"NoticeTableviewCell") forCellReuseIdentifier:@"cell"];
        _mTableView.enableHeader=YES;
        _mTableView.enableFooter=YES;
        _mTableView.refreshDelegate=self;
    }
    return _mTableView;
}


#pragma mark --pull refresh load more
- (void)loadHeader
{
    //[self.mTableView finishLoadHeaderRefresh];
    currentPage=1;
    NSLog(@"下拉刷新");
    [self request];
    
}
- (void)loadFooter
{
    currentPage++;
    [self request];
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
