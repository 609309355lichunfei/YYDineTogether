//
//  JSYHUserModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/24.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHUserModel.h"

static JSYHUserModel *model;

@implementation JSYHUserModel

+ (JSYHUserModel *)defaultModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[JSYHUserModel alloc] init];
        model.ischangelogo = @"0";
    });
    return model;;
}

@end
