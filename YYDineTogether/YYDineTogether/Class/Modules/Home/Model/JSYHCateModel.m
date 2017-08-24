//
//  JSYHCateModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/23.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHCateModel.h"
#import "JSYHDishModel.h"

@implementation JSYHCateModel
- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"dishs"]) {
        NSMutableArray *dishs = [NSMutableArray array];
        for (NSDictionary *dishDic in value) {
            JSYHDishModel *model = [[JSYHDishModel alloc] init];
            [model setValuesForKeysWithDictionary:dishDic];
            [[ShoppingCartManager sharedManager] updateCountWithModel:model];
            [dishs addObject:model];
        }
        self.dishs = dishs;
    }
}


@end
