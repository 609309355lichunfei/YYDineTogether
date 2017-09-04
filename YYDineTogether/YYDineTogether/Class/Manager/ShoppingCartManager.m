//
//  ShoppingCartManager.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "ShoppingCartManager.h"
#import "JSYHDishModel.h"
#import "JSYHComboModel.h"
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
        NSDictionary *dic = [[DB_Helper defaultHelper] getShoppingCart];
        _shoppingCartManager.shoppingCartDataArray = [dic[@"dishs"] mutableCopy];
        _shoppingCartManager.shoppingCartComboArray = [dic[@"combs"] mutableCopy];
        _shoppingCartManager.shoppingCartDataShopArray = [NSMutableArray array];
    });
    return _shoppingCartManager;
}

- (void)addToShoppingCartWithDish:(JSYHDishModel *)dishModel {
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        if ([dishModel.dishid isEqualToNumber:model.dishid]) {
            model.count ++;
            [self shoppingCartCountChanged];
            [[DB_Helper defaultHelper] updateShoppingCart];
            return;
        }
    }
    JSYHDishModel *model = [dishModel copy];
    model.count = 1;
    [self.shoppingCartDataArray addObject:model];
    [self shoppingCartCountChanged];
    [[DB_Helper defaultHelper] updateShoppingCart];
}

- (void)addToShoppingCartWitComb:(JSYHComboModel *)combModel {
    for (JSYHComboModel *model in self.shoppingCartComboArray) {
        if ([model.combid isEqualToNumber:combModel.combid]) {
            model.count ++;
            [self shoppingCartCountChanged];
            [[DB_Helper defaultHelper] updateShoppingCart];
            return;
        }
    }
    JSYHComboModel *model = [JSYHComboModel new];
    model.combid = combModel.combid;
    model.originalprice = combModel.originalprice;
    model.name = combModel.name;
    model.count = 1;
    [self.shoppingCartComboArray addObject:model];
    [self shoppingCartCountChanged];
    [[DB_Helper defaultHelper] updateShoppingCart];
}

- (void)removeFromeShoppingCartWithDish:(JSYHDishModel *)dishModel {
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        if ([dishModel.dishid isEqualToNumber: model.dishid]) {
            model.count = model.count - 1;
            if (model.count == 0) {
                [self.shoppingCartDataArray removeObject:model];
                
            }
            break;
        }
    }
    [self shoppingCartCountChanged];
    [[DB_Helper defaultHelper] updateShoppingCart];
}

- (void)removeFromeShoppingCartWithComb:(JSYHComboModel *)combModel {
    for (JSYHComboModel *model in self.shoppingCartComboArray) {
        if ([model.combid isEqualToNumber:combModel.combid]) {
            model.count --;
            if (model.count == 0) {
                [self.shoppingCartComboArray removeObject:model];
            }
            
            break;
        }
    }
    [self shoppingCartCountChanged];
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

- (void)updateComboCountWithModel:(JSYHComboModel *)combModel {
    for (JSYHComboModel *model in self.shoppingCartComboArray) {
        if ([combModel.combid isEqualToNumber:model.combid]) {
            combModel.count = model.count;
            return;
        }
    }
    combModel.count = 0;
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

- (void)cleanShoppingcart {
    [self.shoppingCartDataArray removeAllObjects];
    [self.shoppingCartComboArray removeAllObjects];
    [[DB_Helper defaultHelper] updateShoppingCart];
    [self shoppingCartCountChanged];
}

- (NSString *)totalPrice {
    NSInteger total = 0;
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        total += model.count * [model.price integerValue];
    }
    for (JSYHComboModel *model in self.shoppingCartComboArray) {
        total += model.count *[model.originalprice integerValue];
    }
    return [NSString stringWithFormat:@"%ld",total];
}

- (NSInteger)count {
    return self.shoppingCartDataArray.count + self.shoppingCartComboArray.count;
}


@end
