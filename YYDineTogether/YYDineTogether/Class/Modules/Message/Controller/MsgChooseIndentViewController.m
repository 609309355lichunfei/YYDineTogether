//
//  MsgChooseIndentViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/21.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "MsgChooseIndentViewController.h"
#import "MsgChooseIndentHeaderView.h"
#import "MsgChooseIndentTableViewCell.h"

@interface MsgChooseIndentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *completeBT;
@property (weak, nonatomic) IBOutlet UIButton *allChooseBT;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MsgChooseIndentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgChooseIndentHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MsgChooseIndentHeaderView"];
    [self registUI];
}

- (void)registUI {
    self.completeBT.layer.cornerRadius = 2;
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgChooseIndentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgChooseIndentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgChooseIndentHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MsgChooseIndentHeaderView"];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MsgChooseIndentHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MsgChooseIndentHeaderView"];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 103;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgChooseIndentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgChooseIndentTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
