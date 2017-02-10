//
//  ParkInformationController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/12.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "ParkInformationController.h"
#import "ParkInfoCell.h"
#import "ParkInfoPICController.h"
#import "ParkInfoModel.h"
#import "HomeModel.h"
#import "GMQWebViewController.h"

#define kCustomViewHeight 150
@interface ParkInformationController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer     *myTimer;
}

@property(nonatomic,strong) UITableView * tableView ;
@property(nonatomic,strong) NSMutableArray * dataArr ;
@property(nonatomic,assign) int currentPage ;
//轮播图
@property(nonatomic,strong) NSMutableArray * pathArray ;
@property(nonatomic,strong) UIScrollView * scrollView ;
@property(nonatomic,strong) UIPageControl * page ;


@end

@implementation ParkInformationController
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array] ;
    }
    return _dataArr ;
}

-(NSMutableArray *)pathArray{
    if (!_pathArray ) {
        _pathArray = [NSMutableArray array] ;
    }
    return  _pathArray ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self loadTopPic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"停车信息"] ;
    _pathArray =[NSMutableArray arrayWithArray:_dataArr] ;
    [self createTableview] ;
}
-(void)createTableview
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-44) ];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.dataSource= self ;
    self.tableView.delegate = self ;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [self.view addSubview:self.tableView];
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
   [_tableView.legendHeader beginRefreshing];
//    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshings)] ;
//    UIView * footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80*SCREENHEIGHT/568)];
//    self.tableView.tableFooterView = footV ;

}

-(void)createHeadView
{
    if (self.pathArray.count ==0) {
        return ;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREENWIDTH, SCREENWIDTH/2)];
    bgView.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, VIEW_H(bgView))];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
    _scrollView.showsVerticalScrollIndicator =NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.backgroundColor =[UIColor clearColor];
    [bgView addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH*(_pathArray.count+1),VIEW_H(bgView));
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0, 0, SCREENWIDTH, VIEW_H(bgView))];
    HomeModel * lastmodel = self.pathArray.lastObject ;
       [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,lastmodel.O_pic]] placeholderImage:[UIImage imageNamed:@"moren"]];
    imageView.backgroundColor = [UIColor orangeColor] ;
    [_scrollView addSubview:imageView];

    for (int i = 0;i<[_pathArray count];i++) {
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH*i+SCREENWIDTH, 0, SCREENWIDTH, VIEW_H(bgView))];
        tempImageView.backgroundColor = [UIColor clearColor];
        HomeModel * model = self.pathArray[i] ;
        [tempImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,model.O_pic]] placeholderImage:[UIImage imageNamed:@"moren"]];
        tempImageView.userInteractionEnabled = YES;
        [_scrollView addSubview:tempImageView];
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH*(_pathArray.count +1), 0, SCREENWIDTH, VIEW_H(bgView))];
    HomeModel * firstmodel = self.pathArray.firstObject ;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,firstmodel.O_pic]] placeholderImage:[UIImage imageNamed:@"moren"]];
    [_scrollView addSubview:imageView];
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, VIEW_H(bgView)-30, SCREENWIDTH, 30)];
    _page.numberOfPages = _pathArray.count;
    _page.currentPage = 0;
    _page.pageIndicatorTintColor = [UIColor whiteColor];
    _page.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#007542"];
    _page.backgroundColor = [UIColor clearColor];
    [_page addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:_page];
    
    [self performSelector:@selector(updateScrollView) withObject:nil afterDelay:0.0f];
    self.tableView.tableHeaderView = bgView ;
}

/**
 * 顶部轮播图请求
 */
-(void)loadTopPic
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;

    [dict setValue:self.shopID forKey:@"Position"];
    [dict setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];

    [HttpService postWithServiceCode:kGetFigure params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        
        if (self.pathArray.count>0) {
            [self.pathArray removeAllObjects];
        }
        if ([resultDic validateOk]) {
            
            for (NSDictionary * dic in resultDic[@"Data"]) {
                HomeModel * model = [HomeModel modelWithDic:dic] ;
                [self.pathArray addObject:model];
            }
            [self createHeadView] ;
        }else{
        
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVMessageHUD showInView:self.view status:@"服务器响应异常" afterDelay:1.5f] ;
    }];
}

-(void)headerRefreshings
{
    
    [self.tableView.legendHeader endRefreshing];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;

    [dict setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dict setValue:self.shopID forKey:@"Cat_id"] ;
    [HttpService postWithServiceCode:GET_CAR_LIST params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        
       [self.tableView.legendHeader endRefreshing];
        if ([resultDic validateOk]) {
            if (self.dataArr.count>0) {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary * dic in resultDic[@"Data"]) {
                ParkInfoModel * model = [ParkInfoModel modelWithDic:dic] ;
                [_dataArr addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [ProgressHUD showActionWithMessage:resultDic[@"Message"] hiddenAffterDelay:1.5f];
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
       [self.tableView.legendHeader endRefreshing];
         [SVMessageHUD showInView:self.view status:@"服务器响应异常" afterDelay:1.5f] ;
    }];
    
}




#pragma -mark tableviewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = (_scrollView.contentOffset.x - _scrollView.frame.size.width
                       / ([_pathArray count]+2)) / _scrollView.frame.size.width + 1;
    
    //    NSLog(@"%d",currentPage);
    
    if (currentPage==0) {
        [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH*_pathArray.count, 0, SCREENWIDTH, SCREENWIDTH) animated:NO];
    }
    
    else if (currentPage==([_pathArray count]+1)) {
        //如果是最后+1,也就是要开始循环的第一个
        [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENWIDTH) animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    int page = _scrollView.contentOffset.x/SCREENWIDTH-1;
    _page.currentPage = page;
}

-(void)pageAction
{
    NSInteger page = _page.currentPage;
    [_scrollView setContentOffset:CGPointMake(SCREENWIDTH * (page+1), 0)];
}

- (void) updateScrollView
{
    [myTimer invalidate];
    myTimer = nil;
    //time duration
    NSTimeInterval timeInterval = 3;
    //timer
    myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self
                                             selector:@selector(handleMaxShowTimer:)
                                             userInfo: nil
                                              repeats:YES];
}

- (void)handleMaxShowTimer:(NSTimer*)theTimer
{
    CGPoint pt = _scrollView.contentOffset;
    NSInteger count = [_pathArray count];
    if(pt.x == SCREENWIDTH * count){
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [_scrollView scrollRectToVisible:CGRectMake(SCREENWIDTH,0,SCREENWIDTH,SCREENWIDTH) animated:YES];
    }else{
        [_scrollView scrollRectToVisible:CGRectMake(pt.x+SCREENWIDTH,0,SCREENWIDTH,SCREENWIDTH) animated:YES];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.dataArr.count ;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID" ;
    ParkInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID] ;
    if (cell == nil) {
        cell = [[ParkInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ParkInfoModel * model = self.dataArr[indexPath.row] ;
    cell.parkInModel = model ;
    
    if (indexPath.row ==3) {
        cell.subNameLab.text = @"" ;
    }
    if (cell.subNameLab.text ==nil||[cell.subNameLab.text isEqualToString:@""]) {
        cell.subNameLab.hidden = YES ;
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"cellID";
    
    ParkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ParkInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
   
    return [cell cellHeight] ;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    ParkInfoModel * model = self.dataArr[indexPath.row] ;
    
    
    NSString *url = [NSString stringWithFormat:@"B2cParkInfo/Detail?Car_id=%@",model.car_id] ;
     NSString *urlpin = [NSString stringWithFormat:@"B2cParkInfo/Detail?Car_id=%@&token=%@&user_id=%@",model.car_id,[USER_DEFAULT objectForKey:kLoginToken],[USER_DEFAULT objectForKey:kUserId]] ;
    NSString * mainTitle = model.maintitle ;
    
    GMQWebViewController * web = [[GMQWebViewController alloc]init];

    if ([USER_DEFAULT objectForKey:kGetIntoVC] == nil) {
        //第一次进入网页时候token的参数需要拼接
        web.InPutUrl = urlpin ;
        web.Webtitle = mainTitle ;
    }else{
        //第二次进入网页时候token的参数不需要拼接
        web.InPutUrl = url ;
        web.Webtitle = mainTitle ;
    }
    [self.navigationController pushViewController:web animated:YES];

    
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
