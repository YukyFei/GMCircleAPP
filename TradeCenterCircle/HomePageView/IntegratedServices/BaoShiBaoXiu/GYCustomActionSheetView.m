//
//  GYCustomActionSheetView.m
//  TradeCenterCircle
//
//  Created by 张广义 on 2016/11/11.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "GYCustomActionSheetView.h"
#import "NSString+SizeLayout.h"
#import "DateUtil.h"
#import "TimeModel.h"
#import "FileUtil.h"

@interface GYCustomActionSheetView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UILabel *titleLabel;
}

//选择的日期
@property(nonatomic,copy)NSString *dateStr;
@property(nonatomic,copy)NSString *dateTime;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)NSArray *timeArr;

@property (nonatomic,strong) NSMutableArray  *yearOneArr;    //年份列表_起
@property(nonatomic,strong)NSMutableArray *yearOneTimeArray;//真实时间
@property (strong, nonatomic) NSArray *yearTwoArr;
@property (strong, nonatomic) NSArray *mutableTime;//时间点
@property(nonatomic,strong)NSArray *yearTwoTimeArray;//真实时间点

@property(nonatomic,strong)UIPickerView *addressPicker;
@property(nonatomic,strong)NSArray *addressArray;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *spaceID;
@property(nonatomic,strong)NSString *spaceType;

@property(nonatomic,assign)NSInteger row;
@property(nonatomic,copy)NSString *filePath;

@property (nonatomic, assign) NSInteger selectDayIndex;
@end


@implementation GYCustomActionSheetView

@synthesize viewControl;


-(UIPickerView*)addressPicker
{
    if(!_addressPicker)
    {
        _addressPicker =[[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, VIEW_W(view),120)];
        _addressPicker.showsSelectionIndicator = YES;
        _addressPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _addressPicker.delegate=self;
        _addressPicker.dataSource=self;
    }
    return _addressPicker;
}

-(UIPickerView*)pickView
{
    if(!_pickView)
    {
        _pickView =[[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, VIEW_W(view),120)];
        _pickView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _pickView.delegate=self;
        _pickView.dataSource=self;
        
    }
    return _pickView;
}
-(NSArray *)timeArr{
    
    if (_timeArr == nil) {
        
        NSString *filePath = self.filePath;
        
        
        NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        
        for (NSDictionary *dict in arr) {
            
            TimeModel *time = [TimeModel timeWithDict:dict];
            
            [arrM addObject:time];
            
        }
        
        
        _timeArr = arrM;
        
    }
    
    return _timeArr;
    
}
-(NSDate*)dateWithInterval:(int)interval
{
    return [NSDate dateWithTimeInterval:interval*24*60*60 sinceDate:[NSDate date]];
}

-(NSString*)timeWithFormatInDayNum:(int)num
{
    NSDateFormatter *dateFormatter =[DateUtil dateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:[self dateWithInterval:num]];
}

-(NSString*)descriptionWithIntervel:(int)num
{
    NSDateFormatter *dateFormatter =[DateUtil dateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr0=[dateFormatter stringFromDate:[self dateWithInterval:0]];
    NSString *str0=[dateStr0 componentsSeparatedByString:@"-"][1];
    if (num==0) {
        return @"今天";
    }
    else if(num==1)
    {
        return @"明天";
    }
    else if (num==2)
    {
        return @"后天";
    }
    else
    {
        NSString *dateStr=[dateFormatter stringFromDate:[self dateWithInterval:num]];
        NSArray *arrStr=[dateStr componentsSeparatedByString:@"-"];
        NSString *str1=arrStr[1];
        if([str1 isEqualToString:str0])
        {
            return  [NSString stringWithFormat:@"%@号",arrStr[2]];
        }
        else
        {
            return [NSString stringWithFormat:@"下月%@号",arrStr[2]];
        }
    }
    return @"";
}

-(void)configData
{
    _dateStr=@"";
    _yearOneTimeArray =[NSMutableArray arrayWithCapacity:0];
    
    _yearOneArr=[NSMutableArray arrayWithCapacity:0];
    _yearTwoArr =@[@"午夜0:00",
                   @"凌晨1:00",
                   @"凌晨2:00",
                   @"凌晨3:00",
                   @"凌晨4:00",
                   @"早晨5:00",
                   @"早晨6:00",
                   @"上午7:00",
                   @"上午8:00",
                   @"上午9:00",
                   @"上午10:00",
                   @"中午11:00",
                   @"中午12:00",
                   @"下午1:00",
                   @"下午2:00",
                   @"下午3:00",
                   @"下午4:00",
                   @"下午5:00",
                   @"下午6:00",
                   @"晚上7:00",
                   @"晚上8:00",
                   @"晚上9:00",
                   @"晚上10:00",
                   @"午夜11:00"];
    
    for(int i=0;i<7;i++)
    {
        [_yearOneArr addObject:[self descriptionWithIntervel:i]];
        [_yearOneTimeArray addObject:[self timeWithFormatInDayNum:i]];
    }
    _yearTwoTimeArray=@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
}

//报事地址选择
-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray*)array andAddressPickControllrtBlock:(AddressPickerControllerBlock)block
{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor] ;
        _addressArray=[NSArray array];
        _addressArray=array;
        _addressBlock=[block copy];
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_W(self), frame.size.height-45-10-10)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        UILabel *label =[UILabel labelWithFrame:CGRectMake((VIEW_W(self)-100)/2, 20, 100, 20) withText:@"报事地址选择" withFont:[UIFont systemFontOfSize:16.0f] withTextColor:HexRGB(0x666666) withBackgroundColor:CLEARCOLOR];
        [view addSubview:label];
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 59.5, VIEW_W(self), 0.5)];
        lineView.backgroundColor=HexRGB(0x999999);
        [view addSubview:lineView];
        [view addSubview:self.addressPicker];
        
        if(array.count>1)
        {
            [_addressPicker selectRow:1 inComponent:0 animated:YES];
            self.address =[_addressArray[1] objectForKey:@"Space_name"];
            self.spaceID =[_addressArray[1] objectForKey:@"Space_id"];
        }
        if(array.count==1)
        {
            [_addressPicker selectRow:0 inComponent:0 animated:YES];
            self.address =[_addressArray[0] objectForKey:@"Space_name"];
            self.spaceID =[_addressArray[0] objectForKey:@"Space_id"];
        }
        selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //        selectBtn.frame=CGRectMake(Origin_x, VIEW_H(view)-45, VIEW_W(view), 45);
        /*******************x修改***************/
        selectBtn.frame=CGRectMake(Origin_x+10, VIEW_H(view)-45, VIEW_W(view)-20, 45);
        selectBtn.layer.cornerRadius=5.0f;
        selectBtn.layer.masksToBounds=YES;
        /****************************************/
        
        
        [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectBtn setBackgroundColor:[UIColor colorWithHexString:@"#a6873b"] ];
        [selectBtn addTarget:self action:@selector(selectClick2:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:selectBtn];
        
        cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(Origin_x+10, VIEW_H(self)-45-10, VIEW_W(self)-20, 45);
        cancelBtn.layer.cornerRadius=5.0f;
        cancelBtn.layer.masksToBounds=YES;
        [cancelBtn setBackgroundColor:[UIColor lightGrayColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#a6873b"]  forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
    }
    return self;
    
    
}

//选择楼层
-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray*)array andCellPickControllrtBlock:(CellPickerControllerBlock)block
{
    
    if(self = [super initWithFrame:frame])
    {
        _addressArray=[NSArray array];
        _addressArray=array;
        _CellBlock=[block copy];
      self.backgroundColor = [UIColor whiteColor] ;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_W(self), frame.size.height-45-10-10)];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        UILabel *label =[UILabel labelWithFrame:CGRectMake((VIEW_W(self)-100)/2, 20, 100, 20) withText:@"请选择" withFont:[UIFont systemFontOfSize:16.0f] withTextColor:HexRGB(0x666666) withBackgroundColor:CLEARCOLOR];
        [view addSubview:label];
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 59.5, VIEW_W(self), 0.5)];
        lineView.backgroundColor=HexRGB(0x999999);
        [view addSubview:lineView];
        [view addSubview:self.addressPicker];
        
        if(array.count>1)
        {
            [_addressPicker selectRow:1 inComponent:0 animated:YES];
            self.address =[_addressArray[1] objectForKey:@"Space_name"];
            self.spaceID =[_addressArray[1] objectForKey:@"Space_id"];
            self.spaceType = [_addressArray[1] objectForKey:@"Space_type"];
        }
        if(array.count==1)
        {
            [_addressPicker selectRow:0 inComponent:0 animated:YES];
            self.address =[_addressArray[0] objectForKey:@"Space_name"];
            self.spaceID =[_addressArray[0] objectForKey:@"Space_id"];
            self.spaceType = [_addressArray[0] objectForKey:@"Space_type"];
        }
        selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //        selectBtn.frame=CGRectMake(Origin_x, VIEW_H(view)-45, VIEW_W(view), 45);
        /*******************x修改***************/
        selectBtn.frame=CGRectMake(Origin_x+10, VIEW_H(view)-45, VIEW_W(view)-20, 45);
        selectBtn.layer.cornerRadius=5.0f;
        selectBtn.layer.masksToBounds=YES;
        /****************************************/
        
        [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectBtn setBackgroundColor:[UIColor colorWithHexString:@"#a6873b"] ];
        [selectBtn addTarget:self action:@selector(selectClick3:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:selectBtn];
        
        cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(Origin_x+10, VIEW_H(self)-45-10, VIEW_W(self)-20, 45);
        cancelBtn.layer.cornerRadius=5.0f;
        cancelBtn.layer.masksToBounds=YES;
        [cancelBtn setBackgroundColor:[UIColor lightGrayColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#a6873b"]  forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
    }
    return self;
    
    
}

//报事选择开始时间
-(id)initWithFrame:(CGRect)frame andDatePickControllerBlock:(DatePickerControllerBlock)block  Message:(NSString *)mes
{
    if(self = [super initWithFrame:frame])
    {
        [self configData];
        self.backgroundColor = [UIColor whiteColor] ;
        NSMutableArray *timeArr = [[NSMutableArray alloc]init];
        for (NSString *key in _yearOneArr) {
            NSMutableDictionary *day = [[NSMutableDictionary alloc ]init];
            if ([key isEqualToString:@"今天"]) {
                
                NSMutableArray *yearTwoArr;
                NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"HH"];
                NSString *currentTime = [formatter stringFromDate:[NSDate date]];
                int intTime = [currentTime intValue];
                NSRange range = NSMakeRange(0, intTime+1);
                yearTwoArr = [NSMutableArray arrayWithCapacity:0];
                [yearTwoArr addObjectsFromArray:_yearTwoArr];
                [yearTwoArr removeObjectsInRange:range];
                [yearTwoArr insertObject:@"即刻" atIndex:0];
                NSMutableArray *temp = [NSMutableArray arrayWithArray:yearTwoArr];
                [day setObject:key forKey:@"day"];
                [day setObject:temp forKey:@"time"];
                [timeArr addObject:day];
                
            }else{
                [day setObject:key forKey:@"day"];
                [day setObject:_yearTwoArr forKey:@"time"];
                [timeArr addObject:day];
            }
            
        }
        FileUtil *filePath = [[FileUtil alloc]init];
        
        NSString *path = [filePath getDocumentFilePath:@"time.plist"];
        self.filePath = path;
        
        [timeArr writeToFile:path atomically:YES];
        
        _datePickBlock=[block copy];
        view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, VIEW_W(self)-20, frame.size.height-10-45-10)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        UILabel *label =[UILabel labelWithFrame:CGRectMake((VIEW_W(self)-100)/2, 20, 100, 20) withText:mes withFont:[UIFont systemFontOfSize:16.0f] withTextColor:HexRGB(0x666666) withBackgroundColor:CLEARCOLOR];
        [view addSubview:label];
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 59.5, VIEW_W(self), 0.5)];
        lineView.backgroundColor=HexRGB(0x999999);
        [view addSubview:lineView];
        [view addSubview:self.pickView];
        [_pickView selectRow:0 inComponent:0 animated:YES];
        [_pickView selectRow:0 inComponent:1 animated:YES];
        
        NSString *year=[_yearOneArr objectAtIndex:0];
        TimeModel *timeModel = self.timeArr[0];
        NSString *month = timeModel.time[0];
        
        self.dateStr = [NSString stringWithFormat:@"%@ %@",year,month];
        
        NSString *yearTime=_yearOneTimeArray[0];
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        NSString *currentTime = [formatter stringFromDate:[NSDate date]];
        int intTime = [currentTime intValue];
        NSString *monthTime=_yearTwoTimeArray[intTime];
        self.dateTime=[NSString stringWithFormat:@"%@ %@",yearTime,monthTime];
        
        
        
        selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame=CGRectMake(Origin_x, VIEW_H(view)-45, VIEW_W(view), 45);
        [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectBtn setBackgroundColor:[UIColor colorWithHexString:@"#a6873b"] ];
        [selectBtn addTarget:self action:@selector(selectClick1:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:selectBtn];
        
        cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(Origin_x+10, VIEW_H(self)-45-10, VIEW_W(self)-20, 45);
        [cancelBtn setBackgroundColor:[UIColor lightGrayColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.layer.cornerRadius=5.0f;
        cancelBtn.layer.masksToBounds=YES;
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#a6873b"]  forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
    }
    return self;
}
//报事结束时间
-(id)initWithEndTimeFrame:(CGRect)frame andDatePickControllerBlock:(DatePickerControllerBlock)block  Message:(NSString *)mes
{
    if(self = [super initWithFrame:frame])
    {
        [self configData];
        self.backgroundColor = [UIColor whiteColor] ;
        view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, VIEW_W(self)-20, frame.size.height-10-45-10)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        
        selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame=CGRectMake(Origin_x, VIEW_H(view)-45, VIEW_W(view), 45);
        [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectBtn setBackgroundColor:HexRGB(0x00b4a2)];
        [selectBtn addTarget:self action:@selector(selectClick1:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:selectBtn];
        
        cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(Origin_x+10, VIEW_H(self)-45-10, VIEW_W(self)-20, 45);
        [cancelBtn setBackgroundColor:[UIColor lightGrayColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.layer.cornerRadius=5.0f;
        cancelBtn.layer.masksToBounds=YES;
        [cancelBtn setTitleColor:HexRGB(0x00b4a2) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        NSMutableArray *timeArr = [[NSMutableArray alloc]init];
        for (NSString *key in _yearOneArr) {
            NSMutableDictionary *day = [[NSMutableDictionary alloc ]init];
            if ([key isEqualToString:@"今天"]) {
                
                NSMutableArray *yearTwoArr;
                NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"HH"];
                NSString *currentTime = [formatter stringFromDate:[NSDate date]];
                int intTime = [currentTime intValue];
                NSRange range;
                if ((intTime+2) > _yearTwoArr.count) {
                    yearTwoArr = [NSMutableArray arrayWithCapacity:0];
                }else{
                    
                    range = NSMakeRange(0, intTime+2);
                    yearTwoArr = [NSMutableArray arrayWithCapacity:0];
                    [yearTwoArr addObjectsFromArray:_yearTwoArr];
                    [yearTwoArr removeObjectsInRange:range];
                }
                
                
                [day setObject:key forKey:@"day"];
                [day setObject:yearTwoArr forKey:@"time"];
                [timeArr addObject:day];
            }else{
                [day setObject:key forKey:@"day"];
                [day setObject:_yearTwoArr forKey:@"time"];
                [timeArr addObject:day];
            }
            
        }
        FileUtil *filePath = [[FileUtil alloc]init];
        
        NSString *path = [filePath getDocumentFilePath:@"time.plist"];
        self.filePath = path;
        
        [timeArr writeToFile:path atomically:YES];
        
        _datePickBlock=[block copy];
        UILabel *label =[UILabel labelWithFrame:CGRectMake((VIEW_W(self)-100)/2, 20, 100, 20) withText:mes withFont:[UIFont systemFontOfSize:16.0f] withTextColor:HexRGB(0x666666) withBackgroundColor:CLEARCOLOR];
        [view addSubview:label];
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 59.5, VIEW_W(self), 0.5)];
        lineView.backgroundColor=HexRGB(0x999999);
        [view addSubview:lineView];
        [view addSubview:self.pickView];
        [_pickView selectRow:0 inComponent:0 animated:YES];
        [_pickView selectRow:0 inComponent:1 animated:YES];
        
        NSString *year=[_yearOneArr objectAtIndex:0];
        TimeModel *timeModel = self.timeArr[0];
        NSString *month ;
        if (timeModel.time.count == 0) {
            month = @"";
            selectBtn.enabled = NO;
        }else{
            month = timeModel.time[0];
            selectBtn.enabled = YES;
        }
        int count = 0;
        if (month.length>0) {
            for (NSString *monthDay in _yearTwoArr) {
                if ([month isEqualToString:monthDay]) {
                    break;
                }else{
                    count ++;
                }
            }
        }
        self.dateStr = [NSString stringWithFormat:@"%@ %@",year,month];
        
        NSString *yearTime=_yearOneTimeArray[0];
        NSString *monthTime=_yearTwoTimeArray[count];
        self.dateTime=[NSString stringWithFormat:@"%@ %@",yearTime,monthTime];
        
        
        
    }
    return self;
}

//几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if(pickerView==_pickView)
        return 2;
    return 1;
}

//几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView==_pickView)
    {
        if(component == 0){
            return self.timeArr.count;
        }else{
            
            TimeModel *time = self.timeArr[_selectDayIndex];
            return time.time.count;
        }
        
    }
    else
    {
        return _addressArray.count;
    }
    return -1;
}

#pragma mark UIPickerViewDelegate
//component宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(pickerView==_pickView)
    {
        if(component == 0)
            return VIEW_W(self)*0.3;
        else if(component == 1)
            return VIEW_W(self)*0.7;
    }
    else
    {
        return VIEW_W(self);
    }
    return 0.0f;
}

//row高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView==_pickView)
    {
        if(component==0){
            
            TimeModel *time = self.timeArr[row];
            return  time.day;
            
        }else{
            
            TimeModel *time = self.timeArr[_selectDayIndex];
            
            return time.time[row];
            
        }
    }
    return [_addressArray[row] objectForKey:@"Space_name"];
}




//关联UILabel 和 UIPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    
    if(pickerView ==_pickView)
    {
        if (component == 0) {
            
            // 记录角标
            _selectDayIndex = [pickerView selectedRowInComponent:0];
            
            // 刷新列表
            [pickerView reloadComponent:1];
            
            // 默认选中第一个
            [pickerView selectRow:0 inComponent:1 animated:NO];
            
        }
        // 获取选中的省会
        TimeModel *time = self.timeArr[_selectDayIndex];
        //取得选择的Row
        NSInteger rowZero,rowOne;
        rowZero  = [pickerView selectedRowInComponent:0];
        rowOne   = [pickerView selectedRowInComponent:1];
        
        NSInteger cIndex = [pickerView selectedRowInComponent:1];
        NSString *TimeName;
        if (time.time.count == 0) {
            TimeName = @"";
            selectBtn.enabled = NO;
        }else{
            TimeName = time.time[cIndex];
            selectBtn.enabled = YES;
        }
        NSString *dayName = time.day;
        int count = 0;
        if ([dayName isEqualToString:@"今天"]) {
            if ([TimeName isEqualToString:@"即刻"]) {
                NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"HH"];
                NSString *currentTime = [formatter stringFromDate:[NSDate date]];
                count = [currentTime intValue];
            }else{
                if (TimeName.length>0) {
                    for (NSString *month in _yearTwoArr) {
                        if ([month isEqualToString:TimeName]) {
                            break;
                        }else{
                            count ++;
                        }
                    }
                }
                
            }
            
        }else{
            
            if (TimeName.length>0) {
                
                for (NSString *month in _yearTwoArr) {
                    if ([month isEqualToString:TimeName]) {
                        break;
                    }else{
                        count ++;
                    }
                }
            }
            
        }
        
        NSString *yearTime =_yearOneTimeArray[rowZero%7];
        NSString *monthTime =_yearTwoTimeArray[count];
        self.dateStr=[NSString stringWithFormat:@"%@ %@",time.day,TimeName];
        self.dateTime =[NSString stringWithFormat:@"%@ %@",yearTime,monthTime];
    }
    else
    {
        NSInteger rowZero=[pickerView selectedRowInComponent:0];
        NSString *address=[_addressArray[rowZero] objectForKey:@"Space_name"];
        self.address=address;
        self.spaceID =[_addressArray[rowZero] objectForKey:@"Space_id"];
    }
    
}



-(id)initWithFrame:(CGRect)frame andDatePickerBlock:(DatePickerActionSheetBlock)block
{
    if(self=[super initWithFrame:frame])
    {
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inquire-bg"]];
        imageView.frame=CGRectMake(0, 0, VIEW_W(self), frame.size.height);
        [self addSubview:imageView];
        self.dateBlock=[block copy];
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_W(self), frame.size.height)];
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        
        [view addSubview:self.datePicker];
        CGFloat leftCap=10;
        cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(leftCap, VIEW_BY(self.datePicker)+10, (VIEW_W(self)-2*leftCap-5)/2, 40);
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"hp-smart bar block.png"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:cancelBtn];
        
        selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame=CGRectMake(leftCap+(VIEW_W(self)-2*leftCap-5)/2+5, VIEW_BY(self.datePicker)+10, (VIEW_W(self)-2*leftCap-5)/2, 40);
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"hp-smart bar block.png"] forState:UIControlStateNormal];
        [selectBtn setTitle:@"选择" forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:selectBtn];
    }
    return self;
    
}
//时间选择回调
-(void)selectClick:(UIButton*)btn
{
    [self __hide];
    if(self.dateBlock)
        self.dateBlock(self.datePicker);
}

//时间选择回调
-(void)selectClick1:(UIButton*)btn
{
    [self __hide];
    DatePickerControllerBlock block=self.datePickBlock;
    if(block)
        block(self.dateStr,self.dateTime);
}
//报事地址回调
-(void)selectClick2:(UIButton*)btn
{
    [self __hide];
    AddressPickerControllerBlock  block =self.addressBlock;
    if(block)
        block(self.address,self.spaceID);
}
//小区选择回调
-(void)selectClick3:(UIButton*)btn
{
    [self __hide];
    CellPickerControllerBlock block=self.CellBlock;
    if(block)
        block(self.address,self.spaceID,self.spaceType);
}

-(UIDatePicker*)datePicker
{
    if(!_datePicker)
    {
        _datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 5, VIEW_W(self),VIEW_H(self)-60)];
        _datePicker.datePickerMode=UIDatePickerModeDateAndTime;
        
        _datePicker.minuteInterval=60;
        
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *time=@"1970-01-01 00:00:00";
        NSDate *miniDate =[dateFormatter dateFromString:time];
        _datePicker.minimumDate=miniDate;
        
        
        NSString *maxTime=@"2016-01-01 00:00:00";
        NSDate *maxDate=[dateFormatter dateFromString:maxTime];
        _datePicker.maximumDate=maxDate;
        
    }
    
    return _datePicker;
    
    
}

-(id)initWithFrame:(CGRect)frame withTitle:(NSString*)title{
    
    
    if(self =[super initWithFrame:frame])
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frame.size.height)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        
        
        titleLabel=[UILabel labelWithFrame:CGRectZero title:title fontSize:18.0f background:CLEARCOLOR lineBreakMode:NSLineBreakByCharWrapping];
        CGSize size=[title calculateSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, CGFLOAT_MAX) font:[UIFont systemFontOfSize:18.0f]];
        
        titleLabel.textColor=HexRGB(0x009867);
        titleLabel.frame=CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, size.height);
        [view addSubview:titleLabel];
        
    }
    return self;
}


-(UIControl*)viewControl
{
    if(!viewControl)
    {
        viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [viewControl setBackgroundColor:RGBACOLOR(0, 0, 0, 0.1)];
        [viewControl addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventTouchUpInside];
        [viewControl addSubview:self];
    }
    
    return viewControl;
    
}



-(void)hideAfterDelay:(NSInteger)delays
{
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:delays];
}

-(void)dismiss
{
    [self __hide];
    
}

-(id)initWithFrame:(CGRect)frame withSheetTitle:(NSString *)title andTitleArray:(NSArray *)titlesArray andImageArray:(NSArray *)imageArray andBlock:(CustomActionSheetViewBlock)block
{
    
    if(self =[super initWithFrame:frame])
    {
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inquire-bg"]];
        imageView.frame=CGRectMake(0, 0, VIEW_W(self), frame.size.height);
        [self addSubview:imageView];
        self.block=[block copy];
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_W(self), frame.size.height)];
        view.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        
        for(int i=0;i<3;i++)
        {
            AppIconView *iconView=[[AppIconView alloc] initWithFrame:CGRectMake(10+100*i, 20, 90, 90) name:[titlesArray objectAtIndex:i] fileIcon:[UIImage imageNamed:[imageArray objectAtIndex:i]] textColor:HexRGB(0x009867)];
            
            iconView.delegate=self;
            iconView.appId=i;
            [iconView singleTapGesture];
            iconView.userInteractionEnabled=YES;
            [view addSubview:iconView];
            
        }
        
        cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width-120)/2, 135, 120, 40);
        
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"hp-smart bar block.png"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:cancelBtn];
        
    }
    
    return self;
}

- (void)show
{
    self.viewControl.alpha = 0.6f;
    [self setInfoViewFrame:NO];
}

//
- (void)__hide
{
    [self setInfoViewFrame:YES];
    
}

- (void) controlPressed
{
    [self __hide];
}

- (void)setInfoViewFrame:(BOOL)isDown{
    
    UIView *window=[UIApplication sharedApplication].keyWindow;
    
    __weak GYCustomActionSheetView *weakSelf=self;
    if(isDown == NO)
    {
        [window addSubview:self.viewControl];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             self.viewControl.alpha=1.0f;
                             [self setFrame:CGRectMake(0, SCREENHEIGHT-VIEW_H(weakSelf), VIEW_W(weakSelf),VIEW_H(weakSelf))];
                             
                         }
                         completion:^(BOOL finished) {}];
        
        
    }
    else
    {
        
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             self.viewControl.alpha=0.6;
                             [self setFrame:CGRectMake(0, SCREENHEIGHT, VIEW_W(weakSelf), VIEW_H(weakSelf))];
                         }
                         completion:^(BOOL finished) {
                             
                             [viewControl removeFromSuperview];
                         }];
    }
    
}

//cancel
-(void)btnClick:(UIButton*)btn
{
    [self __hide];
    
}

-(void)appClicked:(AppIconView *)app
{
    
    [self __hide];
    if(self.block)
        self.block(app.appId);
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        //        pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        //        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        //        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
@end
