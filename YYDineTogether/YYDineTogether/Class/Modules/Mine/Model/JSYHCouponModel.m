//
//  JSYHCouponModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/4.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHCouponModel.h"

@implementation JSYHCouponModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.coupon_id = value;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"value"]) {
        NSNumber *priceNumber = value;
        float price = priceNumber.integerValue / 100.0;
        self.value = [NSNumber numberWithFloat:price];
    }
}

@end
