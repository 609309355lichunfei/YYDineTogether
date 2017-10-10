//
//  JSRequestManager.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/7/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSRequestManager.h"

#import "JSYHUserModel.h"
#import "LoginViewController.h"
#import <JPUSHService.h>

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

- (void)setHeaderToken {
    [PPNetworkHelper closeAES];
    if (_token != nil && _token.length > 0 ) {
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    } else {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"JSYHToken"];
        _token = token;
        [PPNetworkHelper setValue:JSRequest_Token forHTTPHeaderField:@"Authorization"];
    }
}

- (void)loginWithUserName:(NSString *)userName
                  Passord:(NSString *)password
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed {
    NSDictionary *dic = @{@"phone" : userName, @"pin" : password};
    [PPNetworkHelper POST:URL_Login parameters:dic success:^(id responseObject) {
        
        self.userName = userName;
        NSString *token = responseObject[@"data"][@"token"];
        self.token = token;
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"JSYHToken"];
        [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"JSYHUserName"];
        [PPNetworkHelper setValue:[NSString stringWithFormat:@"bearer %@",token]forHTTPHeaderField:@"Authorization"];
        success(responseObject);
        [[JSRequestManager sharedManager] getMemberInfoSuccess:^(id responseObject) {
            NSDictionary *dataDic = responseObject[@"data"];
            [[JSYHUserModel defaultModel] setValuesForKeysWithDictionary:dataDic];
        } Failed:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)logoutWithSuccess:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper POST:URL_Logout parameters:nil success:^(id responseObject) {
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:1];
        _token = nil;
        _userName = nil;
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"JSYHToken"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"JSYHUserName"];
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)homepageShopWithPage:(NSString *)page
                         lng:(NSString *)lng
                         lat:(NSString *)lat
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    
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
    [self setHeaderToken];
    [PPNetworkHelper GET:URL_HomePageDish parameters:@{@"page":page,@"areaid":@"1",@"lng":lng,@"lat":lat} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)homepageCombWithPage:(NSString *)page
                         lng:(NSString *)lng
                         lat:(NSString *)lat
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper GET:URL_HomePageComb parameters:@{@"page":page,@"areaid":@"1",@"lng":lng,@"lat":lat} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getBannerWithPage:(NSString *)page
                     type:(NSString *)type
                      lng:(NSString *)lng
                      lat:(NSString *)lat
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper GET:URL_Banner parameters:@{@"page":page,@"type":type,@"lng":lng,@"lat":lat} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)shopDetailWithShopid:(NSString *)shopid
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
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
    [self setHeaderToken];
    [PPNetworkHelper GET:URL_Shops parameters:@{@"page":page,@"areaid":@"1",@"lng":lng,@"lat":lat,@"tagid":tagid} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)tagsWithSuccess:(PPHttpRequestSuccess)success
                 Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper GET:URL_Tags parameters:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)comboWithSuccess:(PPHttpRequestSuccess)success
                  Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
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
    [self setHeaderToken];
    [PPNetworkHelper GET:URL_ComboDetail parameters:@{@"combid":comboid,@"areaid":@"1",@"lng":lng,@"lat":lat} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getCombTagsWithSuccess:(PPHttpRequestSuccess)success
                        Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper GET:URL_ComboTags parameters:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getCombsWithTagid:(NSString *)tagid
                     page:(NSString *)page
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    NSDictionary *dic = @{@"tagid":tagid};
    [PPNetworkHelper GET:URL_Combos parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)postOrderWithDic:(NSDictionary *)dic
                   Success:(PPHttpRequestSuccess)success
                    Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper POST:URL_Order parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getMemberAddressSuccess:(PPHttpRequestSuccess)success
                         Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper GET:URL_Member_address parameters:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)putMemberAddressWithDic:(NSDictionary *)dic
                        Success:(PPHttpRequestSuccess)success
                         Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper PUT:URL_Member_address parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)postMemberAddressWithDic:(NSDictionary *)dic Success:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper POST:URL_Member_address parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)deleteMemeberAddressWithDic:(NSDictionary *)dic Success:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper DELETE:URL_Member_address parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getMemberInfoSuccess:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
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
    [self setHeaderToken];
    [PPNetworkHelper PUT:URL_Member_info parameters:dic data:data responseCache:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)postMemberInfoWithDic:(NSDictionary *)dic data:(NSData *)data Success:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper POST:URL_Member_info parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)deleteMemeberInfoWithDic:(NSDictionary *)dic Success:(PPHttpRequestSuccess)success Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    [PPNetworkHelper DELETE:URL_Member_info parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getPostcostWithAddressid:(NSString *)addressid
                         orderNo:(NSString *)orderNo
                         Success:(PPHttpRequestSuccess)success
                          Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    NSDictionary *dic = @{@"addressid":addressid, @"order_no":orderNo};
    [PPNetworkHelper GET:URL_Postcost parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)takeorderWithOrderno:(NSString *)order_no
                    couponid:(NSString *)couponid
                     remarks:(NSArray *)remarks
                   addressid:(NSString *)addressid
                     Success:(PPHttpRequestSuccess)success
                      Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    NSMutableDictionary *dic = [@{@"order_no":order_no, @"couponid":couponid, @"addressid":addressid} mutableCopy];
    [dic setValue:remarks forKey:@"remarks"];
    [PPNetworkHelper POST:URL_Member_takeorder parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getorderWithOrderNo:(NSString *)order_no
                    Success:(PPHttpRequestSuccess)success
                     Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    NSDictionary *dic = @{ @"order_no":order_no};
    [PPNetworkHelper GET:URL_Member_order parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getOrdersWithPage:(NSString *)page
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    NSDictionary *dic = @{ @"page":page};
    [PPNetworkHelper GET:URL_Member_orders parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)cancelorderWithOrderNO:(NSString *)orderno
                       Success:(PPHttpRequestSuccess)success
                        Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    NSDictionary *dic = @{@"order_no":orderno};
    [PPNetworkHelper POST:URL_Member_cancelorder parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)payWithPaytype:(NSString *)type
               Orderno:(NSString *)order_no
               Success:(PPHttpRequestSuccess)success
                Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    NSDictionary *dic = @{@"order_no":order_no, @"paytype":type};
    [PPNetworkHelper POST:URL_Member_pay parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getSearchWithKey:(NSString *)key
                    page:(NSString *)page
                 Success:(PPHttpRequestSuccess)success
                  Failed:(PPHttpRequestFailed)failed{
    [self setHeaderToken];
    NSString *lng = [JSYHLocationManager sharedManager].lng;
    NSString *lat = [JSYHLocationManager sharedManager].lat;
    NSMutableDictionary *dic = [@{ @"keyword":key, @"page":page} mutableCopy];
    [dic setValue:lng forKey:@"lng"];
    [dic setValue:lat forKey:@"lat"];
    [PPNetworkHelper GET:URL_Search parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)postFeedback:(NSString *)feedback
          imageArray:(NSArray *)imageArray
      imageNameArray:(NSArray *)imageNameArray
             Success:(PPHttpRequestSuccess)success
              Failed:(PPHttpRequestFailed)failed {
    [self setHeaderToken];
    NSDictionary *dic = @{@"content":feedback};
//    [PPNetworkHelper POST:URL_Feedback parameters:dic success:^(id responseObject) {
//        success(responseObject);
//    } failure:^(NSError *error) {
//        failed(error);
//    }];
    
    [PPNetworkHelper uploadImagesWithURL:URL_Feedback parameters:dic name:@"data.png" images:imageArray fileNames:imageNameArray imageScale:0.8 imageType:@"png" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}

- (void)getCouponWithPage:(NSString *)page
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed {

    [self setHeaderToken];
    NSMutableDictionary *dic = [@{ @"page":page} mutableCopy];
    [PPNetworkHelper GET:URL_coupon parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}


@end
