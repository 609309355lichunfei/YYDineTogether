//
//  JSYHComboModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/24.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSYHComboModel : NSObject
@property (strong, nonatomic) NSNumber *combid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSNumber *strong;
@property (strong, nonatomic) NSNumber *originalprice;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSMutableArray *dishs;
@property (strong, nonatomic) NSMutableArray *imgs;
@end
