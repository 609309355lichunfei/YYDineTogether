//
//  JSYHUpdateAlertView.m
//  YYDineTogether
//
//  Created by 吴頔 on 2017/10/17.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHUpdateAlertView.h"

@implementation JSYHUpdateAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)updateAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ai-yu/id1287825110?mt=8"]];
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

@end
