//
//  UIControl+BUIControl.m
//  BlockUI
//
//  Created by 张 玺 on 12-9-10.
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//

#import "BUIControl.h"
#import <objc/runtime.h>

static char overviewKey;
@implementation UIControl (BUIControl)

//使用工厂模式来进行创建
+(UIButton*)createButtonWithFrame:(CGRect)frame imageName:(NSString*)imageName bgImageName:(NSString*)bgImageName title:(NSString*)title SEL:(SEL)sel target:(id)target{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        //并且设置字体颜色为黑色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    //添加点击事件
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    //设置button的点击时候的高亮
    button.showsTouchWhenHighlighted=YES;
    return button;
}



//工厂方法创建button
+(UIButton*)buttonWithType:(UIButtonType)type andFrame:(CGRect)frame andTitle:(NSString *)title andBackgroundImage:(NSString *)imageName;
{
    UIButton *btn=[UIButton buttonWithType:type];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.userInteractionEnabled = YES ;
   
    return btn;
}



+(UIButton*)buttonWithType:(UIButtonType)type andFrame:(CGRect)frame andTag:(NSString *)tag andBackgroundImage:(NSString *)imageName;
{
    UIButton *btn=[UIButton buttonWithType:type];
    btn.frame=frame;
     btn.tag = [tag intValue];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.userInteractionEnabled = YES ;
    return btn;
}

+(UIButton*)buttonWithType:(UIButtonType)type andFrame:(CGRect)frame andTag:(NSString *)tag andTitle:(NSString *)title
{

    UIButton *btn=[UIButton buttonWithType:type];
    btn.frame=frame;
    btn.tag = [tag intValue];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.userInteractionEnabled = YES ;
    return btn;

}




+(UIButton*)buttonWithType:(UIButtonType)type andFrame:(CGRect)frame andLabelTitle:(NSString *)title andBackgroundImage:(NSString *)imageName;
{
    UIButton *btn=[UIButton buttonWithType:type];
    btn.frame=frame;
//    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.userInteractionEnabled = YES ;
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+12, frame.size.width, 20)];
    label.text = title ;
    
    return btn;
}



//block 回调点击事件
+(UIButton*)buttonWithType:(UIButtonType)type andFrame:(CGRect)frame andTitle:(NSString *)title andBackgroundImage:(NSString *)imageName andHandleEvent:(UIControlEvents)event andCompletionBlcok:(ActionBlock)block
{
    UIButton *btn=[UIButton buttonWithType:type];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [btn handleControlEvent:event withMyBlock:block];
    return btn;
}


//
+(UIButton*)buttonWithType:(UIButtonType)type frame:(CGRect)frame title:(NSString*)title backgroundImage:(NSString*)bgName  selectImage:(NSString*)selectName handleControlEvent:(UIControlEvents)event completionBlock:(ActionBlock)block
{
    UIButton *btn=[UIButton buttonWithType:type];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectName] forState:UIControlStateSelected];
    [btn handleControlEvent:event withMyBlock:block];
    return btn;
}


//处理事件
- (void)handleControlEvent:(UIControlEvents)event withMyBlock:(ActionBlock)block
{
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionMyBlock:) forControlEvents:event];
}

-(void)callActionMyBlock:(id)sender
{
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

@end
