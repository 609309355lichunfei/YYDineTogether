//
//  JSYHShopModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/22.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSYHShopModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger star;
@property (assign, nonatomic) NSInteger salescount;
@property (strong, nonatomic) NSArray *activites;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSNumber *shopid;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *notice_info;

@property (strong, nonatomic) NSMutableArray *cates;

#pragma mark 自加属性
@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGFloat shopCartHeight;

@property (strong, nonatomic) NSMutableArray *dishs;

- (void)updateHeightWithActivity;

- (void)updateHeightWithDish;

@end
