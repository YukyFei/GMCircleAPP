//
//  MyAddressADDController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/19.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyAddressADDController.h"
#import "MyAddressADDView.h"
#import "HBCustomActionSheetView.h"
#import "LogisticBuildModel.h"
#import "MyAddressdetailModel.h"

@interface MyAddressADDController ()<UITextViewDelegate>

@property(nonatomic,strong) MyAddressADDView * addView ;
@property(nonatomic,strong) UIButton * submitBtn ;
@property(nonatomic,strong) NSMutableArray * dataArray ;
@property(nonatomic,strong) NSMutableArray * buildArr ;
@property(nonatomic,strong) NSMutableArray * houseArr ;
@property(nonatomic,strong) NSString *buildname ;

@property(nonatomic,copy) NSString * bulidID ;
@property(nonatomic,copy) NSString * housename ;
@property(nonatomic,copy) NSString * houseID ;

@end

@implementation MyAddressADDController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI] ;
    self.view.backgroundColor = [UIColor whiteColor] ;
    if (_isFromUpdate ==YES) {
        self.addView.postlab.text = @"编辑地址" ;
        
    }else{
        self.addView.postlab.text = @"添加地址" ;
        [self datainput] ;
    }
    
    [self setNaviBarTitle:@"我的地址"];
}

-(void)createUI
{
    
    _addView = [[MyAddressADDView alloc]initWithFrame:CGRectMake(0,  StatusBar_Height+TABBAR_HEIGHT, VIEW_W(self.view), VIEW_H(self.view)*3/4)];
    [self.view addSubview:_addView];
    [_addView.buildBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside];
    [_addView.buiBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside];
    [_addView.floorBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    [_addView.flrBtn addTarget:self action:@selector(buttonCLC:) forControlEvents:UIControlEventTouchUpInside] ;
    self.addView.detailTF.delegate = self ;
    _addView.buiBtn .enabled = NO ;
    _addView.flrBtn .enabled = NO ;
    _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, VIEW_BY(_addView), VIEW_W(self.view)-20*SCREENWIDTH/375, 40*SCREENHEIGHT/667)];
    [_submitBtn setBackgroundColor:[UIColor redColor] ];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    [self.submitBtn addTarget:self action:@selector(submitBtnClC:) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:self.submitBtn];
    
}
/**
 * 获取已有信息
 */
-(void)datainput
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    //  {"User_id":"37F92C4E-64DD-7EC7-DBA6-B8496824864D","Address_id":"8E1A9FC8-EA0B-4EAC-9497-5BE4DF3766B5"}
//    [dict setValue:@"37F92C4E-64DD-7EC7-DBA6-B8496824864D" forKey:@"User_id"] ;
    [dict setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"] ;
    [dict setValue:self.addressId forKey:@"Address_id"] ;
    [HttpService postWithServiceCode:GET_ADRESS_DETAIL params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *) jsonObj ;
        if ([resultDic validateOk]) {
            
            MyAddressdetailModel * model = [MyAddressdetailModel modelWithDic:jsonObj[@"Data"]] ;
            _addView.nameTF.text = model.User_name ;
            _addView.telTF.text = model.User_mobile ;
            [_addView.buildBtn setTitle:model.build_name forState:UIControlStateNormal];
            [_addView.floorBtn setTitle:model.floor_name forState:UIControlStateNormal] ;
            _addView.detailTF.text = model.User_address ;
            [self.dataArray addObject:model];
            self.bulidID = model.User_bulid;
            self.houseID = model.User_floor ;
            self.buildname = model.build_name ;
            self.housename = model.floor_name ;
            self.addView.placeLab.text = nil ;
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
//获取楼宇名楼栋名
-(void)getBuildMessageWithDic:(NSMutableDictionary *)dic
{
    
    
}


#pragma mark - 提交按钮的点击事件
-(void)submitBtnClC:(UIButton *)sender
{
    if (_addView.nameTF.text ==nil||[_addView.nameTF.text isEqualToString:@""]) {
        [SVMessageHUD showInView:self.view  status:@"请填写您的姓名" afterDelay:1.5f] ;
        return ;
    }else if (_addView.telTF.text ==nil||[_addView.telTF.text isEqualToString:@""]){
        [SVMessageHUD showInView:self.view status:@"请填写您的手机号" afterDelay:1.5f] ;
        return ;
    }else if (![RegularExpression checkTelNumber:_addView.telTF.text]){
        
        [SVMessageHUD showInView:self.view status:@"请填写正确的手机号" afterDelay:1.5f] ;
        return ;
    }else if (_addView.detailTF.text.length == 0||[_addView.telTF.text isEqualToString:@""]){
        [SVMessageHUD showInView:self.view  status:@"请填写详细地址" afterDelay:1.5f];
        return ;
    }else if (self.buildname==nil ||[self.buildname isEqualToString:@""]||self.bulidID==nil ||[self.bulidID isEqualToString:@""]){
        [SVMessageHUD showInView:self.view  status:@"请选择地址所在楼宇" afterDelay:1.5f];
        return ;
    }else if (self.housename==nil ||[self.housename isEqualToString:@""]||self.houseID==nil ||[self.houseID isEqualToString:@""]){
        [SVMessageHUD showInView:self.view  status:@"请选择地址所在楼层" afterDelay:1.5f];
        return ;
    }
    //    {"User_id":"User_id","User_name":"yonghuming","User_mobile":"15112345678","User_area":"qqqq","User_bulid":"56E39D44-94F5-4399-911E-99549E5DDFD0","User_floor":"17C24A2F-7E8A-4167-84D9-46E325FBA8FD","User_address":"详细地址"}
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init] ;
    //    "User_id":"1CBE77CC-FE2E-61A6-5D5D-E858CC7C4ED2"
   [dict setValue:[USER_DEFAULT objectForKey:kUserId] forKey:@"User_id"] ;
    [dict setValue:_addView.nameTF.text forKey:@"User_name"];
    [dict setValue:_addView.telTF.text forKey:@"User_mobile"];
    //所在区域
    [dict setValue:_addView.nameTF.text forKey:@"User_area"];
    [dict setValue:self.bulidID forKey:@"User_bulid"];
    [dict setValue:self.houseID forKey:@"User_floor"];
    [dict setValue:_addView.detailTF.text forKey:@"User_address"];
    [HttpService postWithServiceCode:SUB_ADDRESS params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * resultDic = (NSDictionary *)jsonObj ;
        if ([resultDic validateOk]) {
            [MBProgressHUD showSuccess:@"添加成功"] ;
            [self popVC];
        }else{
            
            [MBProgressHUD showError:[resultDic valueForKey:@"Message"]] ;
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVMessageHUD showInView:self.view status:@"服务器响应异常" afterDelay:1.5f] ;
    }];
    
}

-(void)buttonCLC:(UIButton *)sender
{
     [self.view endEditing:YES];
    NSString * serviceCode = @"" ;
    NSString * title = @"" ;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary] ;
    __weak MyAddressADDController * weakSelf = self ;
    NSMutableArray * arr = nil;
    
    UIButton * btn = (UIButton *)[self.addView viewWithTag:sender.tag] ;
    if (sender.tag == 100) {
        serviceCode = GET_BUILD ;
        title = @"请选择具体楼宇" ;
        //            {"Community_id":"29EE15D3-1ADD-4C9E-A77A-EE629046F406"}
//        [dict setValue:@"29EE15D3-1ADD-4C9E-A77A-EE629046F406" forKey:@"Community_id"];
        [dict setValue:[USER_DEFAULT objectForKey:kCommunityId] forKey:@"Community_id"] ;

        [SVProgressHUD showInView:self.view status:@"加载中..."];
        [HttpService postWithServiceCode:serviceCode params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
            NSDictionary * resultDic = (NSDictionary *)jsonObj ;
            if ([resultDic validateOk]) {
                [SVProgressHUD dismiss] ;
                if (self.buildArr.count > 0) {
                    [self.buildArr removeAllObjects];
                }
                for (NSDictionary * dic in resultDic[@"Data"]) {
                    LogisticBuildModel * model = [LogisticBuildModel modelWithDic:dic] ;
                    [self.buildArr addObject:model];
                }
                HBCustomActionSheetView * buildView = [[HBCustomActionSheetView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20)  andtitle:title  andData:weakSelf.buildArr andBuildingPickControllrtBlock:^(NSString *building, NSString *spaceid) {
                    [weakSelf.addView.buildBtn setTitle:building forState:UIControlStateNormal];
                    self.buildname = building ;
                    self.bulidID = spaceid ;
                    
                }];
                
                [buildView show];
                [self.addView.floorBtn setTitle:@"请选择" forState:UIControlStateNormal];
                self.housename = @"" ;
                self.houseID = @"" ;
                
            }else{
                [ProgressHUD hideUIBlockingIndicator] ;
                [ProgressHUD showActionWithMessage:resultDic[@"Message"] hiddenAffterDelay:1.5f];
            }
            
        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ProgressHUD hideUIBlockingIndicator] ;
            [ProgressHUD showActionSheetViewMeg:@"服务器请求异常" hideAffterDelay:1.5f];
        }];
    }else if(sender.tag == 101) {
        if ([self.buildname isEqualToString:@""] ||self.buildname==nil||self.bulidID==nil||[self.bulidID isEqualToString:@""]) {
            [SVMessageHUD showInView:self.view status:@"请先选择快递楼宇" afterDelay:1.5f] ;
            return ;
        }
        title = @"请选择具体楼层" ;
        [SVProgressHUD showInView:self.view status:@"加载中..."];

        [dict setValue:self.bulidID  forKey:@"space_id"];
        [HttpService postWithServiceCode:GET_Floor params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
            NSDictionary * resultDic = (NSDictionary *)jsonObj ;
            [SVProgressHUD dismiss] ;
            if ([resultDic validateOk]) {
                [ProgressHUD hideUIBlockingIndicator] ;
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
                        if (building ==nil||[building isEqualToString:@""]) {
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
                [ProgressHUD hideUIBlockingIndicator] ;
                [ProgressHUD showActionWithMessage:resultDic[@"Message"] hiddenAffterDelay:1.5f];
            }
        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ProgressHUD hideUIBlockingIndicator] ;
            [ProgressHUD showActionSheetViewMeg:@"服务器请求异常" hideAffterDelay:1.5f];
        }];
    }
    
}

#pragma mark ------------------textViewDidChange--------------
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.addView.detailTF) {
        self.addView.placeLab.hidden = self.addView.detailTF.text.length ;
    }else if (textView == self.addView.sayTF){
        
        self.addView.saylab.hidden = self.addView.sayTF.text.length ;
    }else{
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
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
