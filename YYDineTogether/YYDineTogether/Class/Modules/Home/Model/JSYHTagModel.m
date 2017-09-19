//
//  JSYHTagModel.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/7.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHTagModel.h"

@implementation JSYHTagModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.tagId = value;
    }
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
