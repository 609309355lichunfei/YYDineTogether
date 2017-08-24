//
//  DB_Helper.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "DB_Helper.h"
#import "FMDB.h"
#import "JSYHDishModel.h"

@interface DB_Helper ()
@property (strong, nonatomic)FMDatabase *dataBase;
@end

static DB_Helper *helper;
@implementation DB_Helper
+ (id)defaultHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (helper == nil) {
            helper = [[self alloc]init];
            helper.dataBase = [FMDatabase databaseWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/JSYHShoppingCart.sqlite"]];
            NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
        }
    });
    [helper.dataBase open];
    [helper createTable];
    return helper;
}

- (void)createTable {
    [self.dataBase executeUpdate:@"create table if not exists getShoppingCart(userName text primary key,dataArray blob)"];
}

- (void)updateShoppingCart {
    NSArray *dishArray = [ShoppingCartManager sharedManager].shoppingCartDataArray;
    NSMutableArray *dishJsonArray = [NSMutableArray array];
    for (JSYHDishModel *model in dishArray) {
        NSString *jsonStr = [model modelToJSONString];
        [dishJsonArray addObject:jsonStr];
    }
    
    NSString *userName = [JSRequestManager sharedManager].userName;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dishJsonArray options:0 error:nil];
    [self.dataBase executeUpdateWithFormat:@"INSERT Or Replace INTO getShoppingCart(userName, dataArray) VALUES (%@,%@)", userName, data];
    [self.dataBase close];
}

- (NSArray *)getShoppingCart {
    FMResultSet *set = [self.dataBase executeQueryWithFormat:@"SELECT * from getShoppingCart where userName = %@",[JSRequestManager sharedManager].userName];
    NSData *data = nil;
    while ([set next]) {
        data = [set dataForColumn:@"dataArray"];
    }
    if (data == nil) {
        NSArray *dataArray = [NSArray array];
        [self.dataBase close];
        return dataArray;
    } else {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSString *jsonStr in jsonArray) {
            JSYHDishModel *model = [JSYHDishModel modelWithJSON:jsonStr];
            [dataArray addObject:model];
        }
        [self.dataBase close];
        return dataArray;
    }
}
@end
