//
//  LogisticsExpressViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "LogisticsExpressViewController.h"
#import "DeliveryView.h"
#import "HBCustomActionSheetView.h"
#import "LogisticBuildModel.h"
#import "LogisticDestModel.h"
#import "LogisticTypeModel.h"
#import "LogisticSuccessController.h"

@interface LogisticsExpressViewController ()<UIScrollViewDelegate,UITextViewDelegate>
@property(nonatomic,strong) UIScrollView * mScrollView ;
@property(nonatomic,strong) DeliveryView * deatilView ;
@property(nonatomic,strong) NSMutableArray * dataArray ;
@property(nonatomic,strong) NSMutableArray * buildArr ;
@property(nonatomic,strong) NSMutableArray * houseArr ;
@property(nonatomic,strong) NSMutableArray * typeArr ;
@property(nonatomic,strong) NSMutableArray * destArr ;
@property(nonatomic,strong) NSMutableArray * transArr ;


//参数
@property(nonatomic,strong) NSString *buildname ;

@property(nonatomic,copy) NSString * bulidID ;
@property(nonatomic,copy) NSString * housename ;
@property(nonatomic,copy) NSString * houseID ;
@property(nonatomic,copy) NSString * typename ;
@property(nonatomic,copy) NSString * typeID ;
@property(nonatomic,copy) NSString * destationame ;
@property(nonatomic,copy) NSString * destationID ;
@property(nonatomic,copy) NSString * transportName ;
@property(nonatomic,copy) NSString * transportID ;
@property(nonatomic,strong) UIButton * submitBtn ;


@property(nonatomic,copy) NSString * Area ;
@property(nonatomic,copy) NSString * PressNote ;


@end

@implementation LogisticsExpressViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray ) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}
-(NSMutableArray *)buildArr
{
    if (!_buildArr) {
        _buildArr = [NSMutableArray array] ;
    }
    return _buildArr ;
}
-(NSMutableArray *)houseArr
{
    if (!_houseArr) {
        _houseArr = [NSMutableArray array] ;
    }
    return _houseArr ;
}

-(NSMutableArray *)typeArr
{
    if (!_typeArr ) {
        _typeArr = [NSMutableArray array] ;
    }
    return _typeArr ;
}

-(NSArray *)destArr
{
    if (!_destArr) {
        _destArr = [NSMutableArray array] ;
    }
    return _destArr ;
}
-(NSMutableArray *)transArr
{
    if (!_transArr) {
        _transArr = [NSMutableArray array] ;
    }
    return _transArr ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [SVMessageHUD showInView:self.view status:@"加载中"] ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadOtherMessage] ;
    }) ;
}

-(void)loadOtherMessage
{
     NSDictionary * dic = @{@"Community_id":[USER_DEFAULT objectForKey:kCommunityId]} ;
    [HttpService postWithServiceCode:GET_EXPRESS params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        if ([resultDic validateOk]) {
            
            [SVMessageHUD dismiss] ;
            if (self.typeArr.count > 0) {
                [self.typeArr removeAllObjects];
            }if (self.destArr.count >0) {
                [self.destArr removeAllObjects];
            }
            for (NSDictionary * dic in [resultDic[@"Data"] objectForKey:@"Destination"] ) {
                LogisticTypeModel * model = [LogisticTypeModel modelWithDic:dic] ;
                [self.destArr addObject:model];
            }
            for (NSDictionary * dic in [resultDic[@"Data"] objectForKey:@"Type"]) {
                LogisticTypeModel * model = [LogisticTypeModel modelWithDic:dic] ;
                [self.typeArr addObject:model];
            }
            for (NSDictionary * dic in [resultDic[@"Data"] objectForKey:@"Transport"]) {
                LogisticTypeModel * model = [LogisticTypeModel modelWithDic:dic] ;
                [self.transArr addObject:model];
            }
            self.Area = [resultDic[@"Data"] valueForKey:@"Area"] ;
            self.PressNote = [resultDic[@"Data"]valueForKey:@"PressNote"] ;
            self.deatilView.addressLab.text = self.Area ;
            self.deatilView.downcolab.text = self.PressNote ;
            
            
        }else{
            [SVMessageHUD showInView:self.view  status:resultDic[@"Message"] afterDelay:1.5f] ;
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
     [SVMessageHUD showInView:self.view  status:@"服务器请求异常请稍后重试" afterDelay:1.5f] ;
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarTitle:@"物流快递"];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [self createUI] ;
    
}
-(void)createUI
{
    [self addScrollView] ;
    _deatilView = [[DeliveryView alloc]initWithFrame:CGRectMake(0, StatusBar_Height+TABBAR_HEIGHT, VIEW_W(self.view), VIEW_H(self.view)+StatusBar_Height+TABBAR_HEIGHT+5+80)];
    _mScrollView.userInteractionEnabled = YES ;
    [self.mScrollView addSubview:_deatilView] ;
    [_deatilView.buildBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside];
    [_deatilView.buiBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside];
    [_deatilView.floorBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    [_deatilView.flrBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    self.deatilView.detailTF.delegate = self ;
    
    [_deatilView.typeBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    [_deatilView.tyBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    [_deatilView.destatBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    [_deatilView.destBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    [_deatilView.tranBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside];
    [_deatilView.transportBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside];
    self.deatilView.sayTF.delegate = self ;
    self.deatilView.addressLab.text = self.Area ;
    self.deatilView.downcolab.text = self.PressNote ;
    
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(0, VIEW_BY(_deatilView), VIEW_W(self.view), 44*SCREENHEIGHT/667) andTitle:@"立即下单" andBackgroundImage:@""] ;
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    [_submitBtn setBackgroundColor:[UIColor redColor] ];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(submitBtnClC:) forControlEvents:UIControlEventTouchUpInside] ;
    [self.mScrollView addSubview:self.submitBtn];
    [_mScrollView setContentSize:CGSizeMake(VIEW_W(self.view), VIEW_BY(_deatilView)+100)];
    
}
-(void)addScrollView
{
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(Origin_x, Origin_y, VIEW_W(self.view), VIEW_H(self.view))];
    _mScrollView.showsVerticalScrollIndicator=NO;
    _mScrollView.userInteractionEnabled=YES;
    _mScrollView.delegate = self;
    _mScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 90);
    _mScrollView.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview:_mScrollView];
    
}

#pragma mark - 提交按钮的点击事件
-(void)submitBtnClC:(UIButton *)sender
{
    if (_deatilView.nameTF.text ==nil||[_deatilView.nameTF.text isEqualToString:@""]) {
        [SVMessageHUD showInView:self.view  status:@"请填写您的姓名" afterDelay:1.5f] ;
        return ;
    }else if (_deatilView.telTF.text ==nil||[_deatilView.telTF.text isEqualToString:@""]){
        [SVMessageHUD showInView:self.view status:@"请填写您的手机号" afterDelay:1.5f] ;
        return ;
    }else if (![RegularExpression checkTelNumber:_deatilView.telTF.text]){
        
        [SVMessageHUD showInView:self.view status:@"请填写正确的手机号" afterDelay:1.5f] ;
        return ;
    }else if (_deatilView.detailTF.text.length == 0||[_deatilView.telTF.text isEqualToString:@""]){
        [SVMessageHUD showInView:self.view  status:@"请填写具体地址" afterDelay:1.5f];
        return ;
    }else if (self.buildname==nil ||[self.buildname isEqualToString:@""]||self.bulidID==nil ||[self.bulidID isEqualToString:@""]){
        [SVMessageHUD showInView:self.view  status:@"请选择快递楼宇" afterDelay:1.5f];
        return ;
    }else if (self.housename==nil ||[self.housename isEqualToString:@""]||self.houseID==nil ||[self.houseID isEqualToString:@""]){
        [SVMessageHUD showInView:self.view  status:@"请选择快递楼层" afterDelay:1.5f];
        return ;
    }else if (self.typename==nil ||[self.typename isEqualToString:@""]||self.typeID==nil ||[self.typeID isEqualToString:@""]){
        [SVMessageHUD showInView:self.view  status:@"请选择快递类别" afterDelay:1.5f];
        return ;
    }else if (self.destationame==nil ||[self.destationame isEqualToString:@""]||self.destationID==nil ||[self.destationID isEqualToString:@""]){
        [SVMessageHUD showInView:self.view  status:@"请选择快递目的地" afterDelay:1.5f];
        return ;
    }else if (self.transportName==nil ||[self.transportName isEqualToString:@""]||self.transportID==nil ||[self.transportID isEqualToString:@""]){
        [SVMessageHUD showInView:self.view  status:@"请选择快递方式" afterDelay:1.5f];
        return ;
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init] ;
    [dict setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"] ;
    [dict setValue:_deatilView.nameTF.text forKey:@"Express_name"];
    [dict setValue:_deatilView.telTF.text forKey:@"Express_mobile"];
    //所在区域
    [dict setValue:_deatilView.nameTF.text forKey:@"Express_area"];
    [dict setValue:self.bulidID forKey:@"Express_build"];
    [dict setValue:self.houseID forKey:@"Express_floor"];
    [dict setValue:_deatilView.detailTF.text forKey:@"Express_address"];
    [dict setValue:self.typeID forKey:@"Express_type"];
    [dict setValue:self.destationID forKey:@"Express_destination"];
    [dict setValue:_deatilView.sayTF.text forKey:@"Express_note"];
    [dict setValue:self.transportID forKey:@"Express_transport"] ;
    //    "Agent":"华为","Created_ip":"127.0.0.1"
    [HttpService postWithServiceCode:SUB_EXPRESS params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        if ([resultDic validateOk]) {
            
            self.hidesBottomBarWhenPushed = YES;
            LogisticSuccessController *VC = [[LogisticSuccessController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else{
            
            [MBProgressHUD showError:[resultDic valueForKey:@"Message"]] ;
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVMessageHUD showInView:self.view status:@"服务器响应异常" afterDelay:1.5f] ;
    }];
    
}



-(void)buttonCLC:(UIButton *)sender
{
    [self.deatilView.nameTF  resignFirstResponder];
    [self.deatilView.telTF  resignFirstResponder];
    [self.deatilView.detailTF  resignFirstResponder];
    [self.deatilView.sayTF  resignFirstResponder];
    
    NSString * serviceCode = @"" ;
    NSString *title = @""  ;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    __weak LogisticsExpressViewController * weakSelf = self ;
    NSMutableArray * arr = nil;
    
    UIButton * btn = (UIButton *)[self.deatilView viewWithTag:sender.tag] ;
    if (sender.tag ==100||sender.tag ==1000||sender.tag ==101||sender.tag==1001) {
        if (sender.tag == 100||sender.tag ==1000) {
            serviceCode = GET_BUILD ;
            title = @"请选择快递楼宇" ;
            [dict setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"];
            [SVMessageHUD showInView:self.view  status:@"加载中..."] ;
            [HttpService postWithServiceCode:serviceCode params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
                NSDictionary * resultDic = (NSDictionary *)jsonObj ;
                if ([resultDic validateOk]) {
                    [SVMessageHUD dismiss] ;
                    if (self.buildArr.count > 0) {
                        [self.buildArr removeAllObjects];
                    }
                    for (NSDictionary * dic in resultDic[@"Data"]) {
                        LogisticBuildModel * model = [LogisticBuildModel modelWithDic:dic] ;
                        [self.buildArr addObject:model];
                    }
                    HBCustomActionSheetView * buildView = [[HBCustomActionSheetView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20)
                                                                                               andtitle:title andData:weakSelf.buildArr andBuildingPickControllrtBlock:^(NSString *building, NSString *spaceid) {
                                                                                                   [weakSelf.deatilView.buildBtn setTitle:building forState:UIControlStateNormal];
                                                                                                   self.buildname = building ;
                                                                                                   self.bulidID = spaceid ;
                                                                                                   
                                                                                               }];
                    
                    [buildView show];
                    
                }else{
                    [SVMessageHUD dismiss] ;
                    [SVMessageHUD showInView:self.view status:resultDic[@"Message"] afterDelay:1.5f] ;
                }
                
            } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [SVMessageHUD showInView:self.view status:@"服务器请求异常" afterDelay:1.5f] ;
            }];
        }else{
            if ([self.buildname isEqualToString:@""] ||self.buildname==nil||self.bulidID==nil||[self.bulidID isEqualToString:@""]) {
                [SVMessageHUD showInView:self.view status:@"请先选择快递楼宇" afterDelay:1.5f] ;
                return ;
            }
            [SVMessageHUD showInView:self.view  status:@"加载中..."] ;

            title = @"请选择快递楼层" ;
            [dict setValue:self.bulidID  forKey:@"space_id"];
            [HttpService postWithServiceCode:GET_Floor params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
                NSDictionary * resultDic = (NSDictionary *)jsonObj ;
                [SVMessageHUD dismiss] ;
                if ([resultDic validateOk]) {
                    if (self.houseArr.count > 0) {
                        [self.houseArr removeAllObjects];
                    }
                   
                    for (NSDictionary * dic in resultDic[@"Data"]) {
                        LogisticBuildModel * model = [LogisticBuildModel modelWithDic:dic] ;
                        [self.houseArr addObject:model];
                    }
                    if (self.houseArr==nil||self.houseArr.count ==0) {
                        [SVMessageHUD showInView:self.view status:@"无法查询到具体信息" afterDelay:1.5f] ;
                    }
                    
                    HBCustomActionSheetView * buildView = [[HBCustomActionSheetView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andtitle:title  andData:weakSelf.houseArr andBuildingPickControllrtBlock:^(NSString *building, NSString *spaceid) {
                        if (sender.tag <1000) {
                            if (building == nil) {
                                building = @"无法找到具体楼层信息" ;
                            }
                            [btn setTitle:building forState:UIControlStateNormal];
                        }
                        if (sender.tag<101) {
                            self.buildname = building ;
                            self.bulidID = spaceid ;
                        }else{
                            self.housename = building ;
                            self.houseID = spaceid ;
                        }
                    }];
                    
                    
                    [buildView show];
                }else{
                    [SVMessageHUD dismiss] ;
                    [SVMessageHUD showInView:self.view status:resultDic[@"Message"] afterDelay:1.5f] ;
                 }
            } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [SVMessageHUD dismiss] ;
                 [SVMessageHUD showInView:self.view status:@"服务器请求异常" afterDelay:1.5f] ;
            }];
        }
    }else{
        
        if (sender.tag == 102 ||sender.tag ==1002){
            arr = [NSMutableArray arrayWithArray:self.typeArr] ;
            title = @"请选择快递类别" ;
        }else if(sender.tag == 103 ||sender.tag ==1003){
            
            arr = [NSMutableArray arrayWithArray:self.destArr] ;
            title = @"请选择快递目的地" ;
        }else{
            arr = [NSMutableArray arrayWithArray:self.transArr] ;
            title = @"请选择快递方式" ;
        }
        HBCustomActionSheetView * typeView = [[HBCustomActionSheetView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andTitle:title andData:arr andPostClassActionSheetBlock:^(NSString *postclass, NSString *postid) {
            if (sender.tag <1000) {
                [btn setTitle:postclass forState:UIControlStateNormal];
            }
            if (sender.tag ==102||sender.tag==1002) {
                self.typeID = postid ;
                self.typename = postclass ;
            }else if(sender.tag ==103||sender.tag==1003){
                self.destationame = postclass ;
                self.destationID = postid ;
            }else{
                self.transportName = postclass ;
                self.transportID = postid ;
                
            }
            
        }];
        
        [typeView show];
    }
}

#pragma mark ------------------textViewDidChange--------------
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.deatilView.detailTF) {
        self.deatilView.placeLab.hidden = self.deatilView.detailTF.text.length ;
        
        
    }else if (textView == self.deatilView.sayTF){
        
        self.deatilView.saylab.hidden = self.deatilView.sayTF.text.length ;
    }else{
        
    }
    static CGFloat maxHeight =60.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    

}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.deatilView.nameTF isExclusiveTouch]) {
        [self.deatilView.nameTF  resignFirstResponder];
    }
    if (![self.deatilView.telTF isExclusiveTouch]) {
        [self.deatilView.telTF  resignFirstResponder];
    }
    if (![self.deatilView.detailTF isExclusiveTouch]) {
        [self.deatilView.detailTF  resignFirstResponder];
    }
    if (![self.deatilView.sayTF isExclusiveTouch]) {
        [self.deatilView.sayTF  resignFirstResponder];
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
