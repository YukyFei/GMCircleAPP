//
//  BaoShiViewController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/11/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "BaoShiViewController.h"
#import "AppIconView.h"
#import "MyCustomScrollView.h"
#import "BaoShiDetailViewController.h"


@interface BaoShiViewController ()<AppIconViewDelegate>

@property(nonatomic,strong)NSArray *itemsArray;
@property(nonatomic,strong)MyCustomScrollView *myMiddleCustomView;

@end

@implementation BaoShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setNaviBarTitle:self.titleName] ;
    [self loadData] ;
    
//    ItemRepairController *itemVC = [[ItemRepairController alloc]init];
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary] ;
//    NSString * community =  [USER_DEFAULT objectForKey:COMMUNITY_ID];
//    [dic setValue:community forKey:@"Community_id"];
//    
//    _BSUrlString = [NSString stringWithFormat:@"%@/community_id/%@",hostURLNotAP,community] ;
//    //                        NSLog(@"%@",_BSUrlString) ;
//    itemVC.url = _BSUrlString ;
//    itemVC.titleName = @"物业报事";
    [self creatUI];
}


-(void)loadData
{
    NSLog(@"    %@ %@",self.url,_url) ;
    [HttpService getWithUrl:self.url success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;
        self.itemsArray = [dict objectForKey:@"Data"];
        if ([dict validateOk]) {
            if (self.itemsArray.count > 0) {
                self.myMiddleCustomView.views = [self myMiddleView];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabelText = @"该项目没有此服务项目！";
                hud.detailsLabelFont = [UIFont systemFontOfSize:18];
                hud.margin = 10.f;
                hud.yOffset = ([UIScreen mainScreen].bounds.size.height-StatusBar_Height-NavigationBar_HEIGHT-TABBAR_HEIGHT)/2-50;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
            }
            
            
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


-(void)creatUI
{
    [self.view addSubview:self.myMiddleCustomView];
}


-(MyCustomScrollView*)myMiddleCustomView
{
    if(!_myMiddleCustomView)
    {
        _myMiddleCustomView=[[MyCustomScrollView alloc] initWithFrame:CGRectMake(Origin_x, 64, VIEW_W(self.view), VIEW_H(self.view))];
        _myMiddleCustomView.backgroundColor = CLEARCOLOR;
    }
    return _myMiddleCustomView;
}

//中间视图的view
-(NSMutableArray*)myMiddleView{
    
    NSMutableArray *_array = [NSMutableArray arrayWithCapacity:0];
    CGFloat leftMargin = 20*WIDTH_SCALE;
    CGFloat middleMargin = 36*WIDTH_SCALE;
    CGFloat y_middleMargin = 15;
    int num = 4;
    CGFloat width = (VIEW_W(self.view)-2*20-(num-1)*middleMargin)/num;
    CGFloat height = width+15;
    
    
    //页数
    CGFloat countAppIcon = VIEW_H(self.view)/height*num;
    NSInteger page = (self.itemsArray.count-1)/countAppIcon+1;
    
    for(int i = 0;i<page;i++){
        
        UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(Origin_x, Origin_y, VIEW_W(self.view), self.view.bounds.size.height)];
        
        middleView.userInteractionEnabled = YES;
        middleView.backgroundColor = CLEARCOLOR;
        
        NSUInteger number = ((i+1)*countAppIcon<self.itemsArray.count)?((i+1)*countAppIcon):self.itemsArray.count;
        
        for(int j = i*countAppIcon;j<number;j++)
        {
            NSDictionary *subDict = self.itemsArray [j];
            NSInteger _j = j-countAppIcon*i;
            NSString *name = SAFESTRING([subDict objectForKey:@"Service_name"]);
            NSString *imageUrl = SAFESTRING([subDict objectForKey:@"Service_pic"]);
            NSInteger appID = j;
            
            AppIconView *iconView = [[AppIconView alloc] initWithIconFrame:CGRectMake(leftMargin+(width+middleMargin)*(_j%num), 5+(height+y_middleMargin)*(_j/num), width, height) name:name fileIcon:imageUrl textColor:HexRGB(0x666666) isNet:YES];
            iconView.appId = appID;
            iconView.delegate = self;
            [middleView addSubview:iconView];
            
        }
        NSInteger count = self.itemsArray.count;
        NSInteger line = (count-1)/num+1;
        middleView.frame  = CGRectMake(Origin_x, Origin_y, VIEW_W(self.view), 10+line*height+(line-1)*y_middleMargin+10);
        
        CGRect frame = _myMiddleCustomView.frame;
        frame.size.height = 10+line*height+(line-1)*y_middleMargin+10+10;
        _myMiddleCustomView.frame  = frame;
        [_array addObject:middleView];
    }
    
    return _array;
}


/**
 *   点击按钮的协议方法
 */

-(void)appClicked:(AppIconView *)app
{
    NSLog(@"%d",app.appId);
    NSDictionary *dict=self.itemsArray[app.appId];
    NSString *name =SAFESTRING([dict objectForKey:@"Service_name"]);
    NSString *imageUrl =SAFESTRING([dict objectForKey:@"Service_pic"]);
    NSInteger appID= [[dict objectForKey:@"Service_id"] integerValue];
    BaoShiDetailViewController *baoshi = [[BaoShiDetailViewController alloc]init];
    baoshi.style = [NSString stringWithFormat:@"%@,%@,%@",name,imageUrl,[NSString stringWithFormat:@"%d",appID]] ;
    [self.navigationController pushViewController:baoshi animated:YES];
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
