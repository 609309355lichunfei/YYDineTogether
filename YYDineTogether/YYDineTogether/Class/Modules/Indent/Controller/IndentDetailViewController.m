//
//  IndentDetailViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentDetailViewController.h"
#import <MapKit/MapKit.h>
#import "ShoppingChartTableViewCell.h"

@interface IndentDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation IndentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingChartTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentDetailTableViewCell"];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    ShoppingChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentDetailTableViewCell" forIndexPath:indexPath];
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
