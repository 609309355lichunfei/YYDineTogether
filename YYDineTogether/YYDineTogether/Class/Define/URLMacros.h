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
#define URL_main @"http://api.calleat.cn"
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
//登出接口
#define URL_Logout [NSString stringWithFormat:@"%@/v1/logout/", URL_main]
//banner
#define URL_Banner [NSString stringWithFormat:@"%@/v1/banners/", URL_main]
//首页商店
#define URL_HomePageShop [NSString stringWithFormat:@"%@/v1/homepage/shop/", URL_main]
//首页菜品
#define URL_HomePageDish [NSString stringWithFormat:@"%@/v1/homepage/dish/", URL_main]
//套餐列表
#define URL_Combo [NSString stringWithFormat:@"%@/v1/comb/", URL_main]
//套餐详情
#define URL_ComboDetail [NSString stringWithFormat:@"%@/v1/comb/detail/", URL_main]
//商店详情
#define URL_ShopDetail [NSString stringWithFormat:@"%@/v1/shop/", URL_main]
//美食店分类
#define URL_Shops [NSString stringWithFormat:@"%@/v1/shops/", URL_main]
//获取 美食tag信息
#define URL_Tags [NSString stringWithFormat:@"%@/v1/shops/tags/", URL_main]
//提交预订单
#define URL_Order [NSString stringWithFormat:@"%@/v1/order/", URL_main]
//成员地址
#define URL_Member_address [NSString stringWithFormat:@"%@/v1/member/address/", URL_main]
//成员信息
#define URL_Member_info [NSString stringWithFormat:@"%@/v1/member/info/", URL_main]








#endif /* URLMacros_h */
