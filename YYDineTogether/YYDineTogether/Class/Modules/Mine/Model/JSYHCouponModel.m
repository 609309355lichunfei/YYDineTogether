//
//  JSYHCouponModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/4.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHCouponModel.h"

@implementation JSYHCouponModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.canUse = YES;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.coupon_id = value;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"value"]) {
        NSNumber *priceNumber = value;
        double price = priceNumber.integerValue / 100.0;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        self.value = [NSNumber numberWithString:priceStr];
    } else if ([key isEqualToString:@"full"]) {
        NSNumber *priceNumber = value;
        double price = priceNumber.integerValue / 100.0;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        self.full = [NSNumber numberWithString:priceStr];
    }
}

@end
