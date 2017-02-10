//
//  MyInfoView.m
//  TradeCenterCircle
//
//  Created by 李阳 on 16/8/15.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#import "MyInfoView.h"
//CGFloat myinfoFont ;
@implementation MyInfoView

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
        self.backgroundColor = [UIColor whiteColor] ;
        [self createUIWithHeight:frame.size.height] ;
  }
    return self ;
}

-(void)createUIWithHeight:(CGFloat)height
{
    GMQBasicView * view = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(self), height)];
    view.backgroundColor = [UIColor whiteColor] ;
    [self addSubview:view];
    //我要发快递
    GMQBasicView* postview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(self), 44*SCREENHEIGHT/667)];
    UILabel * postlab = [[UILabel alloc]initWithFrame:CGRectMake(12*SCREENWIDTH/375, 0, VIEW_W(view), VIEW_H(postview))];
    postlab.text = @"我的资料" ;
    postlab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    postlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    [postview addSubview:postlab];
    UIView * colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, VIEW_H(postview))];
    colorView.backgroundColor = [UIColor orangeColor] ;
    [postview addSubview:colorView];
    UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    lineview.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [postview addSubview:lineview];
    [view addSubview:postview];
    
    
   //联系电话
        GMQBasicView * telview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(postview), VIEW_W(postview), VIEW_H(postview))];
        UILabel * tellab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, 80*SCREENWIDTH/375, VIEW_H(postview))] ;
        tellab.text = @"手机号码" ;
        tellab.textColor = [UIColor colorWithHexString:@"#666666"] ;
      tellab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
        [telview addSubview:tellab];
        UIView * linetel = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
        linetel.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
        [telview addSubview:linetel];
    
        _telTF = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_BX(tellab)+10, VIEW_TY(tellab), VIEW_W(telview)-VIEW_BX(tellab)-10, VIEW_H(tellab))];
        _telTF.placeholder = @"请输入联系电话/手机" ;
        _telTF.clearButtonMode = UITextFieldViewModeWhileEditing ;
        [telview addSubview:_telTF];
    _telTF.keyboardType = UIKeyboardTypeNumberPad;
      _telTF.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
        [view addSubview:telview];
    
    
    //称呼

    GMQBasicView * nameview = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(telview), VIEW_W(postview), VIEW_H(postview))];
    UILabel * namelab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, VIEW_W(tellab),VIEW_H(postview))] ;
    namelab.text = @"真实姓名" ;
      namelab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    namelab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [nameview addSubview:namelab];
    UIView * linename = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linename.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [nameview addSubview:linename];
    
    _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_BX(namelab)+10, VIEW_TY(namelab), VIEW_W(nameview)-VIEW_BX(namelab)-10, VIEW_H(namelab))];
    _nameTF.placeholder = @"请输入您的真实姓名" ;
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing ;
    [nameview addSubview:_nameTF];
      _nameTF.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    nameview.backgroundColor = [UIColor whiteColor] ;
    [view addSubview:nameview];
    
    //昵称
    GMQBasicView * nichengView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(nameview), VIEW_W(postview), VIEW_H(postview))];
     nichengView.backgroundColor = [UIColor whiteColor] ;
    UILabel * niclab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, VIEW_W(tellab), VIEW_H(postview))] ;
    niclab.text = @"昵称" ;
      niclab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    niclab.textAlignment = NSTextAlignmentLeft ;
    niclab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [nichengView addSubview:niclab];
    UIView * lineadd = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    lineadd.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [nichengView addSubview:lineadd];
    _nichengLab = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_BX(tellab)+10, VIEW_TY(tellab), VIEW_W(telview)-VIEW_BX(tellab)-10, VIEW_H(niclab))];

      _nichengLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    _nichengLab.clearButtonMode =UITextFieldViewModeWhileEditing ;
    [nichengView addSubview:_nichengLab];
    [view addSubview:nichengView];

    //性别
    GMQBasicView * sexView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(nichengView), VIEW_W(postview), VIEW_H(postview))];
     sexView.backgroundColor = [UIColor whiteColor] ;
    UILabel * sexlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, VIEW_W(tellab), VIEW_H(postview))] ;
    sexlab.text = @"性别" ;
      sexlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    sexlab.textAlignment = NSTextAlignmentLeft ;
    sexlab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [sexView addSubview:sexlab];
    UIView * linesex = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(postview)-1, VIEW_W(view), 1)];
    linesex.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [sexView addSubview:linesex];
    [view addSubview:sexView] ;
    _sexChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_BX(sexlab)+10, VIEW_TY(sexlab), VIEW_W(sexView)-VIEW_BX(sexlab)-10, VIEW_H(namelab)) andTag:@"101" andTitle:@"男"] ;
    _sexChooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _sexChooseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [_sexChooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _sexBtn = [UIButton buttonWithType:UIButtonTypeCustom andFrame:CGRectMake(VIEW_W(self)-40, 0, 40*SCREENWIDTH/375, VIEW_H(sexView)) andTag:@"1001" andBackgroundImage:@"common_btn_ddm"] ;
    _sexBtn.enabled = NO ;
    _sexChooseBtn.titleLabel.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    [sexView addSubview:_sexChooseBtn] ;
    [sexView addSubview:_sexBtn] ;

   [view addSubview:sexView] ;
    //个人介绍
    GMQBasicView * personalView = [[GMQBasicView alloc]initWithFrame:CGRectMake(0, VIEW_BY(sexView), VIEW_W(postview), VIEW_H(postview)*2)];
     personalView.backgroundColor = [UIColor whiteColor] ;
    UILabel * perlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_TX(postlab), 0, VIEW_W(tellab), VIEW_H(postview))] ;
    perlab.text = @"个人介绍" ;
      perlab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    perlab.textColor = [UIColor colorWithHexString:@"#666666"] ;
    [personalView addSubview:perlab];
   
    _perintroduceTV = [[UITextView alloc]initWithFrame:CGRectMake(VIEW_BX(perlab)+20, 5*SCREENHEIGHT/667, VIEW_W(view)-10-VIEW_BX(perlab)-10,VIEW_H(perlab)*2)] ;
    _perintroLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(_perintroduceTV), VIEW_H(perlab))];
      _perintroduceTV.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    _perintroLab.text = @"简单介绍一下自己吧" ;
    _perintroLab.font = [UIFont systemFontOfSize:[SizeUtility textFontSize:default_Sub_Express_title_size]] ;
    _perintroLab.textColor = [UIColor lightGrayColor] ;
    [_perintroduceTV addSubview:_perintroLab];
    [personalView addSubview:_perintroduceTV];
    UIView * lineper = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_H(personalView)-1, VIEW_W(view), 1)];
    lineper.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
    [personalView addSubview:lineper];
    [view addSubview:personalView] ;

    [view setFrame:CGRectMake(0, 0, VIEW_W(self), VIEW_BY(personalView)+1)];
   
}



@end
