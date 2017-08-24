//
//  JSRequestManager.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/7/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSRequestManager.h"

#define JSRequest_Token [NSString stringWithFormat:@"bearer %@",_token]


@interface JSRequestManager ()



@end

@implementation JSRequestManager
+ (JSRequestManager *)sharedManager {
    static JSRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JSRequestManager alloc] init];
        manager.token = [[NSUserDefaults standardUserDefaults] valueForKey:@"JSYHToken"];
        manager.userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"JSYHUserName"];
    });
    return manager;
}

- (void)loginWithUserName:(NSString *)userName
                  Passord:(NSString *)password
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed {
    NSDictionary *dic = @{@"phone" : userName, @"pin" : password};
    [PPNetworkHelper POST:URL_Login parameters:dic success:^(id responseObject) {
        success(responseObject);
        self.userName = userName;
        NSString *token = responseObject[@"data"][@"token"];
        self.token = token;
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"JSYHToken"];
        [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"JSYHUserName"];
        [PPNetworkHelper setValue:[NSString stringWithFormat:@"bearer %@",token]forHTTPHeaderField:@"Authorization"];
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)homepageShopWithPage:(NSString *)page
                         lng:(NSString *)lng
                         lat:(NSString *)lat
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    
    [PPNetworkHelper GET:URL_HomePageShop parameters:@{@"page":page,@"areaid":@"1",@"lng":lng,@"lat":lat} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)homepageDishWithPage:(NSString *)page
                         lng:(NSString *)lng
                         lat:(NSString *)lat
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper GET:URL_HomePageDish parameters:@{@"page":page,@"areaid":@"1",@"lng":lng,@"lat":lat} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)shopDetailWithShopid:(NSString *)shopid
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper GET:URL_ShopDetail parameters:@{@"shopid":shopid} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)shopsWithPage:(NSString *)page
                  lng:(NSString *)lng
                  lat:(NSString *)lat
                 tagid:(NSString *)tagid
              Success:(PPHttpRequestSuccess)success
               Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper GET:URL_Shops parameters:@{@"page":page,@"areaid":@"1",@"lng":lng,@"lat":lat,@"tagid":tagid} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)tagsWithSuccess:(PPHttpRequestSuccess)success
                 Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper GET:URL_Tags parameters:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)comboWithSuccess:(PPHttpRequestSuccess)success
                  Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper GET:URL_Combo parameters:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getCombDetailWithComboid:(NSString *)comboid
                             lng:(NSString *)lng
                             lat:(NSString *)lat
                         Success:(PPHttpRequestSuccess)success
                          Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper GET:URL_ComboDetail parameters:@{@"combid":comboid,@"areaid":@"1",@"lng":lng,@"lat":lat} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)postOrderWithString:(NSString *)string
                    Success:(PPHttpRequestSuccess)success
                     Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper POST:URL_Order parameters:@{@"data":string} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getMemberAddressSuccess:(PPHttpRequestSuccess)success
                         Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper GET:URL_Member_address parameters:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)putMemberAddressWithDic:(NSDictionary *)dic
                        Success:(PPHttpRequestSuccess)success
                         Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper PUT:URL_Member_address parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)postMemberAddressWithDic:(NSDictionary *)dic Success:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper POST:URL_Member_address parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)deleteMemeberAddressWithDic:(NSDictionary *)dic Success:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper DELETE:URL_Member_address parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getMemberInfoSuccess:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper GET:URL_Member_info parameters:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)putMemberInfoWithDic:(NSDictionary *)dic
                        data:(NSData *)data
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
//    [PPNetworkHelper PUT:URL_Member_info parameters:dic success:^(id responseObject) {
//        success(responseObject);
//    } failure:^(NSError *error) {
//        failed(error);
//    }];
    [PPNetworkHelper PUT:URL_Member_info parameters:dic data:data responseCache:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }] ;
}

- (void)postMemberInfoWithDic:(NSDictionary *)dic data:(NSData *)data Success:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper POST:URL_Member_info parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)deleteMemeberInfoWithDic:(NSDictionary *)dic Success:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
    [PPNetworkHelper DELETE:URL_Member_info parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}




@end
