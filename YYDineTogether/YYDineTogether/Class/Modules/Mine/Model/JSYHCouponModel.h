//
//  JSYHCouponModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/4.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSYHCouponModel : NSObject
@property (assign, nonatomic) NSInteger starttime;
@property (assign, nonatomic) NSInteger endtime;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSNumber *coupon_id;
@property (strong, nonatomic) NSNumber *value;
@property (assign, nonatomic) NSInteger is_first;
@property (assign, nonatomic) NSInteger overdue;
@property (strong, nonatomic) NSNumber *full;

#pragma mark - 自加属性

@property (assign, nonatomic) BOOL canUse;

@end
