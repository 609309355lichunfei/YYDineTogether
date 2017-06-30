//
//  ShoppingCartManager.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "ShoppingCartManager.h"

static ShoppingCartManager *_shoppingCartManager;

@interface ShoppingCartManager ()

@end

@implementation ShoppingCartManager
+ (ShoppingCartManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shoppingCartManager = [[ShoppingCartManager alloc]init];
        _shoppingCartManager.shoppingCartDataArray = [NSMutableArray array];
    });
    return _shoppingCartManager;
}


@end
