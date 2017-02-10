//
//  ChangeAddressController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "ChangeAddressController.h"
#import "AddressManager.h"
#import "SelectionCellViewController.h"
@interface ChangeAddressController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *communitiesArray;
@property(nonatomic,strong) UITableView * tableView ;
@property(nonatomic,weak)UIView *buttonView;
@property(nonatomic,copy)NSString *plistPath;

@end

@implementation ChangeAddressController


-(NSMutableArray *)communitiesArray
{
    if (!_communitiesArray) {
        _communitiesArray = [NSMutableArray array] ;
    }
    return _communitiesArray ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    self.buttonView.hidden = NO;
 [self.tableView.header beginRefreshing] ;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    self.buttonView.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"切换项目"];
    [self creatUI];
    [self createTableView] ;
//    [self isFilePath];

}

-(void)creatUI
{
    UIView *buttonView = [[UIView alloc]init];
    buttonView.backgroundColor = RGBCOLOR(226, 226, 226);
    
    CGFloat marginX = 20;
    CGFloat marginY = 10;
    CGFloat buttonVH = 60;
    CGFloat buttonVY = VIEW_H(self.view) - buttonVH ;
    CGFloat addBtnW = VIEW_W(self.view) - 2*marginX;
    CGFloat addBtnH = buttonVH - 2*marginY;
    buttonView.frame = CGRectMake(Origin_x, buttonVY, VIEW_W(self.view), buttonVH);
    
    [self.navigationController.view addSubview:buttonView];
    self.buttonView = buttonView;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateHighlighted];
    addButton.backgroundColor = [UIColor colorWithHexString:@"#a6873b"];
    addButton.frame = CGRectMake(marginX, marginY, addBtnW, addBtnH);
    [addButton addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:addButton];
    
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREENWIDTH, VIEW_H(self.view)-NavigationBar_HEIGHT-60) style:UITableViewStylePlain];
    _tableView.delegate = self ;
    _tableView.dataSource =self ;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
    [self.view addSubview:_tableView];
}

-(void)addLabelAddress
{
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"您还没有添加地址~";
    [tipLabel setTextColor:[UIColor colorWithHexString:@"#a6873b"] ];
    [tipLabel setFont:[UIFont systemFontOfSize:18]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    CGFloat tipH = 50;
    CGFloat tipY = (VIEW_H(self.view)-tipH-64-49)/2;
    tipLabel.frame = CGRectMake(Origin_x, tipY, VIEW_W(self.view), tipH);
    [self.view addSubview:tipLabel];
    
}


-(void)isFilePath
{
    
    FileUtil *fileUt = [[FileUtil alloc]init];
    NSString *plistPath = [fileUt getDocumentFilePath:CHANGEADDRESSPLIST];
    
    self.plistPath = plistPath;
    
    if (![fileUt file_exists:plistPath]) {
        
        [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
        [self.tableView.header beginRefreshing];
        
    }else{
        
        [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshings)];
        self.communitiesArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
        [self.tableView reloadData];
    }
}

-(void)headerRefreshings
{
    [self loadData];
}


-(void)loadData
{
    NSDictionary *dictParam = @{@"User_id":[USER_DEFAULT objectForKey:kUserId],@"Community_id":@""};
    [HttpService postWithServiceCode:kReg_Space_List params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
        NSDictionary *dict = (NSDictionary *)jsonObj;
        NSDictionary *dictData = [dict objectForKey:@"Data"];
        NSLog(@"------------%@",dictData) ;
        [self.tableView.header endRefreshing];
        if ([dict validateOk]) {
            FileUtil *fileUt = [[FileUtil alloc]init];
            if (self.communitiesArray.count>0) {
                [self.communitiesArray removeAllObjects];
            }
            
            for (NSDictionary * dic in dictData[@"Spaces"]) {
                AddressManager * addressM = [AddressManager modelWithDic:dic] ;
                [self.communitiesArray addObject:addressM];
               
            }
            
            if ([fileUt file_exists:self.plistPath]) {
                
                [[NSFileManager defaultManager]removeItemAtPath:self.plistPath error:nil];
            }
            
            //如果有数据就移除提示label,并展示数据
            
            //如果没有数据，就显示暂无数据
            if (self.communitiesArray.count > 0) {
                
                [self.tableView reloadData];
                [self.communitiesArray writeToFile:self.plistPath atomically:YES];
            }else{
                [self addLabelAddress];
            }
            [self.tableView reloadData];
        }else{
            if ([[dict objectForKey:@"Message"] isEqualToString:@"user not select address"]) {
                  [self addLabelAddress];
            }
        
        }
    } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"加载失败，请刷新重试"] ;
        [self addLabelAddress];
    }];
}



-(void)clickAddBtn
{
    self.hidesBottomBarWhenPushed =YES ;
    SelectionCellViewController *selectionCell = [[SelectionCellViewController alloc]init];
    [self.navigationController pushViewController:selectionCell animated:YES];
}

#pragma -mark tablecviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.communitiesArray.count ;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"changeAddress";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    UIView *downView = [[UIView alloc]init];
    downView.frame = CGRectMake(Origin_x, cell.height-5, VIEW_W(self.view), 5);
    downView.backgroundColor = RGBCOLOR(226, 221, 215);
    [cell.contentView addSubview:downView];
    
    AddressManager *addressM = (AddressManager *) self.communitiesArray[indexPath.row];
    cell.textLabel.text = addressM.Space_name;
    cell.textLabel.numberOfLines = 0 ;
    cell.textLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
    NSInteger a = [[str string] rangeOfString:@"【"].location;
    NSInteger b = [[str string] rangeOfString:@"】"].location;
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#a6873b"] range:NSMakeRange(a+1,b-a-1)];
     CGFloat  fon = [SizeUtility textFontSize:default_Sub_Express_title_size] ;
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fon+1] range:NSMakeRange(a+1,b-a-1)];
    cell.textLabel.attributedText = str;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressManager *addressM = self.communitiesArray[indexPath.row];
    NSString *space_id = addressM.Space_id;
    NSString *space_name = addressM.Space_name;
    NSString *community_id = addressM.Community_id;
    NSString *community_name = addressM.Community_name;
    NSString *community_valid_status = addressM.Community_valid_status;
    NSString * Address_valid_status = addressM.Address_valid_status ;
    NSString *community_status = addressM.Community_status;
    [USER_DEFAULT setObject:space_id forKey:kSpace_id];
    [USER_DEFAULT setObject:space_name forKey:kSpace_name];
    [USER_DEFAULT setObject:community_id forKey:kCommunityId];
    [USER_DEFAULT setObject:community_name forKey:kCommunity_name];
    [USER_DEFAULT setObject:community_valid_status forKey:kCommunity_valid_status];
    [USER_DEFAULT setObject:community_status forKey:kCommunity_status];
    [USER_DEFAULT setObject:Address_valid_status forKey:kAddress_valid_status];
    [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationReloDataHome object:nil userInfo:nil];

    [USER_DEFAULT synchronize];
    [self.navigationController popViewControllerAnimated:YES];

}



//
//-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
//
//{
//    
//    //如果是删除
//    
//    if(editingStyle==UITableViewCellEditingStyleDelete)
//        
//    {
//        
//        //点击删除按钮调用这里的代码
//        
//        //        1.数据源删除
//        
//        //        @[indexPath]=[NSArray arrayWithObjects:indexPath,nil];
//        
//        NSMutableArray*subArray =  _communitiesArray[indexPath.section];
//        
//        [subArray removeObjectAtIndex:indexPath.row];
//        
//        //        2.UI上删除
//        
//        //删除表视图的某个cell
//        
//        /*
//         
//         第一个参数：将要删除的所有的cell的indexPath组成的数组
//         
//         第二个参数：动画
//         
//         */
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//        //将整个表格视图刷新也可以实现在UI上删除的效果，只不过它要重新执行一遍所有的方法，效率很低
//        
//        //        [tableView reloadData];
//        
//    }
//    
//}
//
////修改删除按钮为中文的删除
//
//-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
//
//{
//    
//    return@"删除";
//    
//}
//
////是否允许编辑行，默认是YES
//
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    return YES;
//    
//}




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
