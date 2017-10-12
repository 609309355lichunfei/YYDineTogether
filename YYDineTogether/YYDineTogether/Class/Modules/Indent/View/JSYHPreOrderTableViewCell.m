//
//  JSYHPreOrderTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/29.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHPreOrderTableViewCell.h"
#import "JSYHPreOrderDishTableViewCell.h"
#import "JSYHShopModel.h"
#import "JSYHDishModel.h"
#import "JSYHEditRemarksViewController.h"

@interface JSYHPreOrderTableViewCell ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *dishsTableView;


@property (strong, nonatomic) NSMutableArray *dataArray;

@end


@implementation JSYHPreOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI {
    self.dishsTableView.delegate = self;
    self.dishsTableView.dataSource = self;
    [self.dishsTableView registerNib:[UINib nibWithNibName:@"JSYHPreOrderDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHPreOrderDishTableViewCell"];
    MJWeakSelf;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        JSYHEditRemarksViewController *remarksVC = [[JSYHEditRemarksViewController alloc] init];
        remarksVC.shopModel = weakSelf.shopModel;
        [weakSelf.viewController.navigationController pushViewController:remarksVC animated:YES];
    }];
    [self.remarkLabel addGestureRecognizer:tap];
}

- (IBAction)shopDetailTapAction:(id)sender {
    
}

- (IBAction)remarkTapAction:(id)sender {
    
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHDishModel *dishModel = self.dataArray[indexPath.row];
    JSYHPreOrderDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHPreOrderDishTableViewCell" forIndexPath:indexPath];
    cell.dishModel = dishModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setShopModel:(JSYHShopModel *)shopModel {
    _shopModel = shopModel;
    [self.logoImageView setImageWithURL:[NSURL URLWithString:_shopModel.logo] placeholder:nil];
    self.shopNameLabel.text = _shopModel.name;
    if (_shopModel.remarks == nil || _shopModel.remarks.length == 0) {
        self.remarkLabel.text = @"用户无备注说明";
    } else {
        self.remarkLabel.text = _shopModel.remarks;
    }
    self.dataArray = _shopModel.dishs;
    [self.dishsTableView reloadData];
}

- (IBAction)phoneAction:(id)sender {
    NSString *phone = self.shopModel.phone;
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"是否要联系商户?" message:phone preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *allString = [NSString stringWithFormat:@"tel:%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alerVC addAction:action];
    [alerVC addAction:cancelAction];
    [self.viewController presentViewController:alerVC animated:YES completion:nil];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
