//
//  JSYHShopModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/22.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHShopModel.h"
#import "JSYHActivityModel.h"
#import "JSYHDishModel.h"
#import "JSYHCateModel.h"

@implementation JSYHShopModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.shopid = value;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"activites"]) {
        NSMutableArray *activites = [NSMutableArray array];
        for (NSDictionary *activityDic in value) {
            JSYHActivityModel *model = [[JSYHActivityModel alloc] init];
            [model setValuesForKeysWithDictionary:activityDic];
            [activites addObject:model];
        }
        self.activites = activites;
    } else if ([key isEqualToString:@"cates"]) {
        NSMutableArray *cates = [NSMutableArray array];
        for (NSDictionary *cate in value) {
            JSYHCateModel *model = [[JSYHCateModel alloc] init];
            [model setValuesForKeysWithDictionary:cate];
            [cates addObject:model];
        }
        self.cates = cates;
    } else if ([key isEqualToString:@"dishs"]) {
        NSMutableArray *dishs = [NSMutableArray array];
        for (NSDictionary *dishDic in value) {
            JSYHDishModel *model = [[JSYHDishModel alloc] init];
            [model setValuesForKeysWithDictionary:dishDic];
            [dishs addObject:model];
        }
        self.dishs = dishs;
    }
}

- (NSMutableArray *)dishs {
    if (_dishs == nil) {
        _dishs = [NSMutableArray array];
    }
    return _dishs;
}

- (void)updateHeightWithActivity {
    if (self.activites.count > 2) {
        if (_optinal) {
            self.height = 100 + self.activites.count * 22;
        } else {
            self.height = 138;
        }
    } else {
        self.height = 100 + self.activites.count * 22;
    }
    
}

- (void)updateHeightWithDish {
    self.shopCartHeight = 60 + self.dishs.count * 37;
}

- (void)updateHeightWithOrder {
    CGFloat remarksHeight = [self.remarks heightForFont:[UIFont fontWithName:App_FamilyFontName size:12] width:KScreenWidth - 90];
    self.orderHeight = 75 + self.dishs.count * 44 + remarksHeight - 10;
}

- (void)updateHeightWithSearchView {
    self.searchHeigh = 100 + self.activites.count * 22 + self.dishs.count * 77;
}

@end
