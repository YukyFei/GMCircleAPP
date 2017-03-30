//
//  LoginViewController.m
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "LoginViewController.h"
#import "UMessage.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNaviback:YES];
    [self setNaviBarTitle:@"手机登录"];
      self.view.backgroundColor = [UIColor whiteColor] ;
    [self createUI];
}

-(void)createUI
{
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH - 183)/2, 64 + 64, 183, 61)];
    logoImage.image = [UIImage imageNamed:@"login_logo"];
    [self.view addSubview:logoImage];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"手机登录";
    titleLab.frame = CGRectMake(20, logoImage.bottom + 23, 200,[self lableTextHeightWithSting:titleLab.text and:16.0].height);
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Login_title_size]];
    titleLab.textColor = [UIColor grayColor];
    [self.view addSubview:titleLab];
    
    for (int i = 0; i< 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLab.bottom + 20 + i*63, SCREENWIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
        [self.view addSubview:lineView];
    }
    
    UITextField *_userNameTf=[[UITextField alloc] initWithFrame:CGRectMake(20, titleLab.bottom + 20.5,VIEW_W(self.view)-40, 62.5)];
    _userNameTf.borderStyle=UITextBorderStyleNone;
    _userNameTf.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_UserPassword_title_size]];
    _userNameTf.placeholder = @"请输入手机号码";
    _userNameTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _userNameTf.tag = 100;
    
    //设置数字键盘
    _userNameTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_userNameTf];

    UITextField *_passwordTf=[[UITextField alloc]initWithFrame:CGRectMake(20, VIEW_BY(_userNameTf), VIEW_W(self.view)-40, 62.5)];
    _passwordTf.borderStyle=UITextBorderStyleNone;
    _passwordTf.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_UserPassword_title_size]];
    _passwordTf.placeholder = @"短信验证码";
    _passwordTf.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTf.tag = 200;
    [self.view addSubview:_passwordTf];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 100, titleLab.bottom + 20.5, 0.5, 62)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [self.view addSubview:lineView];
    
    //发送验证码
    UIButton *_getBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 100, titleLab.bottom + 20.5,100, 62)];
    _getBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [_getBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"#f5f5f5"]] forState:UIControlStateHighlighted] ;
    [_getBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal] ;
    [_getBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_getBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_getBtn addTarget:self action:@selector(getbutton:) forControlEvents:UIControlEventTouchUpInside];
    _getBtn.tag = 300;
    [self.view addSubview:_getBtn];
    
    //登录
    UIButton *  _registBtn = [ButtonControl creatButtonWithFrame:CGRectMake(20, _passwordTf.bottom + 48, SCREENWIDTH-40, 44) Text:nil ImageName:nil bgImageName:nil Target:self Action:@selector(registClick)];
    [_registBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_registBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"#a6873b"]] forState:UIControlStateNormal] ;
    [_registBtn setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted] ;
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registBtn.titleLabel.font=[UIFont systemFontOfSize:18.0];
    _registBtn.layer.cornerRadius = 2.0;

    [self.view addSubview:_registBtn];
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) startTime{
    
    UIButton *_getBtn = (UIButton *)[self.view viewWithTag:300];
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_getBtn setTitle:@"发送验证码"  forState:UIControlStateNormal];
                
                _getBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                // NSLog(@"____%@",strTime);
                if (seconds ==00) {
                    [_getBtn setTitle:[NSString stringWithFormat:@"60秒"] forState:UIControlStateNormal];
                }else
                {
                    [_getBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                }
                
                _getBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

//发送验证码
- (void) getbutton:(UIButton *)button
{
    UITextField *_userNameTf = (UITextField *)[self.view viewWithTag:100];
    
    [_userNameTf resignFirstResponder];
    if (_userNameTf==nil||_userNameTf.text.length==0) {
        [SVMessageHUD showInView:self.view status:@"手机号不能为空" afterDelay:1.0];
        return;
    }
    
    if (![RegularExpression checkTelNumber:_userNameTf.text]) {
        [SVMessageHUD showInView:self.view status:@"请输入正确的手机号码" afterDelay:1.0];
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:_userNameTf.text forKey:@"Mobile"];
    
    [HttpService postWithServiceCode:kUserGetCode params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            [MBProgressHUD showSuccess:@"验证码已发送"];
            [self startTime];
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
     
        
        NSLog(@"网络请求失败%@",error) ;
    }];
}

//提交
-(void)registClick
{
    UITextField *_userNameTf = (UITextField *)[self.view viewWithTag:100];
    UITextField *_passwordTf = (UITextField *)[self.view viewWithTag:200];
    
    if (_userNameTf==nil||_userNameTf.text.length==0) {
        [SVMessageHUD showInView:self.view status:@"手机号不能为空" afterDelay:1.0];
        return;
    }
    
    if (![RegularExpression checkTelNumber:_userNameTf.text]) {
        [SVMessageHUD showInView:self.view status:@"请输入正确的手机号码" afterDelay:1.0];
        return;
    }
    if (_passwordTf==nil||_passwordTf.text.length==0) {
        [SVMessageHUD showInView:self.view status:@"请输入验证码" afterDelay:1.0];
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:_userNameTf.text forKey:@"Mobile"];
    [dic setValue:_passwordTf.text forKey:@"Code"];
    //增加APP字段判断登录的APP地址
    [dic setValue:@"gmq" forKey:@"App_name"] ;
    [HttpService postWithServiceCode:kUserValidCode params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dicresult = (NSDictionary *)jsonObj;
        NSDictionary *dic = [dicresult objectForKey:@"Data"];
        
        if ([dicresult validateOk]) {
            [MBProgressHUD showSuccess:@"登录成功"];
            
            NSString *login_refresh_token=[dic objectForKey:kLoginRefreshToken];
            NSString *login_token=[dic objectForKey:kLoginToken];
            NSString *token_expire = [dic objectForKey:kTokenExpire];
            NSString *user_id = [dic objectForKey:kUserId];
            NSString *Community_id = [dic objectForKey:kCommunityId];
            NSString * Community_name = [dic objectForKey:kCommunity_name] ;
            NSString *User_Space_State = [NSString stringWithFormat:@"%@",[dic objectForKey:kUser_Space_State]];
            NSString * space_id = [dic objectForKey:@"space_id"] ;
            NSString * space_name = [dic objectForKey:@"space_name"] ;
            NSString * Address_valid_status = [dic objectForKey:@"Address_valid_status"] ;
            NSString * community_status = [dic objectForKey:@"community_status"] ;
            //发送devicetoken修改
            [self upLoadDeviceTokenUserid:user_id] ;
            //上一用户的userid
             NSString *oldUser_id = [USER_DEFAULT objectForKey:kUserId];
//            if (![oldUser_id isEqualToString:user_id]) {
             //如果两次用户账号不同删除用户在本地存储的所有信息
                NSString*appDomain = [[NSBundle mainBundle] bundleIdentifier];
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//            }
            if (space_id!=nil) {
                [USER_DEFAULT setObject:space_id forKey:kSpace_id];
            }
            if (space_name != nil) {
                [USER_DEFAULT setObject:space_name forKey:kSpace_name];
            }
            if (Address_valid_status != nil) {
                [USER_DEFAULT setObject:Address_valid_status forKey:kAddress_valid_status];
            }
            if (community_status != nil) {
                [USER_DEFAULT setObject:community_status forKey:kCommunity_status];
            }
            
            [USER_DEFAULT setObject:User_Space_State forKey:kUser_Space_State];
            [USER_DEFAULT setObject:login_refresh_token forKey:kLoginRefreshToken];
            [USER_DEFAULT setObject:login_token forKey:kLoginToken];
            [USER_DEFAULT setObject:token_expire forKey:kTokenExpire];
            [USER_DEFAULT setObject:user_id forKey:kUserId];
            [USER_DEFAULT setObject:Community_id forKey:kCommunityId];
            [USER_DEFAULT setObject:Community_name forKey:kCommunity_name] ;
            [USER_DEFAULT setObject:_userNameTf.text forKey:kPhoneNum];
            [USER_DEFAULT setBool:YES forKey:kLoginSuccess];
            
            [USER_DEFAULT synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationSwitchHome object:nil userInfo:nil];

            //添加别名
            [UMessage addAlias:user_id type:@"user_id" response:^(id responseObject, NSError *error) {

            }];
            
#pragma mark 登录成功后，开始蓝牙扫描
            AppDelegate * delegate = [AppDelegate sharedInstance];
            
            for (NSDictionary *dict in delegate.phoneNum_cardNum) {
                
                if ([dict objectForKey:_userNameTf.text]) {
                    
//                    delegate.openDoorTool.cardNum = [dict objectForKey:_userNameTf.text];
                    NSString * cardNum = [dict objectForKey:_userNameTf.text];
                    
                    [USER_DEFAULT setObject:cardNum forKey:@"User_CardNum"];
                    [USER_DEFAULT synchronize];
                    
                    break;
                }
            }

            
//            NSDictionary * dict = [delegate.phoneNumAndCardNum objectAtIndex:0];
//            
//            for (NSDictionary * tmp in dict) {
//                
//                [USER_DEFAULT setObject:[tmp objectForKey:_userNameTf] forKey:@"User_CardNum"];
//            }
            
            if([USER_DEFAULT objectForKey:@"User_CardNum"] == nil)
            {
                [SVProgressHUD dismissWithError:@"没有找到当前用户的卡号，设置默认测试账号111111" afterDelay:3.0];
                [USER_DEFAULT setObject:@"111111" forKey:@"User_CardNum"];
                [USER_DEFAULT synchronize];
            }
            BOOL isStartOpenDoor = [delegate bluetoothStartOpenDoor];
            if (isStartOpenDoor) {
                
                NSLog(@"登录成功，开门操作开启");
            }
            
        }else{
            if ([[dicresult objectForKey:@"Status"] isEqualToString:@"error"]) {
                [SVMessageHUD showInView:self.view status:@"手机号或验证码输入有误" afterDelay:1.0];
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        NSLog(@"网络请求失败%@",error) ;
        
    }];
}

/*上传deviceToken到服务器端*/
-(void)upLoadDeviceTokenUserid:(NSString *)userid
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[USER_DEFAULT objectForKey:kDevice_Token] forKey:@"device_token"];
    NSLog(@"%@",[USER_DEFAULT objectForKey:kDevice_Token]) ;
    [dic setValue:UmengAppkey forKey:@"plat_form"];
    [dic setValue:userid forKey:@"User_id"];
    
    //设置设备号
    [HttpService postWithServiceCode:kSetDeviceToken params:dic success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary * dicresult = (NSDictionary *)jsonObj;
        
        if ([dicresult validateOk]) {
            NSLog(@"发送devicetoken到服务器===%@",dicresult);
            
        }else{
            if ([[dicresult objectForKey:@"Message"] isEqualToString:@"not more data"]) {
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (CGSize )lableTextHeightWithSting:(NSString*)text and:(CGFloat)size
{
    CGSize oldSize = CGSizeMake(SCREENWIDTH-20, 999);
    CGSize user_newSize;
    user_newSize = [text boundingRectWithSize:oldSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return user_newSize;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationSwitchHome object:nil];
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
