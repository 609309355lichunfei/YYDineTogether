//
//  ShoppingCartManager.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "ShoppingCartManager.h"
#import "JSYHDishModel.h"
#import "JSYHShopModel.h"
#import "DB_Helper.h"

static ShoppingCartManager *_shoppingCartManager;

@interface ShoppingCartManager ()

@end

@implementation ShoppingCartManager
+ (ShoppingCartManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shoppingCartManager = [[ShoppingCartManager alloc]init];
        _shoppingCartManager.shoppingCartDataArray = [[[DB_Helper defaultHelper] getShoppingCart] mutableCopy];
        _shoppingCartManager.shoppingCartDataShopArray = [NSMutableArray array];
    });
    return _shoppingCartManager;
}

- (void)addToShoppingCartWithDish:(JSYHDishModel *)dishModel {
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        if ([dishModel.dishid isEqualToNumber:model.dishid]) {
            model.count ++;
            if ([dishModel.iscomb isEqualToString:@"1"]) {
                model.iscomb = @"1";
            }
            return;
        }
    }
    JSYHDishModel *model = [dishModel copy];
    model.count = 1;
    [self.shoppingCartDataArray addObject:model];
    [self shoppingCartCountChanged];
    [[DB_Helper defaultHelper] updateShoppingCart];
}

- (void)removeFromeShoppingCartWithDish:(JSYHDishModel *)dishModel {
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        if ([dishModel.dishid isEqualToNumber: model.dishid]) {
            model.count = model.count - 1;
            if (model.count == 0) {
                [self.shoppingCartDataArray removeObject:model];
                [self shoppingCartCountChanged];
            }
            break;
        }
    }
    [[DB_Helper defaultHelper] updateShoppingCart];
}

- (void)shoppingCartCountChanged{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSYHShoppingCartCountChanged" object:nil];
}

- (void)updateCountWithModel:(JSYHDishModel *)dishModel {
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        if ([dishModel.dishid isEqualToNumber:model.dishid]) {
            dishModel.count = model.count;
            return;
        }
    }
    dishModel.count = 0;
}

- (void)clearUpDataArrayWithShop {
    [self.shoppingCartDataShopArray removeAllObjects];
    for (JSYHDishModel *dishModel in self.shoppingCartDataArray) {
        BOOL isexsit = NO;
        for (JSYHShopModel *shopModel in self.shoppingCartDataShopArray) {
            if (dishModel.shopid == [shopModel.shopid integerValue]) {
                isexsit = YES;
                [shopModel.dishs addObject:dishModel];
                break;
            }
        }
        if (!isexsit) {
            JSYHShopModel *shopModel = [[JSYHShopModel alloc] init];
            shopModel.name = dishModel.shopname;
            shopModel.shopid = [NSNumber numberWithInteger:dishModel.shopid];
            shopModel.logo = dishModel.shoplogo;
            [shopModel.dishs addObject:dishModel];
            [self.shoppingCartDataShopArray addObject:shopModel];
        }
    }
}

- (NSString *)totalPrice {
    NSInteger total = 0;
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        total += model.count * [model.price integerValue];
    }
    return [NSString stringWithFormat:@"%ld",total];
}


@end
