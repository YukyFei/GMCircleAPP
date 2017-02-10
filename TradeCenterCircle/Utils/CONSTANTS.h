//
//  CONSTANTS.h
//  TradeCenterCircle
//
//  Created by weiwei-zhang on 16/8/9.
//  Copyright © 2016年 weiwei-zhang. All rights reserved.
//

#ifndef CONSTANTS_h
#define CONSTANTS_h



//safe string
#define SAFESTRING(str)  ( ( ((str)!=nil)&&![(str) isKindOfClass:[NSNull class]])?[NSString stringWithFormat:@"%@",(str)]:@"" )

//USERDEFAULT
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//设置友盟APP Key
#define UmengAppkey @"57dfb2a167e58e05bc002b73"

//设置友盟App Secret
#define UmengAppSecret @"f1bfdzwlmmwbvcecmy7q9xvsmnelivgy"

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
#define IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsiOS7Later                         !(IOSVersion < 7.0)

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//
#define retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6plus
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//iPhone5分辨率320x568，像素640x1136 iPhone6分辨率375x667，像素750x1334
//3.iPhone6 Plus 分辨率414x736，像素1242x2208，@3x，（注意，在这个分辨率下渲染后，图像等比降低pixel分辨率至1080p(1080x1920)


//pragma mark---File functions
#define PATH_OF_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#pragma mark ---- color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define SelfDefaultToolbarHeight            self.navigationController.navigationBar.frame.size.height
#define TabBarHeight                        49.0f
#define NaviBarHeight                       44.0f
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define Size(w, h)                          CGSizeMake(w, h)
#define RGB_TextDark                            RGB(10.0f, 10.0f, 10.0f)
#define Is4Inch                                 [UtilityFunc is4InchScreen]

// assert
#ifdef ENABLE_ASSERT_STOP
#define APP_ASSERT_STOP                     {LogRed(@"APP_ASSERT_STOP"); NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);}
#define APP_ASSERT(condition)               {NSAssert(condition, @" ! Assert");}
#else
#define APP_ASSERT_STOP                     do {} while (0);
#define APP_ASSERT(condition)               do {} while (0);
#endif

#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define FLOAT_TitleSizeNormal               18.0f
#define FLOAT_TitleSizeMini                 14.0f
#define RGB_TitleMini                       [UIColor blackColor]

#pragma mark ----Size ,X,Y, View ,Frame
#define Origin_x 0
#define Origin_y 0
#define StatusBar_Height 20
#define NavigationBar_HEIGHT 44
#define TABBAR_HEIGHT 49
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width

//get the  size of the Application
#define APP_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width

//get size of the view
#define VIEW_TX(view) (view.frame.origin.x)
#define VIEW_TY(view) (view.frame.origin.y)
#define VIEW_W(view)  (view.frame.size.width)
//#define VIEW_W(view)  (view.frame.size.width)

#define VIEW_H(view)  (view.frame.size.height)
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height)

//get the size of the frame
#define FRAME_TX(frame)  (frame.origin.x)
#define FRAME_TY(frame)  (frame.origin.y)
#define FRAME_W(frame)  (frame.size.width)
#define FRAME_H(frame)  (frame.size.height)
#define FRAME_BX(frame) (frame.origin.x+frame.size.width)
#define FRAME_BY(frame) (frame.origin.y+frame.size.height)

#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]
//清除背景色
#define CLEARCOLOR [UIColor clearColor]


#ifdef DEBUG
#define NSLog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...)
#endif


#ifdef DEBUG
#define YMLog( s, ... ) NSLog( @"<%@:%d>%@ %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithUTF8String:__PRETTY_FUNCTION__], [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define YMLog(...)
#endif


#pragma mark--单例
// 单例模式
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}


// GCD 多线程
#define Common_MainFun(aFun) dispatch_async( dispatch_get_main_queue(), ^(void){aFun;} );
#define Common_MainBlock(block) dispatch_async( dispatch_get_main_queue(), block );

#define Common_BackGroundBlock(block) dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block );
#define Common_BackGroundFun(aFun) dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){aFun;} );

//GCD 全局队列
#define GLOBAL_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//GCD主队列
#define MAIN_QUEUE dispatch_get_main_queue()


# define _SYNCHRONIZED_BEGIN \
@synchronized(self) {

# define _SYNCHRONIZED_END \
}

# define SYNCHRONIZED_BEGIN _SYNCHRONIZED_BEGIN
# define SYNCHRONIZED_END _SYNCHRONIZED_END


# define SHARED_IMPL_EXT(cls, name) \
+ (cls*)name { \
static cls* obj = nil; \
bool objinit = NO; \
SYNCHRONIZED_BEGIN \
if (obj == nil) { \
obj = [self alloc]; \
objinit = YES; \
} \
SYNCHRONIZED_END \
if (objinit) { \
[obj init]; } \
return obj; }

#define SHARED_IMPL(cls) SHARED_IMPL_EXT(cls, shared)


//导航栏返回图片
//#define BackButton_BG  @"goback"
#define BackButton_BG  @"common_icon_back_w"
//通用字体
#define COMMON_FONT [UIFont systemFontOfSize:16.0f]


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//屏幕比例 以320为准
#define WIDTH_SCALE (([UIScreen mainScreen].bounds.size.width)/320.0f)

//画一像素得线
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

//CGFloat xPos = 5;
//UIView *view = [[UIView alloc] initWithFrame:CGrect(x - SINGLE_LINE_ADJUST_OFFSET, 0, SINGLE_LINE_WIDTH, 100)];

#define DEF_WEAKSELF    __weak __typeof(self) weakSelf = self;
#define DEF_STRONGSELF    __strong __typeof(weakSelf) self = weakSelf;


#endif /* CONSTANTS_h */
