//
//  IndentConfirmViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentConfirmViewController.h"
#import "ShoppingChartTableViewCell.h"
#import "IndentChooseAddressViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IndentConfirmViewController ()<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IndentConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingChartTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentConfirmTableViewCell"];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addressAction:(id)sender {
    IndentChooseAddressViewController *chooseAddressVC = [[IndentChooseAddressViewController alloc]init];
    [self.navigationController pushViewController:chooseAddressVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentConfirmTableViewCell" forIndexPath:indexPath];
    cell.isShoppingCart = NO;
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
