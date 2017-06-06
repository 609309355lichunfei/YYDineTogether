//
//  HomeSearchView.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeSearchView.h"
#import <YYTextView.h>
#import <NSAttributedString+YYText.h>

@interface HomeSearchView ()<UITableViewDataSource, UITableViewDelegate, YYTextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *recommendView;//热门推荐标签View
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) YYTextView *textView;

@end

@implementation HomeSearchView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registUI];
}

- (void)registUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeSearchTableViewCell"];
    
    self.textView = [YYTextView new];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.userInteractionEnabled = NO;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _textView.frame = _recommendView.bounds;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _textView.allowsCopyAttributedString = YES;
    _textView.allowsPasteAttributedString = YES;
    _textView.delegate = self;
    _textView.scrollIndicatorInsets = _textView.contentInset;
    [_recommendView addSubview:_textView];
}

- (void)createTagLabelWithTagsArray:(NSArray *)tagsArray {
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    for (int i = 0; i < tagsArray.count; i++) {
        NSString *tag = tagsArray[i];
        UIColor *tagStrokeColor = RGB(190, 190, 190);
        UIColor *tagFillColor = RGB(243, 243, 243);
        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
        [tagText insertString:@"   " atIndex:0];
        [tagText appendString:@"   "];
        tagText.font = font;
        tagText.color = RGB(190, 190, 190);
        [tagText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.rangeOfAll];
        
        YYTextBorder *border = [YYTextBorder new];
        border.strokeWidth = 1.5;
        border.strokeColor = tagStrokeColor;
        border.fillColor = tagFillColor;
        border.cornerRadius = 5; // a huge value
        border.lineJoin = kCGLineJoinBevel;
        
        border.insets = UIEdgeInsetsMake(-2, -5.5, -2, -8);
        [tagText setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
        
        [text appendAttributedString:tagText];
    }
    text.lineSpacing = 10;
    text.lineBreakMode = NSLineBreakByWordWrapping;
    
    [text appendString:@"\n"];
    _textView.attributedText = text;
    _textView.selectedRange = NSMakeRange(text.length, 0);
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSearchTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @"推荐菜品";
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
