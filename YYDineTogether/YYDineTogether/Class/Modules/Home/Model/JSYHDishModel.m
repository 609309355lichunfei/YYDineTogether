//
//  JSYHDishModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/22.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHDishModel.h"

@implementation JSYHDishModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.dishid = value;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    JSYHDishModel *model = [JSYHDishModel allocWithZone:zone];
    model.cateid = self.cateid;
    model.price = self.price;
    model.shoplogo = self.shoplogo;
    model.discountprice = self.discountprice;
    model.distance = self.distance;
    model.salescount = self.salescount;
    model.info = self.info;
    model.shopid = self.shopid;
    model.shopname = self.shopname;
    model.logo = self.logo;
    model.dishid = self.dishid;
    model.name = self.name;
    model.combid = self.combid;
    model.iscomb = self.iscomb;
    return model;
    
}

@end
