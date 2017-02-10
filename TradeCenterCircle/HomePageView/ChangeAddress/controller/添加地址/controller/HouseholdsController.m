//
//  HouseholdsController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "HouseholdsController.h"
#import "PhotoPickerUtil.h"


@interface HouseholdsController ()

@property(nonatomic,weak)UIView *noticesView;
//间距
@property(nonatomic,assign)CGFloat margin;
//通知高度
@property(nonatomic,assign)CGFloat noticeHeight;
//字体
@property(nonatomic,assign)CGFloat fontSize;

//身份证等
@property(nonatomic,weak)UIButton *IdCardBtn;

//房屋证明
@property(nonatomic,weak)UIButton *houseBtn;

@property(nonatomic,assign)BOOL isClickIdCardBtn;

@property(nonatomic,assign)BOOL isClickHouseBtn;

@end

@implementation HouseholdsController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated] ;
    self.tabBarController.tabBar.hidden = YES ;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"提交身份信息"];
    [self createNavigationRightBarButtonWithTitle:@"提交" andTitleColor:[UIColor whiteColor]] ;
    self.margin = 20;
    self.noticeHeight = 80;
    [self creatUI];

}

-(void)creatUI
{
    [self noticeView];
    [self IdCardView];
}
-(void)IdCardView
{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.frame = CGRectMake(Origin_x, CGRectGetMaxY(self.noticesView.frame)+2*self.margin, VIEW_W(self.view), 2*self.noticeHeight);
    bgView.image = [UIImage imageNamed:@"dizhi_bg"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    
    UIButton *idCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat idBtnH = 3*self.noticeHeight/2 - 2*self.margin;
    idCardBtn.frame = CGRectMake(self.margin, self.margin*2, idBtnH, idBtnH);
    [idCardBtn setBackgroundImage:[UIImage imageNamed:@"dengji_shangchuanzhengjain"] forState:UIControlStateNormal];
    [idCardBtn addTarget:self action:@selector(cilckIdCardBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.IdCardBtn = idCardBtn;
    [bgView addSubview:idCardBtn];
    
    UILabel *idCardLab = [[UILabel alloc]init];
    idCardLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Minecell_title_size]];
    idCardLab.text = @"请上传或拍摄您的身份证件，如身份证、社保卡、护照、驾驶证照等的照片。";
    CGSize idCardSize = [self sizeWithText:idCardLab.text WithFont:idCardLab.font WithMaxSize:CGSizeMake(VIEW_W(self.view)- (VIEW_BX(idCardBtn)+self.margin)- self.margin, MAXFLOAT)];
    idCardLab.frame = CGRectMake(VIEW_BX(idCardBtn)+self.margin, VIEW_TY(idCardBtn), idCardSize.width, idCardSize.height);
    idCardLab.textColor = [UIColor blackColor];
    idCardLab.numberOfLines = 0;
    [bgView addSubview:idCardLab];
    
}
-(void)noticeView
{
    UIView *noticeView = [[UIView alloc]init];
    noticeView.backgroundColor = [UIColor whiteColor];
    noticeView.frame = CGRectMake(Origin_x, self.margin+NaviBarHeight, VIEW_W(self.view), self.noticeHeight);
    self.noticesView = noticeView;
    [self.view addSubview:noticeView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_xianshangdengji"];
    CGFloat imageY = (self.noticeHeight - imageView.image.size.height)/2;
    imageView.frame = CGRectMake(self.margin, imageY,imageView.image.size.width,imageView.image.size.height);
    [noticeView addSubview:imageView];
    
    UILabel *mesLabel = [[UILabel alloc]init];
    mesLabel.text = @"我们会根据您上传的资料，在两个工作日内核实您的住户身份。";
    mesLabel.frame = CGRectMake(VIEW_BX(imageView)+self.margin, self.margin/2, VIEW_W(self.view)- (VIEW_BX(imageView)+self.margin)- self.margin, self.noticeHeight - self.margin);
    mesLabel.textColor = [UIColor blackColor];
    mesLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Minecell_title_size]];
    mesLabel.numberOfLines = 0;
    [noticeView addSubview:mesLabel];
    
    
}
-(void)rightBarButtonPress
{
    NSString *mes = @"";
    
    if (!self.isClickIdCardBtn) {
        
        mes = @"请上传或拍摄您的身份证件，如身份证、社保卡、护照、驾驶证照等的照片。";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:mes delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    UIImage *IdCardImage = self.IdCardBtn.currentBackgroundImage;
    
    //发送网络请求
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    [imageArray addObject:IdCardImage];
    //      [imageArray addObject:houseImage];
    
    NSDictionary *dictParam = [[NSDictionary alloc]init];
    dictParam = @{@"User_id":[USER_DEFAULT objectForKey:kUserId],kCommunityId:self.community_id,kSpace_id:self.space_id};
    
    [SVProgressHUD showInView:self.view status:@"正在提交"];
      [HttpService filePostWithServiceCode:kUser_Community_Valid params:dictParam andImageDatas:imageArray success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;
        [SVProgressHUD dismiss];
          //新增改变当前小区的状态
        if ([dict validateOk]) {
            
            NSString * Community_id = dict[@"Data"][@"Community_id"] ;
            NSString * Community_name = dict[@"Data"][@"Community_name"] ;
            NSString * Community_status = dict[@"Data"][@"Community_status"] ;
            NSString * Community_valid_status = dict[@"Data"][@"Community_valid_status"] ;
            NSString * Address_valid_status = dict[@"Data"][@"Address_valid_status"] ;
            NSString * Space_id = dict[@"Data"][@"Space_id"] ;
            NSString * Space_name = dict[@"Data"][@"Space_name"] ;
            [USER_DEFAULT setObject:Community_id forKey:kCommunityId] ;
            [USER_DEFAULT setObject:Community_name forKey:kCommunity_name] ;
            [USER_DEFAULT setObject:Community_status forKey:kCommunity_status] ;
            [USER_DEFAULT setObject:Community_valid_status forKey:kCommunity_valid_status] ;
            [USER_DEFAULT setObject:Address_valid_status forKey:kAddress_valid_status] ;
            [USER_DEFAULT setObject:Space_id forKey:kSpace_id] ;
            [USER_DEFAULT setObject:Space_name forKey:kSpace_name] ;
            [MBProgressHUD showSuccess:@"提交成功"];
            

            if (self.isGoBtn) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
//                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationReloDataHome object:nil userInfo:nil];
                self.tabBarController.tabBar.hidden = NO ;
                [USER_DEFAULT synchronize];
                 [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
        }else{
            NSString *mes = [dict objectForKey:@"Message"];
            [MBProgressHUD showError:mes];
        }
        
        
        
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD showError:@"服务器响应异常"];
    }];
}

-(void)cilckIdCardBtn:(UIButton *)btn
{
    PhotoPickerUtil *photoVc = [[PhotoPickerUtil alloc]init];
    [photoVc showImagePickController:self andFinishBlock:^(UIImage *image) {
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        self.isClickIdCardBtn = YES;
    }];
    
}

-(CGSize)sizeWithText:(NSString *)text WithFont:(UIFont *)font WithMaxSize:(CGSize )maxSize
{
    NSDictionary *attri = @{NSFontAttributeName :font};
    return  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
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
