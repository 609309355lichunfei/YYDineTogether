//
//  HomeShoppingCartView.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/6.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeShoppingCartView.h"
#import "HomeShoppingCartTableViewCell.h"

@interface HomeShoppingCartView ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation HomeShoppingCartView

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
}

- (void)registUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeShoppingCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeShoppingCartTableViewCell"];
}

- (void)showShoppingCartView {
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 40);
    [kAppWindow addSubview:self];
    [UIView animateWithDuration:10 animations:^{
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeShoppingCartView {
    [UIView animateWithDuration:20 animations:^{
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeShoppingCartTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
