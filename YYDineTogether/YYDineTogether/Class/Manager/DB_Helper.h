//
//  DB_Helper.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DB_Helper : NSObject
+ (id)defaultHelper;

- (void)updateShoppingCart;

- (NSArray *)getShoppingCart;
@end
