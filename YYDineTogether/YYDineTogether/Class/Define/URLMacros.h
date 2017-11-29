//
//  URLMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//



#ifndef URLMacros_h
#define URLMacros_h

/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    1
#define TestSever       0
#define ProductSever    0

#if DevelopSever

/**开发服务器*/
#define URL_main @"https://api.calleat.cn"
//#define URL_main @"http://192.168.11.122:8090" //展鹏

#elif TestSever

/**测试服务器*/
#define URL_main @"http://192.168.20.31:20000"

#elif ProductSever

/**生产服务器*/
#define URL_main @"http://192.168.20.31:20000"
#endif



#pragma mark - 详细接口地址

//测试接口
//NSString *const URL_Test = @"api/recharge/price/list";
#define URL_Test @"/api/cast/home/start"

//登录接口
#define URL_Login [NSString stringWithFormat:@"%@/v1/login/", URL_main]
//注册接口
#define URL_Register [NSString stringWithFormat:@"%@/register/", URL_main]
//短信验证码
#define URL_Sms [NSString stringWithFormat:@"%@/v1/sms/", URL_main]
//登出接口
#define URL_Logout [NSString stringWithFormat:@"%@/v1/logout/", URL_main]
//banner
#define URL_Banner [NSString stringWithFormat:@"%@/v1/banner/", URL_main]
//首页商店
#define URL_HomePageShop [NSString stringWithFormat:@"%@/v1/homepage/shop/", URL_main]
//首页菜品
#define URL_HomePageDish [NSString stringWithFormat:@"%@/v1/homepage/dish/", URL_main]
//首页套餐
#define URL_HomePageComb [NSString stringWithFormat:@"%@/v1/homepage/comb/", URL_main]
//套餐列表
#define URL_Combo [NSString stringWithFormat:@"%@/v1/comb/", URL_main]
//套餐详情
#define URL_ComboDetail [NSString stringWithFormat:@"%@/v1/comb/detail/", URL_main]
//套餐列表
#define URL_ComboTags [NSString stringWithFormat:@"%@/v1/comb/tags/", URL_main]
//套餐列表
#define URL_Combos [NSString stringWithFormat:@"%@/v1/combs/", URL_main]
//商店详情
#define URL_ShopDetail [NSString stringWithFormat:@"%@/v1/shop/", URL_main]
//美食店分类
#define URL_Shops [NSString stringWithFormat:@"%@/v1/shops/", URL_main]
//获取 美食tag信息
#define URL_Tags [NSString stringWithFormat:@"%@/v1/shops/tags/", URL_main]
//提交预订单
#define URL_Order [NSString stringWithFormat:@"%@/v1/member/preorder/", URL_main]
//成员地址
#define URL_Member_address [NSString stringWithFormat:@"%@/v1/member/address/", URL_main]
//成员信息
#define URL_Member_info [NSString stringWithFormat:@"%@/v1/member/info/", URL_main]
//根据地址计算配送费
#define URL_Postcost [NSString stringWithFormat:@"%@/v1/member/postcost/", URL_main]
//下单请求
#define URL_Member_takeorder [NSString stringWithFormat:@"%@/v1/member/takeorder/", URL_main]
//支付请求
#define URL_Member_pay [NSString stringWithFormat:@"%@/v1/member/pay/", URL_main]
//查单个订单
#define URL_Member_order [NSString stringWithFormat:@"%@/v1/member/order/", URL_main]
//差多个订单
#define URL_Member_orders [NSString stringWithFormat:@"%@/v1/member/orders/", URL_main]
//取消订单
#define URL_Member_cancelorder [NSString stringWithFormat:@"%@/v1/member/cancelorder/", URL_main]
//搜索
#define URL_Search [NSString stringWithFormat:@"%@/v1/search/", URL_main]
//用户反馈
#define URL_Feedback [NSString stringWithFormat:@"%@/v1/feedback/", URL_main]
//红包
#define URL_coupon [NSString stringWithFormat:@"%@/v1/coupon/", URL_main]
//分享
#define URL_Share [NSString stringWithFormat:@"%@/v1/member/share/", URL_main]







#endif /* URLMacros_h */
