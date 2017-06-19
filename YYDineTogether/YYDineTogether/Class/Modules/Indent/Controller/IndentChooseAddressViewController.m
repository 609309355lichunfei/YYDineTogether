//
//  IndentChooseAddressViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentChooseAddressViewController.h"
#import "IndentChooseAddressTableViewCell.h"
#import "IndentEditAddressViewController.h"

@interface IndentChooseAddressViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IndentChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"IndentChooseAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentChooseAddressTableViewCell"];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseAction:(id)sender {
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IndentChooseAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentChooseAddressTableViewCell" forIndexPath:indexPath];
    MJWeakSelf;
    cell.editBlock = ^(){
        IndentEditAddressViewController *editVC = [[IndentEditAddressViewController alloc]init];
        [weakSelf.navigationController pushViewController:editVC animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
