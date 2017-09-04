//
//  UserManager.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//


#import "UserManager.h"

@interface UserManager ()

@end

static UserManager *_userManager;
@implementation UserManager
+ (UserManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userManager = [[UserManager alloc]init];
    });
    return _userManager;
}

@end
