//
//  ShoppingCartManager.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartManager : NSObject
+ (ShoppingCartManager *)sharedManager;

@property (strong, nonatomic) NSMutableArray *shoppingCartDataArray;
@end
