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
        NSString *userName = [JSRequestManager sharedManager].userName;
        if (userName == nil || userName.length == 0) {
            userName = @"admin";
        }
        NSDictionary *dic = [[DB_Helper defaultHelper] getShoppingCartWithUserName:userName];
        _shoppingCartManager.shoppingCartDataArray = [dic[@"dishs"] mutableCopy];
        _shoppingCartManager.shoppingCartComboArray = [dic[@"combs"] mutableCopy];
        _shoppingCartManager.shoppingCartDataShopArray = [NSMutableArray array];
    });
    return _shoppingCartManager;
}

- (void)addWithAdmin {
    NSDictionary *dic = [[DB_Helper defaultHelper] getShoppingCartWithUserName:@"admin"];
    NSArray *dishArray = dic[@"dishs"];
    NSArray *combArray = dic[@"combs"];
    for (JSYHDishModel *dishModel in dishArray) {
        BOOL isExsit = NO;
        for (JSYHDishModel *model in self.shoppingCartDataArray) {
            if ([dishModel.dishid isEqualToNumber:model.dishid]) {
                isExsit = YES;
                model.shopcartCount = model.shopcartCount + dishModel.shopcartCount;
            }
        }
        if (isExsit == NO) {
            [self.shoppingCartDataArray addObject:dishModel];
        }
        
    }
    for (JSYHComboModel *combModel in combArray) {
        BOOL isExsit = NO;
        for (JSYHComboModel *model in self.shoppingCartComboArray) {
            if ([combModel.combid isEqualToNumber:model.combid]) {
                isExsit = YES;
                model.count = model.count + combModel.count;
            }
        }
        if (isExsit == NO) {
            [self.shoppingCartComboArray addObject:combModel];
        }
    }
    [[DB_Helper defaultHelper] cleanAdminShoppingCart];
    [self shoppingCartCountChanged];
}

- (void)shoppingCartReloadData {
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }
    NSDictionary *dic = [[DB_Helper defaultHelper] getShoppingCartWithUserName:userName];
    self.shoppingCartDataArray = [dic[@"dishs"] mutableCopy];
    self.shoppingCartComboArray = [dic[@"combs"] mutableCopy];
    self.shoppingCartDataShopArray = [NSMutableArray array];
    [self shoppingCartCountChanged];
}

- (void)addToShoppingCartWithDish:(JSYHDishModel *)dishModel {
    [MobClick event:@"add_dish"];
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        if ([dishModel.dishid isEqualToNumber:model.dishid]) {
            model.shopcartCount ++;
            [self shoppingCartCountChanged];
            NSString *userName = [JSRequestManager sharedManager].userName;
            if (userName == nil || userName.length == 0) {
                userName = @"admin";
            }
            [[DB_Helper defaultHelper] updateShoppingCartWithUserName:userName];
            return;
        }
    }
    JSYHDishModel *model = [dishModel copy];
    model.shopcartCount = 1;
    [self.shoppingCartDataArray addObject:model];
    [self shoppingCartCountChanged];
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }
    [[DB_Helper defaultHelper] updateShoppingCartWithUserName:userName];
}

- (void)addToShoppingCartWitComb:(JSYHComboModel *)combModel {
    [MobClick event:@"add_meal"];
    for (JSYHComboModel *model in self.shoppingCartComboArray) {
        if ([model.combid isEqualToNumber:combModel.combid]) {
            model.count ++;
            [self shoppingCartCountChanged];
            NSString *userName = [JSRequestManager sharedManager].userName;
            if (userName == nil || userName.length == 0) {
                userName = @"admin";
            }
            [[DB_Helper defaultHelper] updateShoppingCartWithUserName:userName];
            return;
        }
    }
    JSYHComboModel *model = [JSYHComboModel new];
    model.combid = combModel.combid;
    model.originalprice = combModel.originalprice;
    model.price = combModel.price;
    model.name = combModel.name;
    model.count = 1;
    [self.shoppingCartComboArray addObject:model];
    [self shoppingCartCountChanged];
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }
    [[DB_Helper defaultHelper] updateShoppingCartWithUserName:userName];
}

- (void)removeFromeShoppingCartWithDish:(JSYHDishModel *)dishModel {
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        if ([dishModel.dishid isEqualToNumber: model.dishid]) {
            model.shopcartCount = model.shopcartCount - 1;
            if (model.shopcartCount == 0) {
                [self.shoppingCartDataArray removeObject:model];
                
            }
            break;
        }
    }
    [self shoppingCartCountChanged];
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }
    [[DB_Helper defaultHelper] updateShoppingCartWithUserName:userName];
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
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }
    [[DB_Helper defaultHelper] updateShoppingCartWithUserName:userName];
}

- (void)shoppingCartCountChanged{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSYHShoppingCartCountChanged" object:nil];
}

- (void)updateCountWithModel:(JSYHDishModel *)dishModel {
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        if ([dishModel.dishid isEqualToNumber:model.dishid]) {
            dishModel.shopcartCount = model.shopcartCount;
            return;
        }
    }
    dishModel.shopcartCount = 0;
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
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }
    [[DB_Helper defaultHelper] updateShoppingCartWithUserName:userName];
    [self shoppingCartCountChanged];
}

- (NSString *)totalPrice {
    CGFloat total = 0.0;
    for (JSYHDishModel *model in self.shoppingCartDataArray) {
        total += model.shopcartCount * [model.discountprice floatValue];
    }
    for (JSYHComboModel *model in self.shoppingCartComboArray) {
        total += model.count * [model.price floatValue];
    }
    NSNumber *price = [NSNumber numberWithFloat:total];
    return [NSString stringWithFormat:@"%@",price];
}

- (NSInteger)count {
    NSInteger count = 0;
    for (JSYHDishModel *dishModel in self.shoppingCartDataArray) {
        count = dishModel.shopcartCount + count;
    }
    for (JSYHComboModel *comboModel in self.shoppingCartComboArray) {
        count = comboModel.count + count;
    }
    
    return count;
}


@end
