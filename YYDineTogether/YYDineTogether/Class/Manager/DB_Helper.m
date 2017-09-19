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
#import "JSYHComboModel.h"
#import "JSYHAddressModel.h"

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
    [self.dataBase executeUpdate:@"create table if not exists getShoppingCart(userName text primary key,dataDic blob)"];
    [self.dataBase executeUpdate:@"create table if not exists getAddress(userName text primary key,dataJsonStr text)"];
    [self.dataBase executeUpdate:@"create table if not exists getSearchKeyword(userName text primary key,dataArray blob)"];
}

- (void)updateShoppingCartWithUserName:(NSString *)userName {
    NSArray *dishArray = [ShoppingCartManager sharedManager].shoppingCartDataArray;
    NSMutableArray *dishJsonArray = [NSMutableArray array];
    for (JSYHDishModel *model in dishArray) {
        NSString *jsonStr = [model modelToJSONString];
        [dishJsonArray addObject:jsonStr];
    }
    NSArray *comboArray = [ShoppingCartManager sharedManager].shoppingCartComboArray;
    NSMutableArray *comboJsonArray = [NSMutableArray array];
    for (JSYHComboModel *model in comboArray) {
        NSString *jsonStr = [model modelToJSONString];
        [comboJsonArray addObject:jsonStr];
    }
    NSDictionary *jsonDic = @{@"dishs":dishJsonArray,@"combs":comboJsonArray};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:nil];
    [self.dataBase executeUpdateWithFormat:@"INSERT Or Replace INTO getShoppingCart(userName, dataDic) VALUES (%@,%@)", userName, data];
    [self.dataBase close];
}

- (void)cleanAdminShoppingCart {
    NSDictionary *jsonDic = @{@"dishs":@[],@"combs":@[]};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDic options:0 error:nil];
    [self.dataBase executeUpdateWithFormat:@"INSERT Or Replace INTO getShoppingCart(userName, dataDic) VALUES (%@,%@)", @"admin", data];
    [self.dataBase close];
}

- (NSDictionary *)getShoppingCartWithUserName:(NSString *)userName {

    FMResultSet *set = [self.dataBase executeQueryWithFormat:@"SELECT * from getShoppingCart where userName = %@",userName];
    NSData *data = nil;
    while ([set next]) {
        data = [set dataForColumn:@"dataDic"];
    }
    if (data == nil) {
        [self.dataBase close];
        NSDictionary *dic = @{@"dishs":@[],@"combs":@[]};
        return dic;
    } else {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *dishJsonArray = dic[@"dishs"];
        NSArray *combsJsonArray = dic[@"combs"];
        NSMutableArray *dishArray = [NSMutableArray array];
        NSMutableArray *combArray = [NSMutableArray array];
        for (NSString *jsonStr in dishJsonArray) {
            JSYHDishModel *model = [JSYHDishModel modelWithJSON:jsonStr];
            [dishArray addObject:model];
        }
        for (NSString *jsonStr in combsJsonArray) {
            JSYHComboModel *model = [JSYHComboModel modelWithJSON:jsonStr];
            [combArray addObject:model];
        }
        NSDictionary *returnDic = @{@"dishs":dishArray,@"combs":combArray};
        [self.dataBase close];
        return returnDic;
    }
}

- (void)updateAddress:(JSYHAddressModel *)addressModel {
    NSString *jsonStr = [addressModel modelToJSONString];
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }

    [self.dataBase executeUpdateWithFormat:@"INSERT Or Replace INTO getAddress(userName, dataJsonStr) VALUES (%@,%@)", userName, jsonStr];
    [self.dataBase close];
}

- (JSYHAddressModel *)getAddressModel {
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }
    FMResultSet *set = [self.dataBase executeQueryWithFormat:@"SELECT * from getAddress where userName = %@",userName];
    NSString *jsonStr = nil;
    while ([set next]) {
        jsonStr = [set stringForColumn:@"dataJsonStr"];
    }
    if (jsonStr == nil) {
        return nil;
    } else {
       return [JSYHAddressModel modelWithJSON:jsonStr];
    }
}

//更新搜索关键字
- (void)updateSearchKeywordWithArray:(NSArray *)keywordArray {
    
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:keywordArray options:0 error:nil];
    [self.dataBase executeUpdateWithFormat:@"INSERT Or Replace INTO getSearchKeyword(userName, dataArray) VALUES (%@,%@)", userName, data];
    [self.dataBase close];
}

//获得搜索关键字
- (NSArray *)getKeywordArray {
    NSString *userName = [JSRequestManager sharedManager].userName;
    if (userName == nil || userName.length == 0) {
        userName = @"admin";
    }
    FMResultSet *set = [self.dataBase executeQueryWithFormat:@"SELECT * from getSearchKeyword where userName = %@",userName];
    NSData *data = nil;
    while ([set next]) {
        data = [set dataForColumn:@"dataArray"];
    }
    if (data == nil) {
        [self.dataBase close];
        NSArray *resultArray = @[];
        return resultArray;
    } else {
        NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.dataBase close];
        return resultArray;
    }

}

@end
