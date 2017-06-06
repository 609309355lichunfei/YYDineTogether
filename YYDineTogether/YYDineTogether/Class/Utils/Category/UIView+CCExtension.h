//
//  UIView+CCExtension.h
//  Circle
//
//  Created by 韩珍 on 15/7/15.
//  Copyright (c) 2015年 zhongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CCExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


/**
 * 指定大小的圆角处理
 */
- (void)cornerRadius:(CGFloat)radius;


/**
 *  指定大小圆角，且带border
 */
- (void)cornerRadius:(CGFloat)radius borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  添加border
 */
- (void)borderWithColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  对UIView的四个角进行选择性的圆角处理
 */
- (void)makeRoundedCorner:(UIRectCorner)byRoundingCorners cornerRadius:(CGSize)cornerRadius;

- (UIView *)findFirstResponder;

- (UIImage *)screenShot;

@end
