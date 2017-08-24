//
//  JSRequestManager.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/7/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPNetworkHelper.h"

@interface JSRequestManager : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *token;

+ (JSRequestManager *)sharedManager;

- (void)loginWithUserName:(NSString *)userName
                  Passord:(NSString *)password
                  Success:(PPHttpRequestSuccess)success
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

 @param string json
 */
- (void)postOrderWithString:(NSString *)string
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




@end
