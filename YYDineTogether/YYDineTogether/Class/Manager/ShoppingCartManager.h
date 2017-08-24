//
//  ShoppingCartManager.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSYHDishModel;

@interface ShoppingCartManager : NSObject
+ (ShoppingCartManager *)sharedManager;

@property (strong, nonatomic) NSMutableArray *shoppingCartDataArray;

@property (strong, nonatomic) NSMutableArray *shoppingCartDataShopArray;

- (void)addToShoppingCartWithDish:(JSYHDishModel *)dishModel;

- (void)removeFromeShoppingCartWithDish:(JSYHDishModel *)dishModel;

- (void)updateCountWithModel:(JSYHDishModel *)dishModel;

//按照商店分类
- (void)clearUpDataArrayWithShop;

@end
