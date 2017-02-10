//
//  MyInformationViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyInformationViewController.h"
#import "MyInfoView.h"
#import "HBCustomActionSheetView.h"
#import "MyInfoamtionModel.h"

@interface MyInformationViewController ()<UITextViewDelegate>

@property(nonatomic,strong) UIScrollView * mScrollview ;

@property(nonatomic,strong) MyInfoView * myInfomView ;

@property(nonatomic,strong) UIButton * submitBtn ;

@property(nonatomic,strong) NSMutableArray * sexArr ;
@property(nonatomic,copy) NSString * sexID ;
@property(nonatomic,strong) NSMutableArray * dataArr ;
@end

@implementation MyInformationViewController
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array] ;
    }
    return _dataArr ;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [ProgressHUD showUIBlockingIndicator];
    [self loadMessage] ;
    
}

-(void)loadMessage
{
    [ProgressHUD hideUIBlockingIndicator] ;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;

    [dict setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"] ;
    [HttpService postWithServiceCode:GET_USER_DETAIL params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        NSLog(@"ziliao%@",resultDic) ;
        if ([resultDic validateOk]) {
            [ProgressHUD hideUIBlockingIndicator] ;
            MyInfoamtionModel * model = [MyInfoamtionModel modelWithDic:resultDic[@"Data"]] ;
            self.myInfomView.telTF.text = model.User_mobile ;
            self.myInfomView.nameTF.text = model.User_name ;
            self.myInfomView.nichengLab.text = model.User_nickname ;
            self.myInfomView.perintroduceTV.text = model.User_interest ;
            if ([model.User_gender isEqualToString:@"1"]) {
                [self.myInfomView.sexChooseBtn setTitle:@"男" forState:UIControlStateNormal];
                self.sexID = @"1" ;
            }else if ([model.User_gender isEqualToString:@"2"]){
                self.sexID = @"2" ;
                [self.myInfomView.sexChooseBtn setTitle:@"女" forState:UIControlStateNormal];
            }
            else if([model.User_gender isEqualToString:@"3"]){
            [self.myInfomView.sexChooseBtn setTitle:@"不便透露" forState:UIControlStateNormal];
              self.sexID = @"3" ;
            }
            self.myInfomView.perintroLab.text = @"" ;
            
        }else{
        
            [ProgressHUD showActionWithMessage:resultDic[@"Message"] hiddenAffterDelay:1.5f];
        }
        
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD hideUIBlockingIndicator] ;
        [MBProgressHUD showError:@"服务器响应异常"] ;
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"我的资料"];
    _sexArr = [NSMutableArray array] ;
    NSDictionary * dic = @{@"sex":@"男",@"sexID":@"1"} ;
    NSDictionary * dic1= @{@"sex":@"女",@"sexID":@"2"} ;
    NSDictionary * dic2 = @{@"sex":@"不便透露",@"sexID":@"3"} ;
    self.view.backgroundColor = [UIColor whiteColor] ;
    [_sexArr addObject:dic] ;
    [_sexArr addObject:dic1] ;
    [_sexArr addObject:dic2] ;
    [self createUI] ;
}
-(void)createUI
{
    _mScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _mScrollview.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT*1.5) ;
    _mScrollview.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    _mScrollview.showsHorizontalScrollIndicator = NO ;
    [self.view addSubview:_mScrollview ];
    _myInfomView = [[MyInfoView alloc]initWithFrame:CGRectMake(0, StatusBar_Height+TABBAR_HEIGHT, VIEW_W(self.view), 370*SCREENHEIGHT/667)];
    [_myInfomView.sexBtn addTarget:self action:@selector(sexBtnCLC:) forControlEvents:UIControlEventTouchUpInside];
    [_myInfomView.sexChooseBtn addTarget:self action:@selector(sexBtnCLC:) forControlEvents:(UIControlEventTouchUpInside)] ;
    [_mScrollview addSubview:_myInfomView] ;
    _myInfomView.perintroduceTV.delegate =self ;
//    [_myInfomView.submitBtn addTarget:self action:@selector(myinfoBtnClC:) forControlEvents:UIControlEventTouchUpInside] ;
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(12*SCREENWIDTH/375,VIEW_BY(_myInfomView)-50*SCREENHEIGHT/667, VIEW_W(self.view)-24*SCREENWIDTH/375, 44*SCREENHEIGHT/667) andTitle:@"提交" andBackgroundImage:@""] ;
    [_submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#fc5056"] ];
    _submitBtn.layer.cornerRadius = 2 ;
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_submitBtn addTarget:self action:@selector(myinfoBtnClC:) forControlEvents:UIControlEventTouchUpInside] ;
    [_mScrollview addSubview:_submitBtn] ;

    [_mScrollview setContentSize:CGSizeMake(VIEW_W(self.view), VIEW_H(self.view)+10)];

}



-(void)myinfoBtnClC:(UIButton *)sender
{
    if (_myInfomView.telTF.text ==nil ||[_myInfomView.telTF.text isEqualToString:@""]) {
        [SVMessageHUD showInView:self.view status:@"请输入您的手机号" afterDelay:1.5f];
        return ;
    }else if (![RegularExpression checkTelNumber:_myInfomView.telTF.text]){
        [SVMessageHUD showInView:self.view status:@"请输入正确的手机号" afterDelay:1.5f] ;
        return ;
    }
    
    else if (_myInfomView.nameTF.text ==nil ||[_myInfomView.nameTF.text isEqualToString:@""]){
        [SVMessageHUD showInView:self.view status:@"请输入您的姓名" afterDelay:1.5f] ;
        return ;
    }
    else if (_myInfomView.perintroduceTV.text==nil|| [_myInfomView.perintroduceTV.text isEqualToString:@""]){
        
        [SVMessageHUD showInView:self.view  status:@"请简单介绍一下自己吧" afterDelay:1.5f];
        return ;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    [dict setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"] ;
    [dict setValue:_myInfomView.nameTF.text forKey:@"User_realname"];
    [dict setValue:_myInfomView.nichengLab.text forKey:@"User_nickname"] ;
    [dict setValue:self.sexID forKey:@"User_sex"] ;
    [dict setValue:_myInfomView.perintroduceTV.text forKey:@"User_desc"] ;
    [HttpService postWithServiceCode:SUB_USER_DETAIL params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        if ([resultDic validateOk]) {
            [MBProgressHUD showSuccess:@"资料修改成功"] ;
            [self popVC] ;
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"服务器响应异常"] ;
    }];
    
    
}
#pragma -选择性别的点击方法
-(void)sexBtnCLC:(UIButton *)sender
{
//    UIButton * btn = (UIButton *)[self.myInfomView viewWithTag:sender.tag] ;
    HBCustomActionSheetView *sexview= [[HBCustomActionSheetView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:_sexArr andSexActionSheetBlock:^(NSString *SEX, NSString *SEXID) {
        
//        if (sender.tag <1000) {
            [self.myInfomView.sexChooseBtn setTitle:SEX forState:UIControlStateNormal] ;
//        }
        self.sexID = SEXID ;
        
    }];
    [sexview show];
    
}



#pragma mark ------------------textViewDidChange--------------
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.myInfomView.perintroduceTV) {
        self.myInfomView.perintroLab.hidden = self.myInfomView.perintroduceTV.text.length ;
    }
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
