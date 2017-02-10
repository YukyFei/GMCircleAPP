//
//  FontSize.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/31.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#ifndef FontSize_h
#define FontSize_h


#define fontSizePath [[NSBundle mainBundle] pathForResource:@"FontSize" ofType:@"plist"]
#define fontSizeDic [NSDictionary dictionaryWithContentsOfFile:fontSizePath]
#define fontSize(titleName) fontSizeDic[titleName]


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && ([UIScreen mainScreen].bounds.size.height) < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && ([UIScreen mainScreen].bounds.size.height) == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && ([UIScreen mainScreen].bounds.size.height) == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && ([UIScreen mainScreen].bounds.size.height) == 736.0)

//适配字号
#define default_Minecell_title_size         @"default_Minecell_title_size"
#define default_Logo_title_size             @"default_Logo_title_size"
#define default_NavBar_title_size           @"default_NavBar_title_size"
#define default_RightNav_title_size         @"default_RightNav_title_size"
#define default_Sub_Express_title_size      @"default_Sub_Express_title_size"
#define default_Address_title_size      @"default_Address_title_size"
#define default_airquality_title_size      @"default_airquality_title_size"

//登录页面字号适配
#define default_Login_title_size            @"default_Login_title_size"
#define default_UserPassword_title_size     @"default_UserPassword_title_size"

//我的优惠券页面字号适配
#define default_Price_size                  @"default_Price_size"
#define default_Title_size                  @"default_Title_size"
#define default_SubTitle_size               @"default_SubTitle_size"

//我的快递费页面字号适配
#define default_ExpressFee_Title_size       @"default_ExpressFee_Title_size"
#define default_ExpressFee_SubTitle_size    @"default_ExpressFee_SubTitle_size"

//工具栏字号和高度适配
#define default_TabBar_title_size           @"default_TabBar_title_size"
#define default_TabBar_height_size          @"default_TabBar_height_size"

//适配高度
#define default_Banner_height_size          @"default_Banner_height_size"
#define default_HomeCell_height_size        @"default_HomeCell_height_size"

//美食上门价格选择按钮的位置
#define default_FoodShop_sizex_size         @"default_FoodShop_sizex_size"
//美食上门按钮索引选择文字的大小
#define default_FoodShop_title_size         @"default_FoodShop_title_size"
//美食上门按钮索引选择文字的大小
#define default_FoodIndex_title_size        @"default_FoodIndex_title_size"

#endif /* FontSize_h */
