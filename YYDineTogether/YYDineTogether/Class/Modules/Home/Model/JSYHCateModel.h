//
//  JSYHCateModel.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/23.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSYHCateModel : NSObject
@property (strong, nonatomic) NSNumber *cateid;
@property (strong, nonatomic) NSString *catename;
@property (strong, nonatomic) NSMutableArray *dishs;

#pragma mark - 自加属性

@property (assign, nonatomic) BOOL selected;
@end
