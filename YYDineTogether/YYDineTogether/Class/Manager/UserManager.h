//
//  UserManager.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/28.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSYHCouponModel;
@interface UserManager : NSObject

@property (strong, nonatomic) JSYHCouponModel *couponModel;

@property (assign, nonatomic) NSUInteger timerinterval;//服务器时间与系统时间差值

+ (UserManager *)sharedManager;
@end
