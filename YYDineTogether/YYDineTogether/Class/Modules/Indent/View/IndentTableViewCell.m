//
//  IndentTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentTableViewCell.h"
#import "IndentCellTableViewCell.h"

@interface IndentTableViewCell ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IndentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"IndentCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentCellTableViewCell"];
}
- (IBAction)againAction:(id)sender {
    self.againblock();
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IndentCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentCellTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
