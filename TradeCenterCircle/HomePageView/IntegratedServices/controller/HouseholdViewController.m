//
//  HouseholdViewController.m
//  TradeCenterCircle
//
//  Created by 张广义 on 2016/11/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//
#import "HouseholdViewController.h"
#import "BaoShiViewController.h"
#import "HttpService.h"
#import "GYCustomActionSheetView.h"
#import "HouseholdsController.h"
#import "HBCustomActionSheetView.h"
@interface HouseholdViewController ()<UITextViewDelegate>

@property(nonatomic,weak)UIView *noticesView;
@property(nonatomic,weak)UIImageView *addressesView;
@property(nonatomic,assign)CGFloat margin;
@property(nonatomic,assign)CGFloat noticeHeight;
@property(nonatomic,weak)UIButton *submitBtn;
@property(nonatomic,assign)int count;
@property(nonatomic,assign)int changeData;
@property(nonatomic,assign)int fontSize;
@property(nonatomic,strong)NSMutableArray *resultArray;

//判断结果
@property(nonatomic,strong)NSMutableArray *judgeResultArray;

@property(nonatomic,weak)UIPickerView *pickerView;

@property(nonatomic,weak)UIButton *cellButton;
@property(nonatomic,weak)UIButton *secondButton;
@property(nonatomic,weak)UIButton *threeButton;
@property(nonatomic,weak)UIButton *fourButton;
@property(nonatomic,weak)UIButton *fiveButton;
@property(nonatomic,weak)UIButton *sixButton;

@property(nonatomic,copy)NSString *Space_id;
@property(nonatomic,copy)NSString *Space_name;
@property(nonatomic,copy)NSString *Space_type;

@property(nonatomic,copy)NSString *twoSpace_id;
@property(nonatomic,copy)NSString *twoSpace_name;
@property(nonatomic,copy)NSString *twoSpace_type;

@property(nonatomic,copy)NSString *threeSpace_id;
@property(nonatomic,copy)NSString *threeSpace_name;
@property(nonatomic,copy)NSString *threeSpace_type;

@property(nonatomic,copy)NSString *fourSpace_id;
@property(nonatomic,copy)NSString *fourSpace_name;
@property(nonatomic,copy)NSString *fourSpace_type;

@property(nonatomic,copy)NSString *fiveSpace_id;
@property(nonatomic,copy)NSString *fiveSpace_name;
@property(nonatomic,copy)NSString *fiveSpace_type;


//选择的类型
@property(nonatomic,copy)NSString *oneSelect;
@property(nonatomic,copy)NSString *twoSelect;
@property(nonatomic,copy)NSString *threeSelect;
@property(nonatomic,copy)NSString *fourSelect;
@property(nonatomic,copy)NSString *fiveSelect;

@property(nonatomic,copy) NSString * sixSelect ;


@property(nonatomic,copy)NSString *lastSpace_id;

@property(nonatomic,weak)UITextView *addressText;

@property(nonatomic,strong) UIScrollView * scrollView ;
@property(nonatomic,strong) NSMutableArray * dataArray ;
@property(nonatomic,strong) NSMutableArray * spaceTypeArray ;


@end

@implementation HouseholdViewController

static NSString *const USER_ID = @"User_id";
static NSString *const COMMUNITY_ID = @"Community_id";
static NSString *const SPACE_TYPE = @"Space_type";
static NSString *const GET_COMMUNITY_SPACE = @"Get_Community_Space";
static NSString *const USER_VALID_CODE = @"User_Valid_Code";
//登记地址接口
static NSString *const ReGISTER_ADDRESS = @"Register_Address";
static NSString *const IS_STANDARD_COMMUNITY = @"Is_standard_community";
static NSString *const SPACE = @"Space";


-(NSMutableArray *)judgeResultArray
{
    if (_judgeResultArray == nil) {
        _judgeResultArray = [[NSMutableArray alloc]init];
    }
    return _judgeResultArray;
}
-(NSMutableArray *)resultArray
{
    if (_resultArray == nil) {
        _resultArray = [[NSMutableArray alloc]init];
    }
    return _resultArray;
}


-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}

-(NSMutableArray *)spaceTypeArray
{
    if (!_spaceTypeArray) {
        _spaceTypeArray = [NSMutableArray array] ;
    }
    return _spaceTypeArray ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/256.0 green:240/256.0 blue:240/256.0 alpha:1.0];
    
    [self setNaviBarTitle:@"登记地址"];
    
    [self screenHeight];
    [self createUI];
    
}

-(void)screenHeight
{
//    self.Retcount = 1 ;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    if (screenW == 320) {
        self.margin = 13;
        self.noticeHeight = 60;
        self.count = 5;
        self.fontSize = 11;
        self.changeData = 3;
    }else{
        self.margin = 20;
        self.noticeHeight = 80;
        self.count = 5;
        self.fontSize = 14;
        self.changeData = 0;
    }
    NSLog(@"gaodu %f",screenW);
}

-(void)createUI
{
    if (self.isFromSelected == YES) {
          self.user_id = [USER_DEFAULT objectForKey:kUserId];
    }else{
        self.user_id = [USER_DEFAULT objectForKey:kUserId];
        self.Community_id = [USER_DEFAULT objectForKey:kCommunityId];
    }
    [self noticeView];
    [self addressView];
    [self nextBtn];
    
}

//通知
-(void)noticeView
{
    
    UIView *noticeView = [[UIView alloc]init];
    noticeView.backgroundColor = [UIColor whiteColor];
    noticeView.frame = CGRectMake(Origin_x, 64, VIEW_W(self.view), self.noticeHeight);
    self.noticesView = noticeView;
    [self.view addSubview:noticeView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_notice"];
    CGFloat imageY = (self.noticeHeight - imageView.image.size.height)/2;
    imageView.frame = CGRectMake(self.margin, imageY,imageView.image.size.width,imageView.image.size.height);
    [noticeView addSubview:imageView];
    
    UILabel *mesLabel = [[UILabel alloc]init];
    mesLabel.text = @"为了提供更好的服务，请登记您的详细地址，此信息仅供物业平台购物配送使用，请您放心填写、安心购买。";
    mesLabel.frame = CGRectMake(VIEW_BX(imageView)+self.margin, self.margin/2, VIEW_W(self.view)- (VIEW_BX(imageView)+self.margin)- self.margin, self.noticeHeight - self.margin);
    mesLabel.textColor = RGBCOLOR(142, 143, 144);
    mesLabel.font = [UIFont systemFontOfSize:self.fontSize];
    mesLabel.numberOfLines = 0;
    [noticeView addSubview:mesLabel];
    
    
}

-(void)addressView
{
    UIImageView *addressView = [[UIImageView alloc]init];
    addressView.userInteractionEnabled = YES;
    addressView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight);
    addressView.image = [UIImage imageNamed:@"dizhi_bg"];
    self.addressesView = addressView;
    [self.view addSubview:addressView];
    
    _scrollView = [[UIScrollView alloc]init];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"您要登记的小区为：";
    titleLabel.textColor = RGBCOLOR(165, 165, 165);
    titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    titleLabel.frame = CGRectMake(self.margin, self.margin + 10, 150, self.margin);
    [_scrollView addSubview:titleLabel];
    
    UILabel *cellLabel = [[UILabel alloc]init];
    cellLabel.text = self.cellTitle;
    //    NSLog(@"--------%@",self.cellTitle);
    cellLabel.font = [UIFont systemFontOfSize:(self.fontSize + 6)];
    cellLabel.textColor = [UIColor blackColor];
    cellLabel.frame = CGRectMake(self.margin, VIEW_BY(titleLabel)+self.margin, VIEW_W(self.view) - self.margin - self.noticeHeight, self.margin);
    [_scrollView addSubview:cellLabel];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"切换小区" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor colorWithHexString:@"#a6873b"] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    changeBtn.frame = CGRectMake(VIEW_W(self.view) - self.noticeHeight -self.margin, VIEW_BY(cellLabel)-self.margin, self.margin*4, self.margin);
    [changeBtn addTarget:self action:@selector(clickChangeBtn) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:changeBtn];
    
    UIImageView *changeImage = [[UIImageView alloc]init];
    changeImage.frame = CGRectMake(VIEW_BX(changeBtn), VIEW_BY(cellLabel)-self.margin+5-self.changeData, 10, 10);
    changeImage.image = [UIImage imageNamed:@"icon_qiehuan"];
    [_scrollView addSubview:changeImage];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    lineView.frame = CGRectMake(Origin_x, VIEW_BY(changeBtn) + self.margin, VIEW_W(self.view), 1);
    [_scrollView addSubview:lineView];
    
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.text = @"请您填写详细地址：";
    addressLabel.textColor = RGBCOLOR(165, 165, 165);
    addressLabel.font = [UIFont systemFontOfSize:self.fontSize];
    addressLabel.frame = CGRectMake(self.margin, VIEW_BY(lineView)+self.margin, 150, self.margin);
    [_scrollView addSubview:addressLabel];
    
    
    //判断是不是标准小区
    if ([self.Is_standard_community isEqualToString:@"1"]) {
        
        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellBtn.frame = CGRectMake(self.margin, VIEW_BY(addressLabel)+self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
        cellBtn.backgroundColor = RGBCOLOR(239, 240, 241);
        cellBtn.layer.cornerRadius = 5.0;
        cellBtn.layer.masksToBounds = YES;
        [cellBtn setTitle:@"请选择" forState:UIControlStateNormal];
        cellBtn.titleLabel.font = [UIFont systemFontOfSize:(self.fontSize + 6)];
        [cellBtn setTitleColor:RGBCOLOR(142, 143, 144) forState:UIControlStateNormal];
        cellBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [cellBtn addTarget:self action:@selector(cilckCellBtn) forControlEvents:UIControlEventTouchUpInside];
        cellBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cellBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        self.cellButton = cellBtn;
        [_scrollView addSubview:cellBtn];
        
    }else{
        
        UITextView *detialText = [[UITextView alloc]init];
        detialText.frame = CGRectMake(self.margin, VIEW_BY(addressLabel)+self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
        detialText.delegate = self;
        detialText.tintColor = HexRGB(0x999999);
        detialText.backgroundColor = RGBCOLOR(239, 240, 241);
        detialText.font = [UIFont systemFontOfSize:16];
        detialText.layer.cornerRadius = 5.0;
        detialText.layer.masksToBounds = YES;
        detialText.autocorrectionType = UITextAutocorrectionTypeNo;
        self.addressText = detialText;
        [_scrollView addSubview:detialText];
        
    }
    _scrollView.frame =  CGRectMake(Origin_x, 0, VIEW_W(self.view), self.count*self.noticeHeight);
    _scrollView.contentSize = CGSizeMake(VIEW_W(self.view), self.count*self.noticeHeight+100) ;
    [addressView addSubview:_scrollView] ;
}

-(void)nextBtn
{
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
    submitBtn.backgroundColor = RGBCOLOR(206, 207, 208) ;
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn = submitBtn;
    [self.view addSubview:submitBtn];
}

- (void)clickSubmitBtn
{
    
    if ([self.Is_standard_community isEqualToString:@"2"]) {
        self.lastSpace_id = self.addressText.text;
    }
    NSDictionary *dictParam = [[NSDictionary alloc]init];
    dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,IS_STANDARD_COMMUNITY:self.Is_standard_community,SPACE:self.lastSpace_id};
    [HttpService postWithServiceCode:ReGISTER_ADDRESS params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        
        NSDictionary *dict = (NSDictionary *)jsonObj;
        //不管是否是标准小区，都会返回一个space_id
        
        if ([dict validateOk]) {
            
            [USER_DEFAULT setObject:@"2" forKey:kUser_Space_State] ;
            
            NSString *space_id = [[dict objectForKey:@"Data"] objectForKey:@"Space_id"];
            NSString *space_name = @"";
            NSString *community_id = self.Community_id;
            NSString *community_name = self.cellTitle;
            NSString *community_valid_status = @"";
            NSString *community_status = @"";
            //手动将审核状态置为空
            NSString *Address_valid_status = @"";
            [USER_DEFAULT setObject:space_id forKey:kSpace_id];
            [USER_DEFAULT setObject:space_name forKey:kSpace_name];
            [USER_DEFAULT setObject:community_id forKey:kCommunityId];
            [USER_DEFAULT setObject:community_name forKey:kCommunity_name];
            [USER_DEFAULT setObject:community_valid_status forKey:kCommunity_valid_status];
            [USER_DEFAULT setObject:Address_valid_status forKey:kAddress_valid_status];
            [USER_DEFAULT setObject:community_status forKey:kCommunity_status];
            [USER_DEFAULT synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationReloDataHome object:nil userInfo:nil];
            [MBProgressHUD showSuccess:@"登记成功"] ;
            //判断页面的来源如果是添加地址跳转到提交资料页
            if (self.isFromSelected == YES) {
                HouseholdsController * house = [[HouseholdsController alloc]init];
                house.space_id = [USER_DEFAULT objectForKey:kSpace_id] ;
                house.community_id = [USER_DEFAULT objectForKey:kCommunityId] ;
                [self.navigationController pushViewController:house animated:YES];
            }else{
            
                BaoShiViewController * BS = [[BaoShiViewController alloc]init];
                BS.titleName = @"物业报事" ;
                BS.url = [NSString stringWithFormat:@"%@/community_id/%@",BSURL,[USER_DEFAULT objectForKey:kCommunityId]] ;
                [self.navigationController pushViewController:BS animated:YES];
                [USER_DEFAULT setObject:self.Space_name forKey:@"BaoShi_SpaceName"] ;
                [USER_DEFAULT setObject:self.lastSpace_id forKey:@"BaoShi_SpaceID"] ;
            }
            
        }else{
            if ([dict[@"Message"] isEqualToString:@"You have already registered."]) {
                [MBProgressHUD showError:@"您已添加过该地址"] ;
            }else{
            
            [MBProgressHUD showError:@"登记失败"];
            }
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}




-(void)cilckCellBtn
{
    NSDictionary *dictParam = [[NSDictionary alloc]init];
    if (self.Community_id==nil) {
        self.Community_id = [USER_DEFAULT objectForKey:kCommunityId];
    }
    [SVProgressHUD showInView:self.view];
    dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:@"community",@"Parent_id":self.Community_id};    [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;
        self.resultArray = [dict objectForKey:@"Data"];
        NSLog(@"res %@",self.resultArray);
        [SVProgressHUD dismiss];
        if ([dict validateOk]) {
            
            if (self.resultArray.count > 0) {
                
                GYCustomActionSheetView *customActionView =[[GYCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:self.resultArray andCellPickControllrtBlock:^(NSString *address,NSString *spaceID,NSString *spaceType) {
                    
                    if (![self.Space_name isEqualToString:address]) {

                        //
                        NSDictionary *dictParam = [[NSDictionary alloc]init];
                        
                        dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:spaceType,@"Parent_id":spaceID};
                        
                        [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
                            NSDictionary *dict = (NSDictionary *)jsonObj;
                            self.judgeResultArray = [dict objectForKey:@"Data"];
                            NSLog(@"res %@",self.resultArray);
                            
                            if ([dict validateOk]) {
                                if ( self.judgeResultArray.count > 0) {
                                    
                                    self.submitBtn.backgroundColor = RGBCOLOR(206, 207, 208);
                                    self.submitBtn.enabled = NO;
                                    self.navigationItem.rightBarButtonItem.enabled = NO;
                                    
                                    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                                    secondBtn.frame = CGRectMake(self.margin, VIEW_BY(self.cellButton)+self.margin/2, VIEW_W(self.view)-2*self.margin, 2*self.margin);
                                    secondBtn.tag = 100 ;
                                    secondBtn.backgroundColor = RGBCOLOR(239, 240, 241);
                                    secondBtn.layer.cornerRadius = 5.0;
                                    secondBtn.layer.masksToBounds = YES;
                                    [secondBtn setTitle:@"请选择" forState:UIControlStateNormal];
                                    [secondBtn setTitleColor:RGBCOLOR(142, 143, 144) forState:UIControlStateNormal];
                                    secondBtn.titleLabel.font = [UIFont systemFontOfSize:(self.fontSize + 6)];
                                    secondBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
                                    [secondBtn addTarget:self action:@selector(CLICK:) forControlEvents:UIControlEventTouchUpInside];
                                    secondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                    secondBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
                                    //                                    self.secondButton = secondBtn;
                                    [_scrollView addSubview:secondBtn];
                                    //                                    self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin);
                                    //                                    self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
                                    
                                }else{
                                    self.submitBtn.backgroundColor =[UIColor colorWithHexString:@"#a6873b"];
                                    self.submitBtn.enabled = YES;
                                    self.navigationItem.rightBarButtonItem.enabled = YES;
                                }
                            }
                            
                        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"%@ %@",[error description],operation.responseString);
                        }];
                    }
                    
                    self.Space_id = spaceID;
                    self.Space_name = address;
                    self.Space_type = spaceType;
                    self.lastSpace_id = spaceID;
                    if (self.dataArray.count>0) {
                        if (![self.dataArray containsObject:spaceID]) {
                            if (![self.dataArray[0] isEqualToString:spaceID]) {
                                self.dataArray =nil ;
                                [self.dataArray addObject:spaceID];
                                [self.spaceTypeArray addObject:spaceType] ;
                                [self removeBtnWithNumber:0] ;
                            }
                        }
                        
                    }else{
                        [self.dataArray addObject:spaceID];
                        [self.spaceTypeArray addObject:spaceType] ;
                    }
                    
                    [self.cellButton setTitle:address forState:UIControlStateNormal];
                    NSLog(@"点击了确定 address %@  %@  %@",address,spaceID,spaceType);
                    
                    
                }];
                
                [customActionView show];
            }
            
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD showError:@"加载失败"];
        NSLog(@"%@ %@",[error description],operation.responseString);
    }];
    
    
}

-(void)CLICK:(UIButton *)sender
{
    [self cilckBtnWithNumber:(int)(sender.tag-100+1)];
}


/**
 *  创建按钮的方法  (第二个按钮之后)
 */

-(void)cilckBtnWithNumber:(int)num
{
    
    [SVProgressHUD show] ;
    NSDictionary *dictParam = [[NSDictionary alloc]init];
    NSString *use_id = [USER_DEFAULT objectForKey:kUserId];
    //    dictParam = @{USER_ID:use_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:@"community",@"Parent_id":self.Community_id};
    dictParam = @{USER_ID:use_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:self.spaceTypeArray[num-1],@"Parent_id":self.dataArray[num-1]};
    [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;
        self.resultArray = [dict objectForKey:@"Data"];
        NSLog(@"res %@",self.resultArray);
        [SVProgressHUD dismiss];
        if ([dict validateOk]) {
            
            if (self.resultArray.count > 0) {
                
              GYCustomActionSheetView *customActionView =[[GYCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:self.resultArray andCellPickControllrtBlock:^(NSString *address,NSString *spaceID,NSString *spaceType) {
                    
                    if (![self.Space_name isEqualToString:address]) {
                        
                        //保存spaceID
                        NSDictionary *dictParam = [[NSDictionary alloc]init];
                        NSString *use_id = [USER_DEFAULT objectForKey:kUserId];
                        dictParam = @{USER_ID:use_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:spaceType,@"Parent_id":spaceID};
                        
                        [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
                            NSDictionary *dict = (NSDictionary *)jsonObj;
                            self.judgeResultArray = [dict objectForKey:@"Data"];
                            NSLog(@"res %@",self.resultArray);
                            
                            if ([dict validateOk]) {
                                if ( self.judgeResultArray.count > 0) {
                                    
                                    self.submitBtn.backgroundColor = RGBCOLOR(206, 207, 208);
                                    self.submitBtn.enabled = NO;
                                    self.navigationItem.rightBarButtonItem.enabled = NO;
                                    
                                    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                                    secondBtn.frame = CGRectMake(self.margin, 1*self.margin+2*self.margin*2+151.0f+(self.margin/2+2*self.margin)*(num - 1), VIEW_W(self.view)-2*self.margin, 2*self.margin);
                                     secondBtn.frame = CGRectMake(self.margin, 8*self.margin+10+2.5*self.margin*(num - 1)+2.5*self.margin*2, VIEW_W(self.view)-2*self.margin, 2*self.margin);
                                    secondBtn.tag = num +100 ;
                                    secondBtn.backgroundColor = RGBCOLOR(239, 240, 241);
                                    secondBtn.layer.cornerRadius = 5.0;
                                    secondBtn.layer.masksToBounds = YES;
                                    [secondBtn setTitle:@"请选择" forState:UIControlStateNormal];
                                    [secondBtn setTitleColor:RGBCOLOR(142, 143, 144) forState:UIControlStateNormal];
                                    secondBtn.titleLabel.font = [UIFont systemFontOfSize:(self.fontSize + 6)];
                                    secondBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
                                    [secondBtn addTarget:self action:@selector(CLICK:) forControlEvents:UIControlEventTouchUpInside];
                                    secondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                    secondBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
                                    //                                    self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight +self.Retcount*2.5*self.margin);
                                    if (num > 3) {
                                        _scrollView.scrollEnabled = YES ;
                                        _scrollView.size = CGSizeMake(VIEW_W(self.view), 2*self.margin+2*self.margin*2+151.0f+(self.margin/2+2*self.margin)*(num - 1)) ;
                                        
                                    }
                                    
                                    [_scrollView addSubview:secondBtn];
                                    
                                }else{
                                    self.submitBtn.backgroundColor =[UIColor colorWithHexString:@"#a6873b"];
                                    self.submitBtn.enabled = YES;
                                    self.navigationItem.rightBarButtonItem.enabled = YES;
                                }
                            }
                            
                        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"%@ %@",[error description],operation.responseString);
                        }];
                    }
                    
                    self.Space_id = spaceID;
                    self.Space_name = address;
                    self.Space_type = spaceType;
                    self.lastSpace_id = spaceID;
                    
                    //选择的楼层不同删除后面的按钮，并重新设置位置
                    if (![self.dataArray containsObject:spaceID]) {
                        
                        [self removeBtnWithNumber:num] ;
                        [self.dataArray addObject:spaceID] ;
                        [self.spaceTypeArray addObject:spaceType] ;
                    }
                    //                    if (![self.dataArray containsObject:spaceID]) {
                    //                        [self.dataArray addObject:spaceID];
                    //                    }
                    UIButton * btn  = (UIButton *)[_scrollView viewWithTag:num+100-1] ;
                    [btn setTitle:address forState:UIControlStateNormal];
                }];
                
                [customActionView show];
            }
            
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
        [MBProgressHUD showError:@"加载失败"];
        NSLog(@"%@ %@",[error description],operation.responseString);
    }];
    
    
}

/**
 * 删除其他按钮的方法
 */
-(void)removeBtnWithNumber:(int)num
{
    for (UIView *btn in _scrollView.subviews) {
        if ([btn isKindOfClass: [UIButton class]]) {
            if ((btn.tag -100+1)>num) {
                [btn removeFromSuperview] ;
            }
            if (self.dataArray.count>num) {
                [self.dataArray removeObjectsInRange:NSMakeRange((num), self.dataArray.count-1)];
                [self.spaceTypeArray removeObjectsInRange:NSMakeRange((num), self.spaceTypeArray.count-1)];
            }
            
        }
    }
    
}




//
//-(void)cilckCellBtn
//{
//    
//    NSDictionary *dictParam = [[NSDictionary alloc]init];
//    if (self.Community_id==nil) {
//        self.Community_id = [USER_DEFAULT objectForKey:kCommunityId];
//    }
//    
//    dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:@"community",@"Parent_id":self.Community_id};
//    
//    [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//        
//        NSLog(@"%@",jsonObj);
//        
//        NSDictionary *dict = (NSDictionary *)jsonObj;
//        self.resultArray = [dict objectForKey:@"Data"];
//        NSLog(@"res %@",self.resultArray);
//        
//        if ([dict validateOk]) {
//            
//            if (self.resultArray.count > 0) {
//                
//                GYCustomActionSheetView *customActionView =[[GYCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:self.resultArray andCellPickControllrtBlock:^(NSString *address,NSString *spaceID,NSString *spaceType) {
//                    
//                    if (![self.Space_name isEqualToString:address]) {
//                        
//                        //选择的楼层不同删除后面的按钮，并重新设置位置
//                        [self.secondButton removeFromSuperview];
//                        [self.threeButton removeFromSuperview];
//                        [self.fourButton removeFromSuperview];
//                        [self.fiveButton removeFromSuperview];
//                        [self.sixButton removeFromSuperview] ;
//                        
//                        self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight );
//                        self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                        
//                        NSDictionary *dictParam = [[NSDictionary alloc]init];
//
//                        dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:spaceType,@"Parent_id":spaceID};
//                        
//                        [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//                            NSDictionary *dict = (NSDictionary *)jsonObj;
//                            self.judgeResultArray = [dict objectForKey:@"Data"];
//                            NSLog(@"res %@",self.resultArray);
//                            
//                            if ([dict validateOk]) {
//                                if ( self.judgeResultArray.count > 0) {
//                                    
//                                    self.submitBtn.backgroundColor = RGBCOLOR(206, 207, 208);
//                                    self.submitBtn.enabled = NO;
//                                    self.navigationItem.rightBarButtonItem.enabled = NO;
//                                    
//                                    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                                    secondBtn.frame = CGRectMake(self.margin, VIEW_BY(self.cellButton)+self.margin/2, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    secondBtn.backgroundColor = RGBCOLOR(239, 240, 241);
//                                    secondBtn.layer.cornerRadius = 5.0;
//                                    secondBtn.layer.masksToBounds = YES;
//                                    [secondBtn setTitle:@"请选择" forState:UIControlStateNormal];
//                                    [secondBtn setTitleColor:RGBCOLOR(142, 143, 144) forState:UIControlStateNormal];
//                                    secondBtn.titleLabel.font = [UIFont systemFontOfSize:(self.fontSize + 6)];
//                                    secondBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//                                    [secondBtn addTarget:self action:@selector(clicksecondBtn) forControlEvents:UIControlEventTouchUpInside];
//                                    secondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                                    secondBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
//                                    self.secondButton = secondBtn;
//                                    [self.addressesView addSubview:secondBtn];
//                                    self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin);
//                                    self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    
//                                }else{
//                                    self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#a6873b"] ;
//                                    self.submitBtn.enabled = YES;
//                                    self.navigationItem.rightBarButtonItem.enabled = YES;
//                                }
//                            }
//                            
//                        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            NSLog(@"%@ %@",[error description],operation.responseString);
//                        }];
//                    }
//                    
//                    self.Space_id = spaceID;
//                    self.Space_name = address;
//                    self.Space_type = spaceType;
//                    self.lastSpace_id = spaceID;
//                    
//                    [self.cellButton setTitle:address forState:UIControlStateNormal];
//                    NSLog(@"点击了确定 address %@  %@  %@",address,spaceID,spaceType);
//                }];
//                
//                [customActionView show];
//            }
//            
//        }
//        
//    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@ %@",[error description],operation.responseString);
//    }];
//    
//    
//}
//-(void)clicksecondBtn
//{
//    
//    NSDictionary *dictParam = [[NSDictionary alloc]init];
//    dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:self.Space_type,@"Parent_id":self.Space_id};
//    
//    [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//        NSDictionary *dict = (NSDictionary *)jsonObj;
//        self.resultArray = [dict objectForKey:@"Data"];
//        NSLog(@"res %@",self.resultArray);
//        
//        if ([dict validateOk]) {
//            
//            if (self.resultArray.count > 0) {
//                
//                GYCustomActionSheetView *customActionView =[[GYCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:self.resultArray andCellPickControllrtBlock:^(NSString *address,NSString *spaceID,NSString *spaceType) {
//                    
//                    if (![self.twoSpace_name isEqualToString:address]) {
//                        
//                        //选择的楼层不同删除后面的按钮，并重新设置位置
//                        [self.threeButton removeFromSuperview];
//                        [self.fourButton removeFromSuperview];
//                        [self.fiveButton removeFromSuperview];
//                        
//                        self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin);
//                        
//                        self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                        
//                        NSDictionary *dictParam = [[NSDictionary alloc]init];
//
//                        dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:spaceType,@"Parent_id":spaceID};
//                        
//                        [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//                            NSDictionary *dict = (NSDictionary *)jsonObj;
//                            self.judgeResultArray = [dict objectForKey:@"Data"];
//                            NSLog(@"res %@",self.judgeResultArray);
//                            
//                            if ([dict validateOk]) {
//                                if (self.judgeResultArray.count > 0) {
//                                    
//                                    self.submitBtn.backgroundColor = RGBCOLOR(206, 207, 208);
//                                    self.submitBtn.enabled = NO;
//                                    self.navigationItem.rightBarButtonItem.enabled = NO;
//                                    
//                                    UIButton *threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                                    threeBtn.frame = CGRectMake(self.margin, VIEW_BY(self.secondButton)+self.margin/2, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    threeBtn.backgroundColor = RGBCOLOR(239, 240, 241);
//                                    threeBtn.layer.cornerRadius = 5.0;
//                                    threeBtn.layer.masksToBounds = YES;
//                                    [threeBtn setTitle:@"请选择" forState:UIControlStateNormal];
//                                    threeBtn.titleLabel.font = [UIFont systemFontOfSize:(self.fontSize + 6)];
//                                    [threeBtn setTitleColor:RGBCOLOR(142, 143, 144) forState:UIControlStateNormal];
//                                    threeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//                                    [threeBtn addTarget:self action:@selector(clickthreeBtn) forControlEvents:UIControlEventTouchUpInside];
//                                    threeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                                    threeBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
//                                    self.threeButton = threeBtn;
//                                    [self.addressesView addSubview:threeBtn];
//                                    self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin + 2.5*self.margin);
//                                    self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    
//                                }else{
//                                    self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#a6873b"] ;
//                                    self.submitBtn.enabled = YES;
//                                    self.navigationItem.rightBarButtonItem.enabled = YES;
//                                }
//                            }
//                            
//                        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            NSLog(@"%@ %@",[error description],operation.responseString);
//                        }];
//                    }
//                    self.twoSpace_id = spaceID;
//                    self.twoSpace_name = address;
//                    self.twoSpace_type = spaceType;
//                    
//                    self.lastSpace_id = spaceID;
//                    [self.secondButton setTitle:address forState:UIControlStateNormal];
//                    NSLog(@"点击了确定 address %@  %@  %@",address,spaceID,spaceType);
//                }];
//                
//                [customActionView show];
//            }
//        }
//
//    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@ %@",[error description],operation.responseString);
//    }];
//}
//
//-(void)clickthreeBtn
//{
//    
//    NSDictionary *dictParam = [[NSDictionary alloc]init];
//    dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id ,SPACE_TYPE:self.twoSpace_type,@"Parent_id":self.twoSpace_id};
//    
//    [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//        NSDictionary *dict = (NSDictionary *)jsonObj;
//        self.resultArray = [dict objectForKey:@"Data"];
//        NSLog(@"res %@",self.resultArray);
//        
//        if ([dict validateOk]) {
//            if (self.resultArray.count > 0) {
//                
//                GYCustomActionSheetView *customActionView =[[GYCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:self.resultArray andCellPickControllrtBlock:^(NSString *address,NSString *spaceID,NSString *spaceType) {
//                    
//                    if (![self.Space_name isEqualToString:address]) {
//                        
//                        //选择的楼层不同删除后面的按钮，并重新设置位置
//                        [self.fourButton removeFromSuperview];
//                        [self.fiveButton removeFromSuperview];
//                        [self.sixButton removeFromSuperview] ;
//                        
//                        
//                        self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin + 2.5*self.margin);
//                        self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                        
//                        NSDictionary *dictParam = [[NSDictionary alloc]init];
//                        dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:spaceType,@"Parent_id":spaceID};
//                        
//                        [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//                            NSDictionary *dict = (NSDictionary *)jsonObj;
//                            self.judgeResultArray = [dict objectForKey:@"Data"];
//                            NSLog(@"res %@",self.judgeResultArray);
//                            
//                            if ([dict validateOk]) {
//                                if (self.judgeResultArray.count > 0) {
//                                    
//                                    self.submitBtn.backgroundColor = RGBCOLOR(206, 207, 208);
//                                    self.submitBtn.enabled = NO;
//                                    self.navigationItem.rightBarButtonItem.enabled = NO;
//                                    
//                                    UIButton *fourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                                    fourBtn.frame = CGRectMake(self.margin, VIEW_BY(self.threeButton)+self.margin/2, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    fourBtn.backgroundColor = RGBCOLOR(239, 240, 241);
//                                    fourBtn.layer.cornerRadius = 5.0;
//                                    fourBtn.layer.masksToBounds = YES;
//                                    [fourBtn setTitle:@"请选择" forState:UIControlStateNormal];
//                                    fourBtn.titleLabel.font = [UIFont systemFontOfSize:(self.fontSize + 6)];
//                                    [fourBtn setTitleColor:RGBCOLOR(142, 143, 144) forState:UIControlStateNormal];
//                                    fourBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//                                    [fourBtn addTarget:self action:@selector(clickfourBtn) forControlEvents:UIControlEventTouchUpInside];
//                                    fourBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                                    fourBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
//                                    self.fourButton = fourBtn;
//                                    [self.addressesView addSubview:fourBtn];
//                                    self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin + 2.5*self.margin + 2.5*self.margin);
//                                    self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    
//                                }else{
//                                    self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#a6873b"] ;
//                                    self.submitBtn.enabled = YES;
//                                    self.navigationItem.rightBarButtonItem.enabled = YES;
//                                }
//                            }
//                            
//                        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            NSLog(@"%@ %@",[error description],operation.responseString);
//                        }];
//                        
//                    }
//                    self.threeSpace_id = spaceID;
//                    self.threeSpace_name = address;
//                    self.threeSpace_type = spaceType;
//                    
//                    self.lastSpace_id = spaceID;
//                    [self.threeButton setTitle:address forState:UIControlStateNormal];
//                    NSLog(@"点击了确定 address %@  %@  %@",address,spaceID,spaceType);
//                    
//                    
//                    
//                }];
//                
//                [customActionView show];
//            }
//            
//        }
//        
//    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@ %@",[error description],operation.responseString);
//    }];
//}
//
//-(void)clickfourBtn
//{//鹿鸣
//    NSDictionary *dictParam = [[NSDictionary alloc]init];
//    dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id ,SPACE_TYPE:self.threeSpace_type,@"Parent_id":self.threeSpace_id};
//    
//    [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//        NSDictionary *dict = (NSDictionary *)jsonObj;
//        self.resultArray = [dict objectForKey:@"Data"];
//        NSLog(@"res %@",self.resultArray);
//        
//        if ([dict validateOk]) {
//            if (self.resultArray.count > 0) {
//                
//                GYCustomActionSheetView *customActionView =[[GYCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:self.resultArray andCellPickControllrtBlock:^(NSString *address,NSString *spaceID,NSString *spaceType) {
//                    
//                    if (![self.Space_name isEqualToString:address]) {
//                        
//                        //选择的楼层不同删除后面的按钮，并重新设置位置
//                        [self.fiveButton removeFromSuperview];
//                        
//                        self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin + 2.5*self.margin + 2.5*self.margin);
//                        self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                        
//                        NSDictionary *dictParam = [[NSDictionary alloc]init];
//                        dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:spaceType,@"Parent_id":spaceID};
//                        
//                        [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//                            NSDictionary *dict = (NSDictionary *)jsonObj;
//                            self.judgeResultArray = [dict objectForKey:@"Data"];
//                            NSLog(@"res %@",self.judgeResultArray);
//                            
//                            if ([dict validateOk]) {
//                                
//                                if (self.judgeResultArray.count > 0) {
//                                    
//                                    self.submitBtn.backgroundColor = RGBCOLOR(206, 207, 208);
//                                    self.submitBtn.enabled = NO;
//                                    self.navigationItem.rightBarButtonItem.enabled = NO;
//                                    
//                                    UIButton *fiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                                    fiveBtn.frame = CGRectMake(self.margin, VIEW_BY(self.fourButton)+self.margin/2, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    fiveBtn.backgroundColor = RGBCOLOR(239, 240, 241);
//                                    fiveBtn.layer.cornerRadius = 5.0;
//                                    fiveBtn.layer.masksToBounds = YES;
//                                    [fiveBtn setTitle:@"请选择" forState:UIControlStateNormal];
//                                    fiveBtn.titleLabel.font = [UIFont systemFontOfSize:(self.fontSize + 6)];
//                                    [fiveBtn setTitleColor:RGBCOLOR(142, 143, 144) forState:UIControlStateNormal];
//                                    fiveBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//                                    [fiveBtn addTarget:self action:@selector(clickfiveBtn) forControlEvents:UIControlEventTouchUpInside];
//                                    fiveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                                    fiveBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
//                                    self.fiveButton = fiveBtn;
//                                    [self.addressesView addSubview:fiveBtn];
//                                    self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin + 2.5*self.margin + 2.5*self.margin + 2.5*self.margin);
//                                    self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    
//                                }else{
//                                    self.submitBtn.backgroundColor =[UIColor colorWithHexString:@"#a6873b"] ;
//                                    self.submitBtn.enabled = YES;
//                                    self.navigationItem.rightBarButtonItem.enabled = YES;
//                                }
//                            }
//                            
//                        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            NSLog(@"%@ %@",[error description],operation.responseString);
//                        }];
//                        
//                    }
//                    self.fourSpace_id = spaceID;
//                    self.fourSpace_name = address;
//                    self.fourSpace_type = spaceType;
//                    
//                    self.lastSpace_id = spaceID;
//                    [self.fourButton setTitle:address forState:UIControlStateNormal];
//                    NSLog(@"点击了确定 address %@  %@  %@",address,spaceID,spaceType);
//                    
//                    
//                    
//                }];
//                
//                [customActionView show];
//            }
//            
//        }
//        
//    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@ %@",[error description],operation.responseString);
//    }];
//}
//
////第五个按钮
//
//-(void)clickfiveBtn
//{
//    
//    NSDictionary *dictParam = [[NSDictionary alloc]init];
//    dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id ,SPACE_TYPE:self.fourSpace_type,@"Parent_id":self.fourSpace_id};
//    
//    [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//        NSDictionary *dict = (NSDictionary *)jsonObj;
//        self.resultArray = [dict objectForKey:@"Data"];
//        NSLog(@"res %@",self.resultArray);
//        
//        if ([dict validateOk]) {
//            if (self.resultArray.count > 0) {
//                
//                GYCustomActionSheetView *customActionView =[[GYCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:self.resultArray andCellPickControllrtBlock:^(NSString *address,NSString *spaceID,NSString *spaceType) {
//                    
//                    if (![self.Space_name isEqualToString:address]) {
//                        
//                        //选择的楼层不同删除后面的按钮，并重新设置位置
//                        //                        [self.fiveButton removeFromSuperview];
//                        [self.sixButton removeFromSuperview] ;
//                        self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin + 2.5*self.margin + 2.5*self.margin);
//                        self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                        
//                        NSDictionary *dictParam = [[NSDictionary alloc]init];
//                        dictParam = @{USER_ID:self.user_id,COMMUNITY_ID:self.Community_id,SPACE_TYPE:spaceType,@"Parent_id":spaceID};
//                        
//                        [HttpService postWithServiceCode:GET_COMMUNITY_SPACE params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
//                            NSDictionary *dict = (NSDictionary *)jsonObj;
//                            self.judgeResultArray = [dict objectForKey:@"Data"];
//                            NSLog(@"res %@",self.judgeResultArray);
//                            
//                            if ([dict validateOk]) {
//                                
//                                if (self.judgeResultArray.count > 0) {
//                                    
//                                    self.submitBtn.backgroundColor = RGBCOLOR(206, 207, 208);
//                                    self.submitBtn.enabled = NO;
//                                    self.navigationItem.rightBarButtonItem.enabled = NO;
//                                    
//                                    UIButton *fiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                                    fiveBtn.frame = CGRectMake(self.margin, VIEW_BY(self.fourButton)+self.margin/2, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    fiveBtn.backgroundColor = RGBCOLOR(239, 240, 241);
//                                    fiveBtn.layer.cornerRadius = 5.0;
//                                    fiveBtn.layer.masksToBounds = YES;
//                                    [fiveBtn setTitle:@"请选择" forState:UIControlStateNormal];
//                                    fiveBtn.titleLabel.font = [UIFont systemFontOfSize:(self.fontSize + 6)];
//                                    [fiveBtn setTitleColor:RGBCOLOR(142, 143, 144) forState:UIControlStateNormal];
//                                    fiveBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//                                    [fiveBtn addTarget:self action:@selector(clickfiveBtn) forControlEvents:UIControlEventTouchUpInside];
//                                    fiveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                                    fiveBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
//                                    self.sixButton = fiveBtn;
//                                    [self.addressesView addSubview:fiveBtn];
//                                    self.addressesView.frame = CGRectMake(Origin_x, VIEW_BY(self.noticesView)+self.margin, VIEW_W(self.view), self.count*self.noticeHeight + 2.5*self.margin + 2.5*self.margin + 2.5*self.margin + 2.5*self.margin);
//                                    self.submitBtn.frame = CGRectMake(self.margin, CGRectGetMaxY(self.addressesView.frame) + self.margin, VIEW_W(self.view)-2*self.margin, 2*self.margin);
//                                    
//                                }else{
//                                    self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#a6873b"] ;
//                                    self.submitBtn.enabled = YES;
//                                    self.navigationItem.rightBarButtonItem.enabled = YES;
//                                }
//                            }
//                            
//                        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            NSLog(@"%@ %@",[error description],operation.responseString);
//                        }];
//                        
//                    }
//                    self.fiveSpace_id = spaceID;
//                    self.fiveSpace_name = address;
//                    self.fiveSpace_type = spaceType;
//                    
//                    self.lastSpace_id = spaceID;
//                    [self.fiveButton setTitle:address forState:UIControlStateNormal];
//                    NSLog(@"点击了确定 address %@  %@  %@",address,spaceID,spaceType);
//                    
//                    
//                    
//                }];
//                
//                [customActionView show];
//            }
//            
//        }
//        
//    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@ %@",[error description],operation.responseString);
//    }];
//    
//}
//

-(void)clickChangeBtn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        self.submitBtn.backgroundColor = RGBCOLOR(206, 207, 208);
        self.submitBtn.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    }else{
        
        self.submitBtn.backgroundColor = [UIColor colorWithHexString:@"#a6873b"] ;
        self.submitBtn.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
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
