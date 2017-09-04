//
//  JSYHOrderModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/29.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHOrderModel.h"
#import "JSYHShopModel.h"

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
