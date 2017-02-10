//
//  MyAddressADDView.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/19.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyAddressADDView.h"


@implementation MyAddressADDView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self createUI] ;
    }
    return self ;
}

-(void)createUI
{
    GMQBasicView * view = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(self), VIEW_H(self))];
    [self addSubview:view];
    //添加地址
    GMQBasicView* postview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(self), 44*SCREENHEIGHT/667)];
    _postlab = [[UILabel alloc]initWithFrame:CGRectMake(12*SCREENWIDTH/375, 0, VIEW_W(view), VIEW_H(postview))];
    _postlab.text = @"" ;
    _postlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    _postlab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [postview addSubview:_postlab];
    UIView * colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, VIEW_H(postview))];
    colorView.backgroundColor = [UIColor orangeColor] ;
    [postview addSubview:colorView];
    UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    lineview.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [postview addSubview:lineview];
    [view addSubview:postview];
    
    
    //姓名
    GMQBasicView * nameview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(postview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * namelab = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100*SCREENWIDTH/375, VIEW_H(postview))] ;
    namelab.text = @"姓名" ;
        namelab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    namelab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [nameview addSubview:namelab];
    UIView * linename = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linename.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [nameview addSubview:linename];
    
    _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_BX(namelab)+10, VIEW_TY(namelab), VIEW_W(nameview)-VIEW_BX(namelab)-10, VIEW_H(namelab))];
    _nameTF.placeholder = @"收货人姓名" ;
    [_nameTF setValue:[UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] forKeyPath:@"_placeholderLabel.font"];
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing ;
    [nameview addSubview:_nameTF];
    [view addSubview:nameview];
    
    //联系电话
    GMQBasicView * telview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(nameview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * tellab = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100*SCREENWIDTH/375, VIEW_H(postview))] ;
    tellab.text = @"联系电话" ;
        tellab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    tellab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [telview addSubview:tellab];
    UIView * linetel = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linetel.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [telview addSubview:linetel];
    
    _telTF = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_BX(tellab)+10, VIEW_TY(tellab), VIEW_W(telview)-VIEW_BX(tellab)-10, VIEW_H(namelab))];
    _telTF.placeholder = @"请输入联系电话/手机" ;
        [_telTF setValue:[UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] forKeyPath:@"_placeholderLabel.font"];
    _telTF.clearButtonMode = UITextFieldViewModeWhileEditing ;
    _telTF.keyboardType = UIKeyboardTypeNumberPad ;
    [telview addSubview:_telTF];
    [view addSubview:telview];
    
    //所在区域
    GMQBasicView * addressview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(telview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * addlab = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100*SCREENWIDTH/375,VIEW_H(postview))] ;
    addlab.text = @"所在区域" ;
        addlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    addlab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [addressview addSubview:addlab];
    UIView * lineadd = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    lineadd.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [addressview addSubview:lineadd];
    _addressLab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_BX(tellab)+10, VIEW_TY(tellab), VIEW_W(telview)-VIEW_BX(tellab)-10, VIEW_H(namelab))];
    _addressLab.text = @"北京市朝阳区建国门外大街1号" ;
    _addressLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    [addressview addSubview:_addressLab];
    [view addSubview:addressview];
    
    //所属楼宇
    GMQBasicView * buildview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(addressview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * buildlab = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 80*SCREENWIDTH/375, VIEW_H(postview))] ;
    buildlab.text = @"所属楼宇" ;
        buildlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    buildlab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [buildview addSubview:buildlab];
    UIView * linebuild = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linebuild.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [buildview addSubview:linebuild];
    _buildBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(buildlab)+10, VIEW_TY(buildlab), VIEW_W(buildview)-VIEW_BX(buildlab)-10, VIEW_H(namelab)) andTag:@"100" andTitle:@"请选择"] ;
    _buildBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-1] ;
    _buildBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _buildBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_buildBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _buiBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_W(self)-40, VIEW_TY(_buildBtn), 40*SCREENWIDTH/375, VIEW_H(buildview)) andTag:@"1000" andBackgroundImage:@"common_btn_ddm"] ;
    
    [buildview addSubview:_buiBtn] ;
    [buildview addSubview:_buildBtn] ;
    [view addSubview:buildview];
    
    //所属楼层
    GMQBasicView * floorView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(buildview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * floorlab = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 80*SCREENWIDTH/375, VIEW_H(postview))] ;
    floorlab.text = @"具体楼层" ;
        floorlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    floorlab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [floorView addSubview:floorlab];
    UIView * linefloor = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linefloor.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [floorView addSubview:linefloor];
    [view addSubview:floorView] ;
    _floorBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(floorlab)+10, VIEW_TY(buildlab), VIEW_W(buildview)-VIEW_BX(buildlab)-10, VIEW_H(namelab)) andTag:@"101" andTitle:@"请选择"] ;
    _floorBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-1] ;
    _floorBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _floorBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_floorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _flrBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_W(self)-40, VIEW_TY(_floorBtn), 40*SCREENWIDTH/375, VIEW_H(buildview)) andTag:@"1001" andBackgroundImage:@"common_btn_ddm"] ;
    
    [floorView addSubview:_floorBtn] ;
    [floorView addSubview:_flrBtn] ;
    
    //详细地址
    GMQBasicView * roomView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(floorView), VIEW_W(postview), VIEW_H(postview)*2)];
    UILabel * roomlab = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 80*SCREENWIDTH/375, VIEW_H(postview)*2)] ;
    roomlab.text = @"详细地址" ;
    roomlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    roomlab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [roomView addSubview:roomlab];
    UIView * lineroom = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(roomView)-1, VIEW_W(view), 1)];
    lineroom.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    //    [roomView addSubview:lineroom];
    _detailTF = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(VIEW_BX(roomlab)+10, 20*SCREENHEIGHT/667, VIEW_W(self)-10-VIEW_BX(roomlab)-10, VIEW_H(roomView)-2*VIEW_TY(roomlab))] ;
    _detailTF.font= [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    _detailTF.placeholderFont = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    _detailTF.placeholder = @"补充详细地址" ;
//    _placeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(_detailTF), [SizeUtility textFontSize:default_Sub_Express_title_size])];
//    _placeLab.text = @"补充详细地址" ;
//    _placeLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
//    _placeLab.textColor = [UIColor lightGrayColor] ;
//    [_detailTF addSubview:_placeLab];
    [roomView addSubview:_detailTF];
    //    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_W(_detailTF)-20,VIEW_H(_detailTF)-15 , 20, 15)];
    //    img.image = [UIImage imageNamed:@""] ;
    //    img.backgroundColor =[UIColor blackColor] ;
    //    [_detailTF addSubview:img] ;
    [roomView addSubview:lineroom];
    [view addSubview:roomView] ;
    
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(8, VIEW_BY(roomView)+30, VIEW_W(view)-16, 40*SCREENHEIGHT/667) andTitle:@"立即下单" andBackgroundImage:@""] ;
    [_submitBtn setBackgroundColor:[UIColor redColor] ];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //   [view addSubview:_submitBtn];
    view.backgroundColor = [UIColor whiteColor] ;
    [view setFrame:CGRectMake(0, 0, VIEW_W(self), VIEW_BY(roomView))];
}




@end
