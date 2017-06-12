//
//  BorderLineButton.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/8.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "BorderLineButton.h"

@implementation BorderLineButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self drawUI];
}

- (void)drawUI
{
    self.layer.borderColor = RGB(226, 226, 226).CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 13;
    self.clipsToBounds = YES;
}

@end
