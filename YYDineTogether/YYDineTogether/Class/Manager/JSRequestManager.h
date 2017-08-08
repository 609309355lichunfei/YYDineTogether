//
//  JSRequestManager.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/7/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPNetworkHelper.h"

@interface JSRequestManager : NSObject
+ (JSRequestManager *)sharedManager;

- (void)loginWithUserName:(NSString *)userName
                  Passord:(NSString *)password
                  Success:(PPHttpRequestSuccess)success
                   Failed:(PPHttpRequestFailed)failed;

@end
