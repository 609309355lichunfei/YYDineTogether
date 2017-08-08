//
//  JSRequestManager.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/7/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSRequestManager.h"



@interface JSRequestManager ()

@end

@implementation JSRequestManager
+ (JSRequestManager *)sharedManager {
    static JSRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JSRequestManager alloc] init];
    });
    return manager;
}

- (void)loginWithUserName:(NSString *)userName
                  Passord:(NSString *)password
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed {
    NSDictionary *dic = @{@"username" : userName, @"password" : password};
    [PPNetworkHelper POST:URL_Login parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failed(error);
    }];
}




@end
