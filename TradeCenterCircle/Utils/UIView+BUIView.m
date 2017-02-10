//
//  UIView+BUIView.m
//  ctoffice
//
//  Created by TangShiLei on 13-12-9.
//  Copyright (c) 2013年 xugang. All rights reserved.
//

#import "UIView+BUIView.h"
#import <objc/runtime.h>
@implementation UIView (BUIView)

static char key;
static char actionKey;


#pragma -mark UIAlertView


+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)meg cancelButtonTitle:(NSString*)cancelButtonTitle completeBlcok:(completeBlock)block
{
     UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:title message:meg delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil] autorelease];
    [alert showAlertViewWithCompleteBlock:block];

    
    
}

+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)meg cancelButtonTitle:(NSString*)cancelButtonTitle completeBlcok:(completeBlock)block otherTitles:(NSArray*)buttonTitles
{
    UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:title message:meg delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil] autorelease];
    if(buttonTitles.count>0)
    {
        
        for(int i=0;i<buttonTitles.count;i++)
        {
            NSString *title=[NSString stringWithFormat:@"%@",[buttonTitles objectAtIndex:i]];
            [alert addButtonWithTitle:title];
        }
        
    }
    
    
    [alert showAlertViewWithCompleteBlock:block];
    
}

+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)meg cancelButtonTitle:(NSString*)cancelButtonTitle completeBlcok:(completeBlock)block otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:title message:meg delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil] autorelease];
    va_list arglist;
    va_start(arglist, otherButtonTitles);
    id arg;
    while((arg = va_arg(arglist, id)))
    {
        if (arg)
        {
            NSString *argument=(NSString *)arg;
            if(argument.length>0)
              [alert addButtonWithTitle:argument];
        }
    }
    va_end(arglist);
    
    [alert showAlertViewWithCompleteBlock:block];
   
}


-(void)showAlertViewWithCompleteBlock:(completeBlock)block
{
    UIAlertView *alert=(UIAlertView*)self;
    if (block) {
        ////移除所有关联
        objc_removeAssociatedObjects(self);
        /**
         1 创建关联（源对象，关键字，关联的对象和一个关联策略。)
         2 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
         3 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。
         */
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        ////设置delegate
        alert.delegate=self;
        
    }
    
    [alert show];
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取关联的对象，通过关键字。
    completeBlock block=objc_getAssociatedObject(self, &key);
    
    if(block)
    {
        block(buttonIndex);
    }
    
}



/**
 OC中的关联就是在已有类的基础上添加对象参数。来扩展原有的类，需要引入#import <objc/runtime.h>头文件。关联是基于一个key来区分不同的关联。
 常用函数: objc_setAssociatedObject     设置关联
 objc_getAssociatedObject     获取关联
 objc_removeAssociatedObjects 移除关联
 */


#pragma -mark UIActionSheet
-(void)showActionSheetWithCompleteBlock:(actionFinish)block
{
    UIActionSheet *actionSheet=(UIActionSheet*)self;
    if(block)
    {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &actionKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        actionSheet.delegate=self;
    }
    
}


+(void)showInView:(UIView*)view withTitle:(NSString*)title  cancelButtonTitle:(NSString*)cancelButtonTitle deleteButtonTitle:(NSString*)deleteTitle otherButtonTitles:(NSArray*)titlesArray completeBlcok:(actionFinish)block
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:deleteTitle otherButtonTitles:nil];
    
    for(NSString *title in titlesArray)
    {
        [actionSheet addButtonWithTitle:title];
    }
    
    [actionSheet addButtonWithTitle:cancelButtonTitle];
    
    actionSheet.cancelButtonIndex=actionSheet.numberOfButtons-1;
    [actionSheet showActionSheetWithCompleteBlock:block];
    [actionSheet showInView:view];

}


+(void)showInView:(UIView*)view withTitle:(NSString*)title  cancelButtonTitle:(NSString*)cancelButtonTitle deleteButtonTitle:(NSString*)deleteTitle  completeBlcok:(actionFinish)block otherButtonTitles:(NSString*)otherButtonTitles,...NS_REQUIRES_NIL_TERMINATION
{
    
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:deleteTitle otherButtonTitles:otherButtonTitles, nil];
    
    va_list arglist;
    va_start(arglist, otherButtonTitles);
    id arg;
    while((arg = va_arg(arglist, id))) {
        if (arg)
        {
            [actionSheet addButtonWithTitle:(NSString*)arg];
        }
    }
    va_end(arglist);
    [actionSheet addButtonWithTitle:cancelButtonTitle];
    
     actionSheet.cancelButtonIndex=actionSheet.numberOfButtons-1;
    [actionSheet showActionSheetWithCompleteBlock:block];
    [actionSheet showInView:view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    actionFinish block=objc_getAssociatedObject(self, &actionKey);
    if(block)
    {
        block(buttonIndex,actionSheet);
    }
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    
    for (UIView *subViwe in actionSheet.subviews) {
        
          if ([subViwe isKindOfClass:[UIButton class]]) {
            
            NSLog(@"...%@",NSStringFromClass([subViwe class]));
            
            UIButton *button = (UIButton*)subViwe;
                        if(![button.titleLabel.text isEqualToString:@"取消"])
                        {
                            CGRect frame=button.frame;
                            frame.origin.x+=30;
                            frame.size.width-=60;
                            
            [button setTitleColor:HexRGB(0x009867) forState:UIControlStateNormal];
                            [button setFrame:frame];
                            
                            
                        }
            else
               [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
        }
    }
    
    
}




//创建 UIImageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=YES;
    return imageView;
}
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString*)text
{
    //[[UILabel appearance]setTextColor:[UIColor redColor]];
    
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //设置字体大小
    label.font=[UIFont systemFontOfSize:font];
    //设置对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    //设置行数
    label.numberOfLines=0;
    //设置折行方式
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //设置阴影的颜色
    //label.shadowColor=[UIColor yellowColor];
    //设置阴影的偏移
    label.shadowOffset=CGSizeMake(2, 2);
    
    //设置文字
    if (text) {
        label.text=text;
    }
    return label;
    
}

+(UIView*)viewWithFrame:(CGRect)frame
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    return view;
}

+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftView:(UIView*)left_View rightView:(UIView*)rgView  Font:(float)font;
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    //灰色提示框
    textField.placeholder=placeholder;
    //文字对齐方式
    textField.textAlignment=NSTextAlignmentLeft;
    textField.secureTextEntry=YESorNO;
    //边框
    textField.borderStyle=UITextBorderStyleNone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //键盘类型
    //textField.keyboardType=UIKeyboardTypeEmailAddress;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=YES;
    //左图片
    textField.leftView=left_View;
    
    textField.leftViewMode=UITextFieldViewModeAlways;
    //右图片
    textField.rightView=rgView;
    //编辑状态下一直存在
    //textField.rightViewMode=UITextFieldViewModeWhileEditing;
    //自定义键盘
    //textField.inputView
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    //字体颜色
    textField.textColor=[UIColor blackColor];
    return textField;
    
}


#pragma  mark 适配器方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName
{
    UITextField*text= [self createTextFieldWithFrame:frame placeholder:placeholder passWord:YESorNO leftImageView:imageView rightImageView:rightImageView Font:font backgRoundImageName:imageName];
    text.background=[UIImage imageNamed:imageName];
    return  text;
    
}





@end
