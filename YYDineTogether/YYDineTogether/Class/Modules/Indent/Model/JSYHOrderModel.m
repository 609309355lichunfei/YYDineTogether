//
//  JSYHOrderModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/29.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHOrderModel.h"
#import "JSYHShopModel.h"
#import "JSYHAddressModel.h"

@implementation JSYHOrderModel
- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"shops"]) {
        
        NSMutableArray *shopsArray = [NSMutableArray array];
        for (NSDictionary *shopDic in value) {
            JSYHShopModel *model = [[JSYHShopModel alloc] init];
            [model setValuesForKeysWithDictionary:shopDic];
            [model updateHeightWithOrder];
            [shopsArray addObject:model];
        }
        self.shops = shopsArray;
    } else if ([key isEqualToString:@"order_no"]) {
        self.order_no = [NSString stringWithFormat:@"%@",value];
    } else if ([key isEqualToString:@"address"]) {
        if ([NSStringFromClass([value class]) isEqualToString:@"__NSDictionaryI"]) {
            NSDictionary *addressDic = value;
            JSYHAddressModel *model = [[JSYHAddressModel alloc] init];
            [model setValuesForKeysWithDictionary:addressDic];
            self.addressModel = model;
        }
    } else if ([key isEqualToString:@"lastprice"]) {
        NSNumber *priceNumber = value;
        double price = priceNumber.integerValue / 100.0;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        self.lastprice = [NSNumber numberWithString:priceStr];
    } else if ([key isEqualToString:@"price"]) {
        NSNumber *priceNumber = value;
        double price = priceNumber.integerValue / 100.0;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        self.price = [NSNumber numberWithString:priceStr];
    } else if ([key isEqualToString:@"postcost"]) {
        NSNumber *priceNumber = value;
        double price = priceNumber.integerValue / 100.0;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        self.postcost = [NSNumber numberWithString:priceStr];
    } else if ([key isEqualToString:@"discountprice"]) {
        NSNumber *priceNumber = value;
        double price = priceNumber.integerValue / 100.0;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        self.discountprice = [NSNumber numberWithString:priceStr];
    } else if ([key isEqualToString:@"cut"]) {
        NSNumber *priceNumber = value;
        double price = priceNumber.integerValue / 100.0;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        self.cut = [NSNumber numberWithString:priceStr];
    } else if ([key isEqualToString:@"combcut"]) {
        NSNumber *priceNumber = value;
        double price = priceNumber.integerValue / 100.0;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        self.combcut = [NSNumber numberWithString:priceStr];
    }else if ([key isEqualToString:@"couponvalue"]) {
        NSNumber *priceNumber = value;
        double price = priceNumber.integerValue / 100.0;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        self.couponvalue = [NSNumber numberWithString:priceStr];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)updateOrderHeight {
    CGFloat height = 0;
    for (JSYHShopModel *model in self.shops) {
        height = height + model.orderHeight;
    }
    height = height + 140;
    self.height = height;
}

@end
