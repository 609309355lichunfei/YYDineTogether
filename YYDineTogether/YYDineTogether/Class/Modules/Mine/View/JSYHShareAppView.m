//
//  JSYHShareAppView.m
//  YYDineTogether
//
//  Created by 吴頔 on 2017/11/23.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHShareAppView.h"

@interface JSYHShareAppView(){
    
    CGRect _myframe;
    
}

@end

@implementation JSYHShareAppView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nibs=[[NSBundle mainBundle]loadNibNamed:@"JSYHShareAppView" owner:nil options:nil];
        self=[nibs objectAtIndex:0];
        
        _myframe = frame;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myframe;
}
- (IBAction)friendsAction:(id)sender {
    if (_friendsBlock) {
        _friendsBlock();
    }
}

- (IBAction)wxAction:(id)sender {
    if (_wxBlock) {
        _wxBlock();
    }
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

@end
