//
//  JSRequestManager.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/7/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNetworkHelper.h"

@interface JSRequestManager : NSObject

@property (assign, nonatomic) BOOL jpushLogin;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *token;

+ (JSRequestManager *)sharedManager;

- (void)loginWithUserName:(NSString *)userName
                  Passord:(NSString *)password
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed;


/**
 退出登录

 */
- (void)logoutWithSuccess:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed;



/**
 获取首页商店

 @param page 页数
 @param lng 经度
 @param lat 维度
 */
- (void)homepageShopWithPage:(NSString *)page
                         lng:(NSString *)lng
                         lat:(NSString *)lat
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed;

/**
 获取首页食品
 
 @param page 页数
 @param lng 经度
 @param lat 维度
 */
- (void)homepageDishWithPage:(NSString *)page
                         lng:(NSString *)lng
                         lat:(NSString *)lat
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed;


/**
 获取首页套餐

 @param page 页数
 @param lng 经度
 @param lat 维度
 */
- (void)homepageCombWithPage:(NSString *)page
                         lng:(NSString *)lng
                         lat:(NSString *)lat
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed;


/**
 活动页

 @param page 页数
 @param type 类型 1商家/2菜品/3套餐
 */
- (void)getBannerWithPage:(NSString *)page
                     type:(NSString *)type
                      lng:(NSString *)lng
                      lat:(NSString *)lat
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed;



/**
 商店详情

 @param shopid 商店id
 */
- (void)shopDetailWithShopid:(NSString *)shopid
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed;


/**
 美食店分类

 @param page 页数
 @param lng 经度
 @param lat 维度
 @param tagid 分类
 */
- (void)shopsWithPage:(NSString *)page
                  lng:(NSString *)lng
                  lat:(NSString *)lat
                 tagid:(NSString *)tagid
              Success:(PPHttpRequestSuccess)success
               Failed:(PPHttpRequestFailed)failed;


/**
 美食分类

 */
- (void)tagsWithSuccess:(PPHttpRequestSuccess)success
                 Failed:(PPHttpRequestFailed)failed;


/**
 套餐列表

 */
- (void)comboWithSuccess:(PPHttpRequestSuccess)success
                  Failed:(PPHttpRequestFailed)failed;


/**
 套餐详情

 @param comboid 套餐id
 @param lng 经度
 @param lat 维度
 */
- (void)getCombDetailWithComboid:(NSString *)comboid
                             lng:(NSString *)lng
                             lat:(NSString *)lat
                         Success:(PPHttpRequestSuccess)success
                          Failed:(PPHttpRequestFailed)failed;


/**
 提交预订单

 @param dic data
 */
- (void)postOrderWithDic:(NSDictionary *)dic
                    Success:(PPHttpRequestSuccess)success
                     Failed:(PPHttpRequestFailed)failed;



/**
 获得地址

 */
- (void)getMemberAddressSuccess:(PPHttpRequestSuccess)success
                         Failed:(PPHttpRequestFailed)failed;


/**
 修改地址

 */
- (void)putMemberAddressWithDic:(NSDictionary *)dic
                        Success:(PPHttpRequestSuccess)success
                         Failed:(PPHttpRequestFailed)failed;

/**
 添加地址

 */
- (void)postMemberAddressWithDic:(NSDictionary *)dic
                            Success:(PPHttpRequestSuccess)success
                             Failed:(PPHttpRequestFailed)failed;

/**
 删除地址

 */
- (void)deleteMemeberAddressWithDic:(NSDictionary *)dic
                               Success:(PPHttpRequestSuccess)success
                                Failed:(PPHttpRequestFailed)failed;


/**
 获得成员信息
 */
- (void)getMemberInfoSuccess:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed;



/**
 修改信息

 */
- (void)putMemberInfoWithDic:(NSDictionary *)dic
                        data:(NSData *)data
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed;



/**
 上传成员信息

 */
- (void)postMemberInfoWithDic:(NSDictionary *)dic
                         data:(NSData *)data
                      Success:(PPHttpRequestSuccess)success
                       Failed:(PPHttpRequestFailed)failed;


/**
 删除成员信息

 */
- (void)deleteMemeberInfoWithDic:(NSDictionary *)dic
                            Success:(PPHttpRequestSuccess)success
                             Failed:(PPHttpRequestFailed)failed;


/**
 根据地址计算配送费

 @param addressid 地址id
 @param orderNo 订单number
 */
- (void)getPostcostWithAddressid:(NSString *)addressid
                         orderNo:(NSString *)orderNo
                         Success:(PPHttpRequestSuccess)success
                          Failed:(PPHttpRequestFailed)failed;


/**
 下单申请

 @param order_no 订单number
 @param couponid 红包id
 @param remarks 备注
 @param addressid 地址id
 */
- (void)takeorderWithOrderno:(NSString *)order_no
                    couponid:(NSString *)couponid
                     remarks:(NSArray *)remarks
                   addressid:(NSString *)addressid
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed;


/**
 查询单个订单

 @param order_no 订单号
 @param success 成功
 @param failed 失败
 */
- (void)getorderWithOrderNo:(NSString *)order_no
                    Success:(PPHttpRequestSuccess)success
                     Failed:(PPHttpRequestFailed)failed;


/**
 查询多个订单

 @param page 页数
 */
- (void)getOrdersWithPage:(NSString *)page
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed;


/**
 取消订单

 @param orderno 订单号
 */
- (void)cancelorderWithOrderNO:(NSString *)orderno
                       Success:(PPHttpRequestSuccess)success
                        Failed:(PPHttpRequestFailed)failed;


/**
 支付请求

 @param type 支付类型
 @param order_no 订单号
 */
- (void)payWithPaytype:(NSString *)type
               Orderno:(NSString *)order_no
               Success:(PPHttpRequestSuccess)success
                Failed:(PPHttpRequestFailed)failed;


/**
 搜索

 @param key 关键字
 */
- (void)getSearchWithKey:(NSString *)key
                    page:(NSString *)page
                 Success:(PPHttpRequestSuccess)success
                  Failed:(PPHttpRequestFailed)failed;


/**
 用户反馈

 @param feedback 反馈
 */
- (void)postFeedback:(NSString *)feedback
          imageArray:(NSArray *)imageArray
      imageNameArray:(NSArray *)imageNameArray
             Success:(PPHttpRequestSuccess)success
              Failed:(PPHttpRequestFailed)failed;


/**
 红包

 @param page 页数
 */
- (void)getCouponWithPage:(NSString *)page
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed;





@end
