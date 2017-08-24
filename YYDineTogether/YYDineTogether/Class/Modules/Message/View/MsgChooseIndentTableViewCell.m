//
//  MsgChooseIndentTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/21.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "MsgChooseIndentTableViewCell.h"
#import "MsgChooseIdentCellTableViewCell.h"

@interface MsgChooseIndentTableViewCell ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MsgChooseIndentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgChooseIdentCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgChooseIdentCellTableViewCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgChooseIdentCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgChooseIdentCellTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
