//
//  DeliveryView.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/10.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "DeliveryView.h"

#import "HBCustomActionSheetView.h"

@implementation DeliveryView

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
    //我要发快递
    GMQBasicView* postview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(self), 44*SCREENHEIGHT/667)];
    UILabel * postlab = [[UILabel alloc]initWithFrame:CGRectMake(12*SCREENWIDTH/375, 0, VIEW_W(view), VIEW_H(postview))];
    postlab.text = @"我要发快递" ;
    postlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    postlab.textColor = [UIColor grayColor] ;
    [postview addSubview:postlab];
    UIView * colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5*SCREENWIDTH/375, VIEW_H(postview))];
    colorView.backgroundColor = [UIColor orangeColor] ;
    [postview addSubview:colorView];
    UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    lineview.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [postview addSubview:lineview];
    [view addSubview:postview];
    
    
    //称呼
    GMQBasicView * nameview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(postview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * namelab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, 100*SCREENWIDTH/375, VIEW_H(postview))] ;
    namelab.text = @"您的称呼" ;
    namelab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    namelab.textColor = [UIColor grayColor] ;
    [nameview addSubview:namelab];
    UIView * linename = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linename.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [nameview addSubview:linename];
    
    _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_BX(namelab)+10, 0, VIEW_W(nameview)-VIEW_BX(namelab)-10, VIEW_H(nameview))];
    _nameTF.placeholder = @"请输入姓名" ;
    [_nameTF setValue:[UIFont boldSystemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] forKeyPath:@"_placeholderLabel.font"];
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing ;
    [nameview addSubview:_nameTF];
    [view addSubview:nameview];
    
    
    //联系电话
    GMQBasicView * telview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(nameview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * tellab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab),0, 100*SCREENWIDTH/375, VIEW_H(postview))] ;
    tellab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    tellab.text = @"联系电话" ;
    tellab.textColor = [UIColor grayColor] ;
    [telview addSubview:tellab];
    UIView * linetel = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linetel.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [telview addSubview:linetel];
    
    _telTF = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_BX(tellab)+10, VIEW_TY(tellab), VIEW_W(telview)-VIEW_BX(tellab)-10, VIEW_H(namelab))];
    _telTF.placeholder = @"请输入联系电话/手机" ;
    [_telTF setValue:[UIFont boldSystemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] forKeyPath:@"_placeholderLabel.font"];
    _telTF.clearButtonMode = UITextFieldViewModeWhileEditing ;
    _telTF.keyboardType = UIKeyboardTypeNumberPad ;
    [telview addSubview:_telTF];
    [view addSubview:telview];
    
    //所在区域
    GMQBasicView * addressview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(telview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * addlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, 100*SCREENWIDTH/375, VIEW_H(postview))] ;
    addlab.text = @"所在区域" ;
    addlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    addlab.textColor = [UIColor grayColor] ;
    [addressview addSubview:addlab];
    UIView * lineadd = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    lineadd.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [addressview addSubview:lineadd];
    _addressLab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_BX(tellab)+5, VIEW_TY(tellab), VIEW_W(telview)-VIEW_BX(tellab)-10, VIEW_H(namelab))];
    //    _addressLab.text = @"北京市朝阳区建国门外大街1号" ;
    _addressLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    [addressview addSubview:_addressLab];
    [view addSubview:addressview];
    
    //所属楼宇
    GMQBasicView * buildview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(addressview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * buildlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, 80*SCREENWIDTH/375, VIEW_H(postview))] ;
    buildlab.text = @"所属楼宇" ;
    buildlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    buildlab.textColor = [UIColor grayColor] ;
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
    _buiBtn.enabled = NO ;
    //    _buiBtn.backgroundColor = [UIColor blackColor] ;
    [buildview addSubview:_buiBtn] ;
    [buildview addSubview:_buildBtn] ;
    [view addSubview:buildview];
    
    //所属楼层
    GMQBasicView * floorView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(buildview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * floorlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, 80*SCREENWIDTH/375, VIEW_H(postview))] ;
    floorlab.text = @"具体楼层" ;
    floorlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    floorlab.textColor = [UIColor grayColor] ;
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
    _flrBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_W(self)-40, VIEW_TY(_floorBtn), 40*SCREENWIDTH/375, VIEW_H(postview)) andTag:@"1001" andBackgroundImage:@"common_btn_ddm"] ;
    
    _flrBtn.enabled = NO ;
    //    _flrBtn.backgroundColor = [UIColor blackColor] ;
    [floorView addSubview:_floorBtn] ;
    [floorView addSubview:_flrBtn] ;
    
    //详细地址
    GMQBasicView * roomView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(floorView), VIEW_W(postview), VIEW_H(postview)*2)];
//    UILabel * roomlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 20*SCREENHEIGHT/667, 80*SCREENWIDTH/375,[SizeUtility textFontSize:default_Sub_Express_title_size])] ;
     UILabel * roomlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, 80*SCREENWIDTH/375,VIEW_H(roomView))] ;
    roomlab.text = @"详细地址" ;
    roomlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    roomlab.textColor = [UIColor grayColor] ;
    [roomView addSubview:roomlab];
    UIView * lineroom = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(roomView)-1, VIEW_W(view), 1)];
    lineroom.backgroundColor = [UIColor groupTableViewBackgroundColor] ;

    _detailTF  =[[PlaceholderTextView alloc] initWithFrame:CGRectMake(VIEW_BX(roomlab)+10, 20*SCREENHEIGHT/667, VIEW_W(self)-10-VIEW_BX(roomlab)-10, VIEW_H(roomView)-20*SCREENHEIGHT/667-10)];
    _detailTF.placeholder=@"上门取件的详细地址";
    _detailTF.font=[UIFont boldSystemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]];
    _detailTF.placeholderFont=[UIFont boldSystemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-1];

    [roomView addSubview:_detailTF];
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_W(_detailTF)-20,VIEW_H(_detailTF)-15 , 20, 15)];
    img.image = [UIImage imageNamed:@""] ;
    //    img.backgroundColor =[UIColor blackColor] ;
    [_detailTF addSubview:img] ;
    [view addSubview:roomView] ;
    
    
    //快递类别
    GMQBasicView * typeView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(roomView), VIEW_W(postview), VIEW_H(postview))];
    UILabel * typelab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab),0, 80*SCREENWIDTH/375, VIEW_H(typeView))] ;
    typelab.text = @"快递类别" ;
    typelab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    typelab.textColor = [UIColor grayColor] ;
    [typeView addSubview:typelab];
    UIView * linetype = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linetype.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [typeView addSubview:linetype];
    [view addSubview:typeView] ;
    _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(typelab)+10, VIEW_TY(typelab), VIEW_W(typeView)-VIEW_BX(typelab)-10, VIEW_H(typelab)) andTag:@"102" andTitle:@"请选择"] ;
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-1] ;
    _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _typeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _tyBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_W(self)-40, VIEW_TY(_typeBtn), 40*SCREENWIDTH/375, VIEW_H(postview)) andTag:@"1002" andBackgroundImage:@"common_btn_ddm"] ;
    //    _tyBtn.backgroundColor = [UIColor blackColor] ;
    _tyBtn.enabled = NO ;
    [typeView addSubview:_typeBtn] ;
    [typeView addSubview:_tyBtn] ;
    [view addSubview:typeView] ;
    
    //快递方式
    GMQBasicView * transView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(typeView), VIEW_W(postview), VIEW_H(postview))];
    UILabel * tranlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab),0, 80*SCREENWIDTH/375, VIEW_H(postview))] ;
    tranlab.text = @"快递方式" ;
    tranlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    tranlab.textColor = [UIColor grayColor] ;
    [transView addSubview:tranlab];
    UIView * linetran = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linetran.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [transView addSubview:linetran];
    [view addSubview:transView] ;
    _transportBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(tranlab)+10, VIEW_TY(tranlab), VIEW_W(transView)-VIEW_BX(tranlab)-10, VIEW_H(tranlab)) andTag:@"104" andTitle:@"请选择"] ;
    _transportBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-1] ;
    _transportBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _transportBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_transportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _tranBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_W(self)-40, VIEW_TY(_transportBtn),40*SCREENWIDTH/375, VIEW_H(postview)) andTag:@"1004" andBackgroundImage:@"common_btn_ddm"] ;
    _tranBtn.enabled = NO ;
    //    _tranBtn.backgroundColor = [UIColor blackColor] ;
    [transView addSubview:_transportBtn] ;
    [transView addSubview:_tranBtn] ;
    [view addSubview:transView] ;
    
    
    //目的地
    GMQBasicView * destionView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(transView), VIEW_W(postview), VIEW_H(postview))];
    UILabel * destlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, 80*SCREENWIDTH/375, VIEW_H(postview))] ;
    destlab.text = @"目的地" ;
    destlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    destlab.textColor = [UIColor grayColor] ;
    [destionView addSubview:destlab];
    UIView * linedest = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linedest.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [destionView addSubview:linedest];
    [view addSubview:destionView] ;
    _destatBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(destlab)+10, VIEW_TY(destlab), VIEW_W(destionView)-VIEW_BX(destlab)-10, VIEW_H(destlab)) andTag:@"103" andTitle:@"请选择"] ;
    _destatBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-1] ;
    _destatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _destatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_destatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _destBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_W(self)-40, VIEW_TY(_destatBtn),40*SCREENWIDTH/375, VIEW_H(postview)) andTag:@"1003" andBackgroundImage:@"common_btn_ddm"] ;
    
    //    _destBtn.backgroundColor = [UIColor blackColor] ;
    _destBtn.enabled = NO ;
    [destionView addSubview:_destatBtn] ;
    [destionView addSubview:_destBtn] ;
    [view addSubview:destionView] ;
    
    
    //详细地址
    GMQBasicView * sayview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(destionView), VIEW_W(postview), VIEW_H(postview)*2)];
     UILabel *sayviewlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, 80*SCREENWIDTH/375, VIEW_H(sayview))] ;
    sayviewlab.text = @"备注信息" ;
    sayviewlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    sayviewlab.textColor = [UIColor grayColor] ;
    [sayview addSubview:sayviewlab];
    UIView * linesay = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(sayview)-1, SCREENWIDTH, 1)];
    linesay.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [sayview addSubview:linesay];
    
//   _sayTF  =[[PlaceholderTextView alloc] initWithFrame:CGRectMake(VIEW_BX(sayviewlab)+8, 20*SCREENHEIGHT/667, VIEW_W(self)-10-VIEW_BX(sayviewlab)-10, VIEW_H(sayview)-20*SCREENHEIGHT/667-10)];
//    _sayTF.placeholder=@"您有什么需要给快递员说的(选填)";
//    _sayTF.font=[UIFont boldSystemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]];
//    _sayTF.placeholderFont=[UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]-2];
    
    _sayTF = [[UITextView alloc]initWithFrame:CGRectMake(VIEW_BX(sayviewlab)+10, 20*SCREENHEIGHT/667+10, VIEW_W(self)-10-VIEW_BX(sayviewlab)-10, [SizeUtility textFontSize:default_Sub_Express_title_size]*2)] ;
    _saylab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(_sayTF), [SizeUtility textFontSize:default_Sub_Express_title_size])];
    _saylab.text = @"您有什么需要给快递员说的(选填)" ;
    _saylab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    _saylab.numberOfLines = 0 ;
    _saylab.alpha = 1 ;
    [_saylab sizeToFit] ;
    _saylab.textColor = [UIColor lightGrayColor] ;
    _sayTF.font =[UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
//    [_sayTF setFrame:CGRectMake(VIEW_BX(sayviewlab)+10,20*SCREENHEIGHT/667, VIEW_W(self)-10-VIEW_BX(sayviewlab)-10,_saylab.size.height)];
    [_sayTF addSubview:_saylab];
    [sayview addSubview:_sayTF];
    [view addSubview:sayview] ;
    
    GMQBasicView * colview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(sayview)+1, VIEW_W(view), 12*SCREENHEIGHT/667)];
    colview.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [view addSubview:colview];
    
    //下单须知
    GMQBasicView* downview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(colview), VIEW_W(self), VIEW_H(postview))];
    UILabel * downlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, VIEW_W(view), VIEW_H(postview))];
    downlab.text = @"下单须知" ;
    downlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    downlab.textColor = [UIColor grayColor] ;
    [downview addSubview:downlab];
    UIView * downcolor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5*SCREENWIDTH/375, VIEW_H(postview))];
    downcolor.backgroundColor = [UIColor orangeColor] ;
    [downview addSubview:downcolor];
    UIView * linedown = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linedown.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [downview addSubview:linedown];
    UIView * downco= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, VIEW_H(postview))];
    downcolor.backgroundColor = [UIColor orangeColor] ;
    [downview addSubview:downco];
    [view addSubview:downview];
    
    //下单须知描述
    GMQBasicView* detailView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(downview)+15, VIEW_W(self), VIEW_H(postview)*2)];
    _downcolab = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, VIEW_W(view)-16, VIEW_H(detailView))];
    _downcolab.text = @"目前我们仅提供国内快递服务，指定合作方为中通速递，其他合作范围正在积极洽谈，国际业务请致电4001752288，我们会有更专业的团队为您服务。" ;
    _downcolab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    _downcolab.textColor = [UIColor grayColor] ;
    _downcolab.numberOfLines = 0 ;
    [detailView addSubview:_downcolab];
    UIView * linedownco = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(detailView)-1, VIEW_W(view), 1)];
    linedownco.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [detailView addSubview:linedownco];
    [view addSubview:detailView];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(8, VIEW_BY(detailView)+30, VIEW_W(view)-16, 40) andTitle:@"立即下单" andBackgroundImage:@""] ;
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    [_submitBtn setBackgroundColor:[UIColor redColor] ];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //   [view addSubview:_submitBtn];
    [roomView addSubview:lineroom];
    [view setFrame:CGRectMake(0, 0, VIEW_W(self), VIEW_BY(detailView))];
}




@end
