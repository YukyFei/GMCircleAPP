//
//  DeliciousFoodReserveController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "DeliciousFoodReserveController.h"
#import "CKCalendarView.h"
#import "DeliciousFoodIndexView.h"

@interface DeliciousFoodReserveController ()<UIScrollViewDelegate,CKCalendarDelegate>
{
    CKCalendarView *ccalendarView;
    int index;
}

@property(nonatomic,strong)UIScrollView    *scrollerView;
@property(nonatomic,strong)NSArray         *logoArr;    //存储logo图片
@property(nonatomic,assign)NSInteger       weekday;
@property(nonatomic,copy)  NSString        *selectStr;  //选中的日期

@end

@implementation DeliciousFoodReserveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"美食预定"];
    
    self.logoArr = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeight) name:@"changeHeight" object:nil];
    
    [self loadLogoData];
}

-(void)loadLogoData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
    [dic setValue:@"food" forKey:@"Shop_type"];
    
    [HttpService postWithServiceCode:kGetShopList params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            self.logoArr = dicresult[@"Data"];
            
            [self initScrollerView];

            [self.scrollerView.legendHeader endRefreshing];
            
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
                [self.scrollerView.legendHeader endRefreshing];
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.scrollerView.legendHeader endRefreshing];
    }];
}

-(void)changeHeight
{
    UILabel *lab = (UILabel *)[self.view viewWithTag:10];
    UIView  *_bgView = (UIView *)[self.view viewWithTag:100];
    
    lab.frame = CGRectMake(0, 20 + [ccalendarView heightCalendar] + 44, SCREENWIDTH, 45);
    
    _bgView.frame = CGRectMake(0, lab.bottom, SCREENWIDTH, 105*(index-1));
    
    _scrollerView.contentSize = CGSizeMake(SCREENWIDTH, [ccalendarView heightCalendar] + 105*(index-1) + 20 + 44 + 45);
}

-(void)initScrollerView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
        _scrollerView.delegate = self;
        _scrollerView.showsVerticalScrollIndicator =NO;
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.userInteractionEnabled = YES;
        [self.view addSubview:_scrollerView];
        
        //下拉刷新
        [_scrollerView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
        [_scrollerView.legendHeader beginRefreshing];
        
        //日历
        if (!ccalendarView) {
            CKCalendarView  *calendarView = [[CKCalendarView alloc] initWithStartDay:startMonday];
            calendarView.frame = CGRectMake(50, 0, SCREENWIDTH-100, [ccalendarView heightCalendar]);
            ccalendarView = calendarView;
            calendarView.delegate = self;
            [_scrollerView addSubview:calendarView];
        }
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"   美食预定";
        titleLab.frame = CGRectMake(0, 20 + [ccalendarView heightCalendar] + 44, SCREENWIDTH, 45);
        titleLab.backgroundColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = [UIFont systemFontOfSize:16.0];
        titleLab.tag = 10;
        titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        [_scrollerView addSubview:titleLab];
        
        if ((float)self.logoArr.count/3<=1 && (float)self.logoArr.count>0) {
            index=2;
        }else if ((float)self.logoArr.count/3<=2 && (float)self.logoArr.count>1) {
            index=3;
        }else{
            index = 4;
        }
        
        //背景图片
        UIView *_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLab.bottom, SCREENWIDTH, 105*(index-1))];
        _bgView.tag = 100;
        _bgView.backgroundColor = [UIColor whiteColor];
        [_scrollerView addSubview:_bgView];
        
        //横向分割线
        for (int i = 0; i < index; i++) {
            UIView *_wlineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*105, SCREENWIDTH, 0.5)];
            _wlineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
            [_bgView addSubview:_wlineView];
        }
        
        //竖向分割线
        for (int i = 0; i < 2; i++) {
            UIView *_hlineView = [[UIView alloc] initWithFrame:CGRectMake(((SCREENWIDTH)/3)*i + ((SCREENWIDTH)/3), 0, 0.5, 105*(index-1))];
            _hlineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
            [_bgView addSubview:_hlineView];
        }
        
        float width=50;
        float widthLab=100;
        
        //首页logo按钮
        for (int i=0; i<self.logoArr.count; i++) {
            UIButton *_titleBtn = [ButtonControl creatButtonWithFrame:CGRectMake((SCREENWIDTH/3-width)/2+(SCREENWIDTH/3)*(i%3)+(i/self.logoArr.count)*SCREENWIDTH, (16+(210 + width -width*3-5)*(i/3%3)), width, width) Text:nil ImageName:nil bgImageName:nil Target:self Action:@selector(btnClick:)];
            [_titleBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",demoURLL,self.logoArr[i][@"S_logo"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"moren"]];
            _titleBtn.adjustsImageWhenHighlighted = NO;
            _titleBtn.tag = i;
            [_bgView addSubview:_titleBtn];
            
            //首页logo标题
            UILabel *_titleLab = [ButtonControl creatLableWithFrame:CGRectMake((SCREENWIDTH/3-widthLab)/2+(SCREENWIDTH/3)*(i%3)+(i/self.logoArr.count)*SCREENWIDTH, (20 + width +(210 + width-width*3-5)*(i/3%3)), widthLab, 30) Text:self.logoArr[i][@"Shop_name"] font:[SizeUtility textFontSize:default_Logo_title_size] TextColor:[UIColor colorWithHexString:@"#5f3f2a"]];
            _titleLab.textAlignment = NSTextAlignmentCenter;
            [_bgView addSubview:_titleLab];
        }
        
        _scrollerView.contentSize = CGSizeMake(SCREENWIDTH, [ccalendarView heightCalendar] + 105*(index-1) + 20 + 44 + 45);
    }
}

-(void)headerRefreshings
{
    [self loadLogoData];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.selectStr = [dateFormat stringFromDate:date];
    
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSWeekdayCalendarUnit fromDate:date] weekday];
    self.weekday = week;
}

-(void)btnClick:(UIButton *)sender
{
    if ([ccalendarView selectCalendar] == nil) {
        [SVMessageHUD showInView:self.view status:@"请先选择预订日期" afterDelay:1.5];
    }else if(self.weekday == 1 || self.weekday == 7){
        [SVMessageHUD showInView:self.view status:@"周末不能预订哦！" afterDelay:1.5];
    }
    else{
        //商品预定
        self.hidesBottomBarWhenPushed = YES;
        DeliciousFoodIndexView *deliciousVC = [[DeliciousFoodIndexView alloc] init];
        deliciousVC.titleStr = self.logoArr[sender.tag][@"Shop_name"];
        deliciousVC.shopID = self.logoArr[sender.tag][@"Shop_id"];
        deliciousVC.signStr = self.selectStr;
        [self.navigationController pushViewController:deliciousVC animated:YES];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeHeight" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
