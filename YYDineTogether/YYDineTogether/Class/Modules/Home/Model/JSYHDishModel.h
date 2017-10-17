//
//  JSYHDishModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/22.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSYHDishModel : NSObject <NSCopying>

@property (assign, nonatomic) NSInteger cateid;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *shoplogo;
@property (strong, nonatomic) NSNumber *discountprice;
@property (strong, nonatomic) NSNumber *totalprice;
@property (strong, nonatomic) NSString *distance;
@property (assign, nonatomic) NSInteger star;
@property (assign, nonatomic) int salescount;
@property (strong, nonatomic) NSString *info;
@property (assign, nonatomic) NSInteger shopid;
@property (strong, nonatomic) NSString *shopname;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSNumber *dishid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *dishname;
@property (strong, nonatomic) NSString *combid;
@property (strong, nonatomic) NSString *iscomb;
@property (assign, nonatomic) NSInteger count;
#pragma mark 自加属性
@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) NSInteger shopcartCount;

@end
