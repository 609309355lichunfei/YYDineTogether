//
//  JSYHComboModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/24.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHComboModel.h"
#import "JSYHDishModel.h"

@implementation JSYHComboModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.combid = value;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"dishs"]) {
        NSMutableArray *dishs = [NSMutableArray array];
        for (NSDictionary *dishDic in value) {
            JSYHDishModel *model = [[JSYHDishModel alloc] init];
            [model setValuesForKeysWithDictionary:dishDic];
            model.combid = [self.combid stringValue];
            [[ShoppingCartManager sharedManager] updateCountWithModel:model];
            [dishs addObject:model];
        }
        self.dishs = dishs;
    }
    if ([key isEqualToString:@"originalprice"]) {
        NSNumber *originalprice = value;
        float price = originalprice.integerValue / 100.0;
        self.originalprice = [NSNumber numberWithFloat:price];
    }
    if ([key isEqualToString:@"price"]) {
        NSNumber *originalprice = value;
        float price = originalprice.integerValue / 100.0;
        self.price = [NSNumber numberWithFloat:price];
    }
    
}



@end
