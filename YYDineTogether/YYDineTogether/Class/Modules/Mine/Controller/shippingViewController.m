//
//  shippingViewController.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "shippingViewController.h"
#import "shippTableViewCell.h"
#import "IndentEditAddressViewController.h"
@interface shippingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation shippingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"shippTableViewCell" bundle:nil] forCellReuseIdentifier:@"shippTableViewCell"];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    shippTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shippTableViewCell" forIndexPath:indexPath];
    MJWeakSelf;
    cell.editBlock = ^(){
        IndentEditAddressViewController *editAddressVC = [[IndentEditAddressViewController alloc] init];
        [weakSelf.navigationController pushViewController:editAddressVC animated:YES];
    };
    cell.removeBlock = ^(){
        
    };
    
    return cell;
}
//编辑
- (void)CompileWithBt {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
