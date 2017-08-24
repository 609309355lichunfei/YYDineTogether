//
//  JSYHSharedView.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/18.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHSharedView.h"

@implementation JSYHSharedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}

@end
