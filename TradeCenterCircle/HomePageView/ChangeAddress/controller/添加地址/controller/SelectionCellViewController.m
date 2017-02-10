//
//  SelectionCellViewController.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/12/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "SelectionCellViewController.h"
#import "CommunityList.h"
#import "SelectionViewCell.h"
#import "HouseholdViewController.h"
@interface SelectionCellViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
//搜索条
@property(nonatomic,weak)UISearchBar * MySearchBar ;
@property(nonatomic,weak)UIView *bgView;
@property(nonatomic,weak)UIImageView *imageView;
@property(nonatomic,assign)int count;
@property(nonatomic,strong)UITableView *selectionTable;
@property(nonatomic,strong)NSMutableArray *selectionArr;

@end

@implementation SelectionCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"选择项目"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI] ;
}

-(UITableView *)selectionTable
{
    if (!_selectionTable) {
        _selectionTable = [[UITableView alloc]init];
    }
    return _selectionTable ;
}
-(NSMutableArray *)selectionArr
{
    if (!_selectionArr) {
        _selectionArr = [NSMutableArray array] ;
    }
    return _selectionArr ;
}
-(void)createUI
{
    [self screenWidth] ;
    [self creatMySearchBar] ;
    [self creatImageView] ;
    [self creatBtn] ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES ;
}
-(void)screenWidth
{
    if (SCREENWIDTH == 320) {
        self.count = 1;
    }else{
        self.count = 2;
    }
}
//房间列表
-(void)creatTable
{
    
    CGFloat margin = 10;
    CGFloat tableW = VIEW_W(self.view) - 2*margin;
    UITableView *selectionTable = [[UITableView alloc]init];
    selectionTable.rowHeight = 60;
    selectionTable.dataSource = self;
    selectionTable.delegate = self;
    CGFloat tableH = self.selectionArr.count * selectionTable.rowHeight;
    if (tableH > self.view.bounds.size.height) {
        tableH = self.view.bounds.size.height;
    }
    selectionTable.frame = CGRectMake(margin, VIEW_BY(self.bgView)+margin, tableW, tableH);
    
    self.selectionTable = selectionTable;
    [self.view addSubview:selectionTable];
}

-(void)creatMySearchBar
{
    CGFloat marginX = 10;
    CGFloat marginY = 10;
    CGFloat searchW = VIEW_W(self.view)-2*marginX;
    CGFloat searchH = 30;
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = RGBCOLOR(230, 230, 230);
    bgView.frame = CGRectMake(Origin_x, Origin_y+64, VIEW_W(self.view), searchH+2*marginY);
    self.bgView = bgView;
  [self.view addSubview:bgView];
    UISearchBar * MySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(marginX, marginY, searchW, searchH)];
    MySearchBar.delegate = self ;
    MySearchBar.barStyle = UISearchBarStyleDefault ;
    [MySearchBar setShowsCancelButton:NO];
    MySearchBar.keyboardType  =UIKeyboardTypeNamePhonePad ;
    //iOS7.1
    [[[[ MySearchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0 ] removeFromSuperview];
    [ MySearchBar setBackgroundColor :[UIColor clearColor]];
    MySearchBar.placeholder = @"输入关键字搜索项目";
    self.MySearchBar = MySearchBar;
    [bgView addSubview:MySearchBar] ;
    
}

-(void)creatImageView
{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"xuanzexiaoqu_chatu"] ;
    CGFloat marginX = (VIEW_W(self.view) - self.count * imageView.image.size.width)/2;
    CGFloat marginY = VIEW_BY(self.bgView)+30;
    imageView.frame = CGRectMake(marginX, marginY, self.count *imageView.image.size.width,self.count *imageView.image.size.height);
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

-(void)creatBtn
{
    CGFloat margin = 30;
    CGFloat locationBtnY = VIEW_BY(self.imageView) + margin*2+40;
    CGFloat locationBtnW = VIEW_W(self.view) - 2*margin;
    CGFloat locationBtnH = 40;
    
    //定位按钮
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setTitle:@"定位附近项目" forState:UIControlStateNormal];
    locationBtn.backgroundColor = RGBCOLOR(23, 168, 145);
    locationBtn.frame = CGRectMake(margin, locationBtnY, locationBtnW, locationBtnH);
    [locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [locationBtn addTarget:self action:@selector(clickLocationBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:locationBtn];
    
}

-(void)clickLocationBtn
{
    NSLog(@"定位功能暂不开启") ;
    
}


#pragma -mark  serachBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.selectionTable removeFromSuperview];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(self.MySearchBar.text.length >= 2)
    {
        NSDictionary *dictParam = [[NSDictionary alloc]init];
        dictParam = @{kLat:@"0",kLng:@"0",kKeyword:self.MySearchBar.text,kType:@"2"};
        [HttpService postWithServiceCode:kSelect_Community params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
            
            NSDictionary * dic = (NSDictionary*)jsonObj;
            
            NSLog(@"%@",jsonObj);
            if ([dic validateOk]) {
                [self.selectionTable removeFromSuperview];
                NSDictionary *dataDict = [dic objectForKey:@"Data"];
//                self.selectionArr = [dataDict objectForKey:@"Community_list"];
                if (self.selectionArr.count>0) {
                    [self.selectionArr removeAllObjects];
                }
                for (NSDictionary * dic in dataDict[@"Community_list"]) {
                    CommunityList * model = [CommunityList modelWithDic:dic] ;
                    [self.selectionArr addObject:model];
                }

                NSLog(@"selection %@",self.selectionArr);
                [self creatTable];
            }
            else{
                
                NSString *message = [dic objectForKey:@"Message"];
                NSLog(@"message %@",message);
                if ([message isEqualToString:@"No data"]) {
                    [MBProgressHUD showError:@"没有数据"];
                }
            }
        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ %@",[error description],operation.responseString);
        }];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    if (searchText.length >= 2) {
        NSDictionary *dictParam = [[NSDictionary alloc]init];
        dictParam = @{kLat:@"0",kLng:@"0",kKeyword:self.MySearchBar.text,kType:@"2"};
        [HttpService postWithServiceCode:kSelect_Community params:dictParam success:^(AFHTTPRequestOperation *operation, id jsonObj) {
            
            NSDictionary * dic = (NSDictionary*)jsonObj;
            
            NSLog(@"%@",jsonObj);
            if ([dic validateOk]) {
                [self.selectionTable removeFromSuperview];
                NSDictionary *dataDict = [dic objectForKey:@"Data"];
//                self.selectionArr = [dataDict objectForKey:@"Community_list"];
                if (self.selectionArr.count>0) {
                    [self.selectionArr removeAllObjects];
                }
                for (NSDictionary * dic in dataDict[@"Community_list"]) {
                    CommunityList * model = [CommunityList modelWithDic:dic] ;
                    [self.selectionArr addObject:model];
                }
                NSLog(@"selection %@",self.selectionArr);
                [self creatTable];
            }
            else{
                
                //                NSString *message = [dic objectForKey:@"Message"];
                //                NSLog(@"message %@",message);
                //                if ([message isEqualToString:@"No data"]) {
                //                    [MBProgressHUD showError:@"没有数据"];
                //                }
            }
        } errorBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@ %@",[error description],operation.responseString);
        }];
    }
    
}

#pragma  -mark  tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectionArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityList *list = self.selectionArr[indexPath.row];
    SelectionViewCell *cell = [SelectionViewCell cellWithTableView:tableView];
    
    cell.titleName.text = list.Community_name;
    cell.addressName.text = list.Address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityList *list = self.selectionArr[indexPath.row];
    HouseholdViewController *houseVc = [[HouseholdViewController alloc]init];
    houseVc.cellTitle = list.Community_name;
    houseVc.Is_standard_community = list.Is_standard_community;
    houseVc.Community_id = list.Community_id;
    self.MySearchBar.text = list.Community_name;
    houseVc.isFromSelected = YES ;
    [self.selectionTable removeFromSuperview];
    [self.navigationController pushViewController:houseVc animated:YES];
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
