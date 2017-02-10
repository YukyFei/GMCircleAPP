//
//  BaoShiDetailViewController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/11/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "BaoShiDetailViewController.h"
#import "HBCustomActionSheetView.h"
#import "DateUtil.h"
#import "PhotoPickerUtil.h"
#import "UIImageLibrary.h"
#import "VShowImgs.h"
#import "UIImageView+WebCache.h"


#import "FileUtil.h"
#import "ListCellView.h"

#define  kImageHeight (SCREENWIDTH-60)/3
@interface BaoShiDetailViewController ()<UITextViewDelegate,ImageLibraryPickerDelegate,VShowImgsDelegate>
{
    UIImageView * _ShouImageView;//即将要显示的图片
    
}

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong) UIImageLibraryPicker *imgPicker;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel*hintLabel;
@property(nonatomic,strong)UIScrollView *mScrollView;
@property(nonatomic,strong)NSString *dateStr;
@property(nonatomic,strong)NSString *spaceID;
@property(nonatomic,strong)NSString *typeID;

@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;

//头部
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong) UIScrollView *imageScrollView;
@property(nonatomic,strong) NSMutableArray * viewShowing;//
@property(nonatomic,strong)NSMutableArray *picsArray;//图片数组
@property(nonatomic,strong)ListCellView *time;
@property(nonatomic,strong)ListCellView *endTimesView;
@property(nonatomic,strong)ListCellView *address;
@property(nonatomic,strong)UIView *bottomView;
//选择照片
@property(nonatomic,strong)UIButton *shotBtn;


@end


@implementation BaoShiDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNaviBarTitle:@"报事/报修"];
    _picsArray = [NSMutableArray array] ;
    [self createUI];
    [self createNavigationRightBarButtonWithTitle:@"提交" andTitleColor:[UIColor whiteColor]];
    
}

#pragma mark-public method
-(id)initWithObject:(id)object
{
    if(self =[super init])
    {
        _style=@"";
        if([object isKindOfClass:[NSString class]]){
            _style=object;
        }
//        _picsArray =[NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

#pragma mark -private
// 报事请求
- (void)rightBarButtonPress
{
    if(self.startTime.length==0||self.endTime.length==0){
        [ProgressHUD showUIBlockingIndicatorWithText:@"请选择预约时间" withTimeout:1.0f];
//        [SVProgressHUD show]
        return;
    }
    if (self.spaceID.length==0) {
//        self.spaceID = [USER_DEFAULT objectForKey: @"Space_id"];
         [MBProgressHUD showError:@"请选择报事地址"];
        return ;
    }
    
    if (self.textView.text.length==0) {
        //        self.spaceID = [USER_DEFAULT objectForKey: @"Space_id"];
        [MBProgressHUD showError:@"请填写具体报事事宜"];
        return ;
    }

    CGFloat ret = [self.startTime floatValue]-[self.endTime floatValue] ;
    if (ret>0) {
        [MBProgressHUD showError:@"结束时间不能早于开始时间"];
        return  ;
    }
    
    NSDictionary * dict = @{@"User_id":[USER_DEFAULT objectForKey:kUserId],@"Community_id":[USER_DEFAULT objectForKey:kCommunityId],@"Space_id":self.spaceID,@"Type_id":self.typeID,@"Desc":self.textView.text,@"Start_time":self.startTime,@"End_time":self.endTime} ;

    NSLog(@"。。。%@",dict);
    __weak typeof (self) weakSelf=self;
    
    [SVProgressHUD showInView:self.view status:@"正在提交..."] ;
    if(self.picsArray.count==0){
        
        [HttpService postWithServiceCode:@"Event_Sub" params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
            
            [SVProgressHUD dismiss] ;
            NSLog(@"报事成功%@",jsonObj);
            NSDictionary *dict =(NSDictionary*)jsonObj;
            if([dict validateOk])
            {//报事成功
                [MBProgressHUD showSuccess:@"报事成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                if ([dict[@"Message"] isEqualToString:@"user not login"]) {
//                    [SVProgressHUD dismissWithError:@"账号异常，请重新登录" afterDelay:1.5f] ;
                    [MBProgressHUD showError:@"账号异常，请重新登录"];
                }else{
                [MBProgressHUD showError:@"报事失败"];
//                [SVProgressHUD dismissWithError:@"报事失败" afterDelay:1.5f] ;
                }
            }
        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss] ;
            [MBProgressHUD showError:@"网络请求失败"] ;
           
            NSLog(@"网络请求失败%@",error);
        }];
    }else{
        
        [HttpService filePostWithServiceCode:@"Event_Sub" params:dict andImageDatas:self.picsArray success:^(AFHTTPRequestOperation *operation, id jsonObj) {
            NSLog(@"报事成功%@",jsonObj);
            NSDictionary *dict =(NSDictionary*)jsonObj;
            [SVProgressHUD dismiss] ;
            if([dict validateOk])
            {//报事成功
                [MBProgressHUD showSuccess:@"报事成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else{
             
                if ([dict[@"Message"] isEqualToString:@"user not login"]) {
                    //                    [SVProgressHUD dismissWithError:@"账号异常，请重新登录" afterDelay:1.5f] ;
                    [MBProgressHUD showError:@"账号异常，请重新登录"];
                }else{
                    [MBProgressHUD showError:@"报事失败"];
                    //                [SVProgressHUD dismissWithError:@"报事失败" afterDelay:1.5f] ;
                }

            }
            
        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            //报事失败
            [SVProgressHUD dismiss] ;
            [MBProgressHUD showError:@"报事失败"] ;
            NSLog(@"网络请求失败失败%@",error);
        }];
        
    }
}


#pragma mark -custom view
- (void)createUI
{
    [self.view addSubview:self.mScrollView];
    [self.mScrollView addSubview:self.headView];
    _imgPicker = [[UIImageLibraryPicker alloc] init];
    _imgPicker.limitCount = 9;
    _imgPicker.delegate = self;
    [self.mScrollView addSubview:self.bottomView];
    [self.mScrollView setContentSize:CGSizeMake(VIEW_W(self.view), VIEW_BY(_bottomView)+15)];
}

//选取完照片展示
-(void)createShouImageView
{
    for (int i = 0; i<_picsArray.count; i++) {
        _ShouImageView = [[UIImageView alloc]initWithFrame:CGRectMake((10 + kImageHeight) * (i%3), (10 + kImageHeight) * (i/3), kImageHeight, kImageHeight)];
        _ShouImageView.image = _picsArray[i];
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake((10 + kImageHeight) * (i%3), (10 + kImageHeight) * (i/3), kImageHeight, kImageHeight)];
        bt.tag = i;
        bt.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //  [bt setImage:imgFace forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(actionShowAllImage:) forControlEvents:UIControlEventTouchUpInside];
        [_imageScrollView addSubview:bt];
    }
    [_imageScrollView addSubview:_ShouImageView];
    int count=_picsArray.count;
    if(count<9)
        _shotBtn.frame = CGRectMake((10 + kImageHeight) * (count%3), (10 + kImageHeight) * (count/3), kImageHeight, kImageHeight);
    [self adjustFrame];
}

//删除图片后再次展示
-(void)createImageScrollView
{
    [_imageScrollView removeFromSuperview];
    _imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, VIEW_BY(_textView)+10, VIEW_W(self.view) - 20, 100)];
    _imageScrollView.bounces = NO;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.showsVerticalScrollIndicator = NO;
    _imageScrollView.contentSize = CGSizeMake(VIEW_W(self.view) - 20, 100);
    [self.headView addSubview:_imageScrollView];
    for (int i = 0; i<_picsArray.count; i++) {
        UIImageView *ShouImageView = [[UIImageView alloc] initWithFrame:CGRectMake((10 + kImageHeight) * (i%3), (10 + kImageHeight) * (i/3), kImageHeight, kImageHeight)];
        ShouImageView.image = _picsArray[i];
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake((10 + kImageHeight) * (i%3), (10 + kImageHeight) * (i/3), kImageHeight, kImageHeight)];
        bt.tag = i;
        bt.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [bt addTarget:self action:@selector(actionShowAllImage:) forControlEvents:UIControlEventTouchUpInside];
        [_imageScrollView addSubview:ShouImageView];
        [_imageScrollView addSubview:bt];
    }
    _shotBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    int count=_picsArray.count;
    _shotBtn.frame=CGRectMake((10 + kImageHeight) * (count%3), (10 + kImageHeight) * (count/3), kImageHeight, kImageHeight);
    [_shotBtn setBackgroundImage:[UIImage imageNamed:@"baoshi_pic"] forState:UIControlStateNormal];
    [_shotBtn addTarget:self action:@selector(onClickAddImageButton) forControlEvents:UIControlEventTouchUpInside];
    [_imageScrollView addSubview:_shotBtn];
    
    [self adjustFrame];
}


#pragma mark -loadData
-(void)loadData
{
    _picsArray=[NSMutableArray arrayWithCapacity:0];
    _viewShowing =[NSMutableArray arrayWithCapacity:0];
    NSDictionary *dict=@{@"User_id":[USER_DEFAULT objectForKey:kUserId],@"Community_id":[USER_DEFAULT objectForKey:kCommunityId]};
    [HttpService postWithServiceCode:@"Reg_Space_List" params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict =(NSDictionary*)jsonObj;
        if([dict validateOk])
        {
            NSLog(@"%@",jsonObj);
            self.dataArray =[[dict objectForKey:@"Data"] objectForKey:@"Spaces"];
        }
        
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

#pragma mark -Custom Accessor
//底部 scrollView 容器
- (UIScrollView*)mScrollView
{
    if(!_mScrollView){
        _mScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(Origin_x, 64, VIEW_W(self.view), VIEW_H(self.view)-NavigationBar_HEIGHT-StatusBar_Height)];
        _mScrollView.userInteractionEnabled=YES;
        _mScrollView.showsHorizontalScrollIndicator = NO;
        _mScrollView.showsVerticalScrollIndicator = NO;
    }
    return _mScrollView;
}

-(UIView*)headView
{
    if(!_headView){
        _headView =[[UIView alloc] initWithFrame:CGRectMake(Origin_x, 10, VIEW_W(self.view), 260)];
        _headView.backgroundColor=[UIColor whiteColor];
        NSArray *styleArray=[self.style componentsSeparatedByString:@","];
        NSString *styleImage=styleArray[1];
        NSString *title=styleArray[0];
        self.typeID=styleArray[2];
        CGFloat leftMargin=10;
        CGFloat topMargin=10;
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(leftMargin, topMargin, 40, 40)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:styleImage] placeholderImage:nil];
        //        UIImageView *imageView =[UIImageView createImageViewWithFrame:CGRectMake(leftMargin, topMargin, 40, 40) imageName:styleImage];
        
        UILabel *typeLabel=[UILabel labelWithFrame:CGRectMake(VIEW_BX(imageView)+10, 20, 200, 20) title:title fontSize:18.0f background:CLEARCOLOR];
        [_headView addSubview:imageView];
        [_headView addSubview:typeLabel];
        
        _textView =[[UITextView alloc] initWithFrame:CGRectMake(leftMargin, VIEW_BY(imageView)+10, VIEW_W(self.view)-2*leftMargin, 100)];
        _textView.tintColor=HexRGB(0x999999);
        _textView.textColor=HexRGB(0x666666);
        _textView.delegate=self;
        _textView.font=[UIFont systemFontOfSize:16.0f];
        _textView.layer.cornerRadius=10.0;
        _textView.layer.masksToBounds=YES;
        _textView.autocorrectionType= UITextAutocorrectionTypeNo;
        _hintLabel =[[UILabel alloc]initWithFrame:CGRectMake(leftMargin+5, VIEW_BY(imageView)+15, VIEW_W(_textView)-30,20)];
        _hintLabel.text=@"请您描述一下报事详情吧...";
        _hintLabel.enabled=NO;
        _hintLabel.textColor=HexRGB(0x999999);
        _hintLabel.backgroundColor=CLEARCOLOR;
        [_headView addSubview:_textView];
        [_headView addSubview:_hintLabel];
        [_headView addSubview:self.imageScrollView];
        _headView.frame=CGRectMake(Origin_x, 10, VIEW_W(self.view), VIEW_BY(_imageScrollView)+10);
    }
    return _headView;
}

-(UIView*)bottomView
{
    if(!_bottomView)
    {
        _bottomView =[[UIView alloc]init];
        __weak BaoShiDetailViewController *weakSelf=self;
        //报事地址
         NSString * spacename = [[NSString alloc]init];

            spacename = [USER_DEFAULT objectForKey:kSpace_name];

        _address =[ListCellView viewWithFramea:CGRectMake(Origin_x, Origin_y, VIEW_W(self.view), 50) andImagea:@"weiwofuwu_location_green" andTitlea:spacename andBlocka:^{
//            
//            FileUtil *fileUt = [[FileUtil alloc]init];
//            NSString *plistPath = [fileUt getDocumentFilePath:REPAIRADDRESSPLIST];
//            
//            _picsArray=[NSMutableArray arrayWithCapacity:0];
//            _viewShowing =[NSMutableArray arrayWithCapacity:0];
//            
//            if ([fileUt file_exists:plistPath]) {
//                
//                self.dataArray = [NSArray arrayWithContentsOfFile:plistPath];
//                HBCustomActionSheetView *customActionView =[[HBCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:weakSelf.dataArray andAddressPickControllrtBlock:^(NSString *address,NSString *spaceID) {
//                    weakSelf.address.title.text=address;
//                    weakSelf.spaceID=spaceID;
//                    weakSelf.rightBtn.enabled=YES;
//                    
//                }];
//                
//                [customActionView show];
//                
//            }else{
            
            [SVProgressHUD showInView:self.view status:@"加载中..."] ;
//            {
//                "Community_id" = "13319532-57C7-481E-922E-00D651B3151A";
//                "User_id" = "14672A3C-E317-D9DE-9973-0F3DA66AB8F3";
//            }
            
//              NSDictionary *dict=@{@"User_id":[USER_DEFAULT objectForKey:kUserId],@"Community_id":@"YZ8600PEK01GMWYGMYJY0"};
            NSDictionary *dict=@{@"User_id":[USER_DEFAULT objectForKey:kUserId],@"Community_id":[USER_DEFAULT objectForKey:kCommunityId]};

                [HttpService postWithServiceCode:@"Reg_Space_List" params:dict success:^(AFHTTPRequestOperation *operation, id jsonObj) {
                    
                    [SVProgressHUD dismiss];
                    NSDictionary *dict =(NSDictionary*)jsonObj;
                      NSLog(@"%@",jsonObj);
                    if([dict validateOk])
                    {
                       [SVProgressHUD dismiss] ;
                        self.dataArray =[[dict objectForKey:@"Data"] objectForKey:@"Spaces"];
//                        [self.dataArray writeToFile:plistPath atomically:YES];
                        
                        HBCustomActionSheetView *customActionView =[[HBCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andData:weakSelf.dataArray andAddressPickControllrtBlock:^(NSString *address,NSString *spaceID) {
                            weakSelf.address.title.text=address;
                            weakSelf.spaceID=spaceID;
                            weakSelf.rightBtn.enabled=YES;
                            if (address !=nil) {
                                [USER_DEFAULT setObject:address forKey:@"BaoShi_SpaceName"] ;
                                [USER_DEFAULT setObject:spaceID forKey:@"BaoShi_SpaceID"] ;
                            }
                            
                        }];
//                        HBCustomActionSheetView * customActionView = [[HBCustomActionSheetView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andtitle:@"请选择报事地点" andData:weakSelf.dataArray andBuildingPickControllrtBlock:^(NSString *building, NSString *spaceid) {
//                            weakSelf.address.title.text=building;
//                            weakSelf.spaceID=spaceid;
//                            weakSelf.rightBtn.enabled=YES;
//                            
//                        }];
                        
                        
                        [customActionView show];
                        
                    }else{
                        [SVProgressHUD dismiss];
                      [ProgressHUD showUIBlockingIndicatorWithText:@"数据加载失败" withTimeout:1.5f] ;
                    }
                    
                } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD dismiss] ;
                   [ProgressHUD showUIBlockingIndicatorWithText:@"网络请求失败" withTimeout:1.5f] ;
                    NSLog(@"%@",error);
                    
                }];
                
                
//            }
            
        }];
        
        _address.backgroundColor =[UIColor whiteColor];
        
        //预约开始时间
        _time = [ListCellView viewWithFramea:CGRectMake(Origin_x, VIEW_BY(_address)+5, VIEW_W(self.view), 50) andImagea:@"weiwofuwu_time_start" andTitlea:@"预约开始时间" andBlocka:^{
            
            HBCustomActionSheetView *customActionView =[[HBCustomActionSheetView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andDatePickControllerBlock:^(NSString *dateStr,NSString *dateTime) {
                
                weakSelf.rightBtn.enabled = YES;
                weakSelf.time.title.text = dateStr;
                
                NSDateFormatter* dateFormatter=[DateUtil dateFormatter];
                             [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
                
                NSDate *date =[dateFormatter dateFromString:dateTime];
                //                NSDate *twoDate =[dateFormatter dateFromString:date2Str];
                double startTimeInterval;
                if ([dateStr isEqualToString:@"今天 即刻"]) {
                                       startTimeInterval = [[self GetNowTimes] floatValue];
                    
                }else{
                    startTimeInterval = [date  timeIntervalSince1970];
                }
                
                //                double endTimeInterval =[twoDate timeIntervalSince1970];
             
                weakSelf.startTime =[NSString stringWithFormat:@"%.0f",startTimeInterval];
                //                weakSelf.endTime =[NSString stringWithFormat:@"%f",endTimeInterval];
                
                //                NSLog(@"Time----%@---%@",date,twoDate);
                NSLog(@"开始时间----%@---",weakSelf.startTime);
            } Message:@"预约开始时间"];
            [customActionView show];
        }];
        
        _time.backgroundColor =[UIColor whiteColor];
        [_bottomView addSubview:_address];
        [_bottomView addSubview:_time];
        
        
        
        //预约结束时间
        _endTimesView = [ListCellView viewWithFramea:CGRectMake(Origin_x, VIEW_BY(_time)+5, VIEW_W(self.view), 50) andImagea:@"weiwofuwu_time_end" andTitlea:@"预约结束时间" andBlocka:^{
            
            HBCustomActionSheetView *customActionView =[[HBCustomActionSheetView alloc] initWithEndTimeFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 216+30+80+20) andDatePickControllerBlock:^(NSString *dateStr,NSString *dateTime) {
                
                weakSelf.rightBtn.enabled = YES;
                weakSelf.endTimesView.title.text = dateStr;
                
                NSDateFormatter* dateFormatter=[DateUtil dateFormatter];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
                
                NSDate *date =[dateFormatter dateFromString:dateTime];
                //                NSDate *twoDate =[dateFormatter dateFromString:date2Str];
                
                double endTimeInterval =[date timeIntervalSince1970];
                
                weakSelf.endTime =[NSString stringWithFormat:@"%.0f",endTimeInterval];
                
                //                NSLog(@"Time----%@---%@",date,twoDate);
                NSLog(@"结束时间-------%@",weakSelf.endTime);
            } Message:@"预约结束时间"];
            
            [customActionView show];
        }];
        
        _endTimesView.backgroundColor =[UIColor whiteColor];
        [_bottomView addSubview:_endTimesView];
        _bottomView.frame = CGRectMake(Origin_x, VIEW_BY(self.headView)+10, VIEW_W(self.view), VIEW_BY(_endTimesView)+10);
        _bottomView.userInteractionEnabled=YES;
    }
    return _bottomView;
}


-(NSString *)GetNowTimes

{
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeInterval];
    
    return timeString;
}

-(UIScrollView*)imageScrollView
{
    if(!_imageScrollView)
    {
        _imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, VIEW_BY(_textView)+10, self.view.frame.size.width - 20, kImageHeight+20)];
        
        _imageScrollView.bounces = NO;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.contentSize = CGSizeMake(self.view.frame.size.width - 20, 100);
        
        _shotBtn =[UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(10, 10, kImageHeight, kImageHeight) andTitle:@"" andBackgroundImage:@"baoshi_pic" andHandleEvent:UIControlEventTouchUpInside andCompletionBlcok:^{
            
            [self.view endEditing:YES];
            _imgPicker.limitCount = 9-_picsArray.count;
            [_imgPicker execute];
            
        }];
        [_imageScrollView addSubview:_shotBtn];
    }
    return _imageScrollView;
    
}
#pragma mark -private method

//调整选取照片后的frame
-(void)adjustFrame
{
    CGFloat leftMargin=10;
    CGFloat y_middleMargin=10;
    int num=3;
    NSInteger count=(_picsArray.count==9)?(_picsArray.count-1):_picsArray.count;
    NSInteger line =count/num+1;
    _imageScrollView.frame=CGRectMake(leftMargin, VIEW_BY(_textView)+10, VIEW_W(self.view)-20, 10+line*kImageHeight+(line-1)*y_middleMargin+10);
    _headView.frame=CGRectMake(Origin_x, 10, VIEW_W(self.view), VIEW_BY(_imageScrollView)+10);
    _bottomView.frame=CGRectMake(Origin_x, VIEW_BY(_headView)+10, VIEW_W(self.view), VIEW_BY(_endTimesView)+10);
    [self.mScrollView setContentSize:CGSizeMake(VIEW_W(self.view), VIEW_BY(self.bottomView)+25)];
}

-(void)actionShowAllImage:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    VShowImgs *s = [[VShowImgs alloc] initWithFrame:[UIScreen mainScreen].bounds];
    s.imgs = _picsArray;
    s.index = sender.tag;
    s.delegate = self;
    [s show];
}

-(void)onClickAddImageButton
{
    _imgPicker.limitCount = 9-_picsArray.count;
    [_imgPicker execute];
}

#pragma mark - ImageLibraryPickerDelegate
-(void)imagePicker:(UIImageLibraryPicker *)picker didFinished:(NSString *)path
{
    [_picsArray addObject:[UIImage imageWithContentsOfFile:path]];
    [self createShouImageView];
}

#pragma mark － VShowimgs delegate
-(void)VShowImgs:(VShowImgs *)showimgs deletetag:(NSInteger)index
{
    _picsArray = showimgs.imgs;
    if(_picsArray.count==0)
        
        NSLog(@"picArray%@",_picsArray);
    [self createImageScrollView];
}


#pragma  mark --UITextViewDelegate
-(BOOL)textView:(UITextView *)textView  shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL isReturn=NO;
    if (range.location>=100){
        NSString *memo = [textView.text substringWithRange:NSMakeRange(0, 100)];
        textView.text=memo;
        isReturn = NO;
    }
    else
    {
        isReturn= YES;
    }
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        isReturn= NO;
    }
    else{
        isReturn=YES;
    }
    
    return isReturn;
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.hintLabel.text = @"请您描述一下报事详情吧...";
    }else{
        self.hintLabel.text = @"";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    self.tabBarController.tabBar.hidden = YES;
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
