
#ifndef YourMate_Service_h
#define YourMate_Service_h


#define signId 1  //预处理命令判断，写1代表生产环境、写2代表测试环境   ---------不用再去注释了

#if signId == 1

//生产环境
#define hostURL @"http://owner.gmq.csq365.com/app/index"
#define hostURLNotAP @"http://owner.gmq.csq365.com/Service/CommunityServices/service_type/1"
#define CsqPrice @"http://web.gmq.csq365.com/yiishop/Csqpay/Prepay"
#define demoURL @"http://owner.gmq.csq365.com/yiishop/app/index.html"
#define demoURLL @"http://owner.gmq.csq365.com"
#define demoWebURLL @"http://web.gmq.csq365.com"
#define demoWebURL @"http://owner.gmq.csq365.com/yiishop/index/cgindex.html"
#define demoWebBAIDU @"http://owner.gmq.csq365.com/yiishop/index/goGroupBuy"
#define demoWebOrderURL @"http://owner.gmq.csq365.com/yiishop/OrderList/Index.html"
#define BaseURL @"http://owner.gmq.csq365.com"
#define RefreshTokenURL @"http://web.gmq.csq365.com/yiishop/Site/UserGetSession?platform=app"
#define RefreshTokenISLOPGINURL @"http://web.gmq.csq365.com/yiishop/Site/UserLogin?"
#define webCOntrollerURl @"http://web.gmq.csq365.com/yiishop"
#define BSURL @"http://owner.gmq.csq365.com/Service/CommunityServices/service_type/1"

#elif signId == 2

//测试环境
#define hostURL @"http://owner.gmq.dev.csq365.com/app/index"
#define hostURLNotAP @"http://owner.gmq.dev.csq365.com/Service/CommunityServices/service_type/1"
#define CsqPrice @"http://web.gmq.dev.csq365.com/yiishop/Csqpay/Prepay"
#define demoURL @"http://owner.gmq.dev.csq365.com/yiishop/app/index.html"
#define demoURLL @"http://owner.gmq.dev.csq365.com"
#define demoWebURLL @"http://web.gmq.dev.csq365.com"
#define demoWebURL @"http://owner.gmq.dev.csq365.com/yiishop/index/cgindex.html"
#define demoWebBAIDU @"http://owner.gmq.dev.csq365.com/yiishop/index/goGroupBuy"
#define demoWebOrderURL @"http://owner.gmq.dev.csq365.com/yiishop/OrderList/Index.html"
#define BaseURL @"http://owner.gmq.dev.csq365.com"
#define RefreshTokenURL @"http://web.gmq.dev.csq365.com/yiishop/Site/UserGetSession?platform=app"
#define RefreshTokenISLOPGINURL @"http://web.gmq.dev.csq365.com/yiishop/Site/UserLogin?"
#define webCOntrollerURl @"http://web.gmq.dev.csq365.com/yiishop"
#define BSURL @"http://owner.gmq.dev.csq365.com/Service/CommunityServices/service_type/1"

#else
#endif

//微信支付
//#define  WXAPP_ID @"wx929cd72148f43901"
//#define  MCH_ID @"1355592502"
#define AliPay @"SsYZBAlipay"
static NSString *const APP_ID = @"App_id";
static NSString *const ZP_ID = @"csq";


//单例
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

// 全局
static NSString *const kLoginSuccess = @"LoginSuccess";
static NSString * const BUILDINGPLIST = @"building.plist" ;
static NSString * const HOUSEPLIST = @"house.plist" ;
static NSString *const ADDRESSPLIST = @"address.plist";
static NSString *const CHANGEADDRESSPLIST = @"changeAddress.plist";

//用于判断是否是第一次进入某个特定的页面
static NSString * const kGetIntoVC = @"GetIntoVC";

//用于判断是否是第一次启动app
static NSString * const kGetIntoApp = @"GetIntoApp";

//用于判断在哪个控制器弹出网页加载异常提示框
static NSString * const kAlertView = @"AlertView";

//用于上传device_Token到服务器
static NSString *const kDevice_Token = @"device_Token";

//用于标记支付成功
static NSString *const kSucess_Pay = @"sucessPay";

static NSString *const kLoginRefreshToken = @"login_refresh_token";

//用于标记是否登记地址
static NSString *const kUser_Space_State = @"user_space_state";

//登录首次
static NSString *const kLoginToken = @"login_token";

static NSString *const kTokenExpire = @"token_expire";
static NSString *const kUserId = @"user_id";
static NSString *const kPhoneNum = @"phone_num";
static NSString *const kUserNick = @"user_nick";
static NSString *const kCommunityId = @"Community_id";
static NSString *const kCommunity_name = @"Community_name";
//发送验证码
static NSString *const kUserGetCode = @"User_Get_Code";
//登录
static NSString *const kUserValidCode = @"User_Valid_Code";
//刷新token
static NSString *const kUserRefreshToken = @"User_Refresh_Token";

//推送
static NSString *const kSetDeviceToken = @"set_device";

//切换地址

//选择小区
static NSString *const kSelect_Community = @"Select_Community";
//房间名
static NSString * const kSpace_name = @"Space_name" ;
//房间id
static NSString * const kSpace_id = @"Space_id" ;

//小区业主验证(1,验证通过 2，验证拒绝，3验证中,4;未提交资料)
static NSString * const kCommunity_valid_status = @"Community_valid_status" ;

static NSString * const kAddress_valid_status = @"Address_valid_status" ;
//合作状态：1.合作中；2.商讨中；3.终止合作
static NSString *const kCommunity_status = @"Community_status";

//获取地址列表
static NSString *const kReg_Space_List = @"Reg_Space_List";
//删除地址
static NSString *const kUSER_DEL_ADDRESS = @"User_Del_Address";
//默认地址
static NSString *const kDEFAULT_ADDRESS_SET = @"Default_Address_Set";
//选择小区的接口服务
static NSString *const kLat = @"Lat";
static NSString *const kLng = @"Lng";
static NSString *const kKeyword= @"Keyword";
static NSString *const kType = @"Type";
static NSString *const kDesc = @"Desc";

//验证身份
static NSString *const kUser_Community_Valid = @"User_Community_Valid";


//快递接口
//楼宇
static NSString * const GET_BUILD = @"Get_Build" ;
//房间
static NSString * const GET_Floor = @"Get_Floor" ;
//快递类别、目的地、下单须知‘所在区域
static NSString * const GET_EXPRESS = @"Get_Express" ;
//快递下单
static NSString * const SUB_EXPRESS = @"Sub_Express" ;

//所有页面的轮播图
static NSString * const kGetFigure = @"Get_Figure" ;

//首页滚动通知
static NSString * const kRoll_Notice = @"Roll_Notice" ;
//通知列表
static NSString * const kRecent_Notice = @"Recent_Notice" ;

//首页图标
static NSString * const kGetIndex = @"Get_Index" ;
//商铺列表
static NSString * const kGetShopList = @"Get_Shop_List" ;
//商品列表
static NSString * const kGetProductList = @"Get_Product_List" ;
//获取优惠券
static NSString * const kAjaxCreateCouponList = @"Ajax_Create_CouponList" ;
//领取平台优惠券
static NSString * const kCreateCoupon = @"Create_Coupon" ;
//商品预定列表
static NSString * const kGetReserveList = @"Get_Reserve_List" ;
//商品分类 轮播图
static NSString * const GET_PRODUCT_CAT = @"Get_Product_Cat" ;
//餐饮指南
static NSString * const Food_GUIDE = @"Food_guide" ;
//停车服务
static NSString * const Get_CAR = @"Get_Car" ;
//停车信息
static NSString * const GET_CAR_LIST = @"Get_Car_List" ;
//详细信息
static NSString * const GET_CAR_DETAIL = @"Get_Car_Detail" ;
//空气质量
static NSString * const kGET_Weather_List = @"Get_Weather_List" ;


//我的
//个人中心
static NSString * const GET_CRNTER = @"Get_Center" ;
//我的快递
static NSString * const GET_EXPRESS_LIST = @"Get_Express_List" ;
//我的订单
static NSString * const kGetOrderList = @"Get_Order_List" ;
//订单详情
static NSString * const kOrderDetail = @"Order_Detail" ;
//订单退款
static NSString * const kTuiFee = @"TuiFee" ;
//我的优惠券
static NSString * const kMyCouponList = @"My_Coupon_List" ;
//我的快递费
static NSString * const kGetOrderMoney = @"Get_Order_Money" ;
//我的地址
static NSString * const GET_ADRESS_LIST = @"Get_Address_List" ;
//地址详情
static NSString * const GET_ADRESS_DETAIL = @"Get_Address_Detail" ;
//添加新地址
static NSString * const SUB_ADDRESS = @"Sub_Address" ;
//编辑地址
static NSString * const UPDATE_ADDRESS = @"Update_Address" ;
//设为默认地址，删除地址
static NSString * const ADDRESS_DEFAULT = @"Address_Default" ;
//我的资料
static NSString * const GET_USER_DETAIL = @"Get_User_detail" ;

static NSString * const SUB_USER_DETAIL = @"Sub_User_detail" ;
//修改资料
//static NSString * const GET_USER_DETAIL = @"Get_User_detail" ;
//退出登录
static NSString * const kLoginOut = @"Login_Out" ;


#define KNotificationSwitchUserLogin @"SwitchUserLogin"
#define KNotificationSwitchHome @"SwitchHome"
#define KNotificationOrderPayNotification @"NotificationOrderPayNotification"
#define KNotificationOrderPayFail @"NotificationOrderPayFail"
//选择小区后首页数据刷新
#define KNotificationReloDataHome @"relodataHomeViewController"
//我的报事
#define KNotificationEvaluationOwner @"NotificationEvaluationOwner"



#endif
