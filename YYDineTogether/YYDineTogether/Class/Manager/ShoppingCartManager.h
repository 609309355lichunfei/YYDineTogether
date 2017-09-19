//
//  ShoppingCartManager.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSYHDishModel, JSYHComboModel;

@interface ShoppingCartManager : NSObject
+ (ShoppingCartManager *)sharedManager;

@property (strong, nonatomic) NSMutableArray *shoppingCartComboArray;

@property (strong, nonatomic) NSMutableArray *shoppingCartDataArray;

@property (strong, nonatomic) NSMutableArray *shoppingCartDataShopArray;

@property (strong, nonatomic) NSString *totalPrice;

- (void)shoppingCartReloadData;

- (void)addWithAdmin;

- (void)addToShoppingCartWithDish:(JSYHDishModel *)dishModel;

- (void)addToShoppingCartWitComb:(JSYHComboModel *)combModel;

- (void)removeFromeShoppingCartWithDish:(JSYHDishModel *)dishModel;

- (void)removeFromeShoppingCartWithComb:(JSYHComboModel *)combModel;

- (void)updateCountWithModel:(JSYHDishModel *)dishModel;

- (void)updateComboCountWithModel:(JSYHComboModel *)combModel;

- (void)cleanShoppingcart;

@property (assign, nonatomic, readonly) NSInteger count;

//按照商店分类
- (void)clearUpDataArrayWithShop;

@end
