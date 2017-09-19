//
//  DB_Helper.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>


@class JSYHAddressModel;
@interface DB_Helper : NSObject
+ (id)defaultHelper;


//更新购物车本地数据
- (void)updateShoppingCartWithUserName:(NSString *)userName;

//获得购物车本地数据
- (NSDictionary *)getShoppingCartWithUserName:(NSString *)userName;

//清空游客购物车
- (void)cleanAdminShoppingCart;

//更新首选地址
- (void)updateAddress:(JSYHAddressModel *)addressModel;

//获得首选地址
- (JSYHAddressModel *)getAddressModel;

//更新搜索关键字
- (void)updateSearchKeywordWithArray:(NSArray *)keywordArray;

//获得搜索关键字
- (NSArray *)getKeywordArray;
@end
