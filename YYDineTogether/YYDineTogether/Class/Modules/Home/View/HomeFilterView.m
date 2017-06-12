//
//  HomeFilterView.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeFilterView.h"

#import "HomeFilterRightTableViewCell.h"

@interface HomeFilterView ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation HomeFilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registUI];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self removeFromSuperview];
    }];
    [self.mainView addGestureRecognizer:tap];
}

- (void)registUI {
    self.leftTableView.delegate = self;
    self.rightTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.rightTableView.dataSource = self;
    [self.leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeFilterLeftTableViewCell"];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"HomeFilterRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeFilterRightTableViewCell"];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFilterLeftTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = @"快餐便当";
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else {
        HomeFilterRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFilterRightTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        
    } else {
        [_delegate homeFilterViewSelectedString:@"lalal"];
        [self removeFromSuperview];
    }
}

@end
