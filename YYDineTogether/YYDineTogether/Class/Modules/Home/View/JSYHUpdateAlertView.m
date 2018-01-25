//
//  JSYHUpdateAlertView.m
//  YYDineTogether
//
//  Created by 吴頔 on 2017/10/17.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHUpdateAlertView.h"

@interface JSYHUpdateAlertView(){
    CGRect _myframe;
}



@end

@implementation JSYHUpdateAlertView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame= _myframe;//关键点在这里
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nibs=[[NSBundle mainBundle]loadNibNamed:@"JSYHUpdateAlertView" owner:nil options:nil];
        self=[nibs objectAtIndex:0];
        
        _myframe = frame;
    }
    return self;
}



- (IBAction)updateAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ai-yu/id1287825110?mt=8"]];
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

@end
