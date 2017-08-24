//
//  MsgEditViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/17.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "MsgEditViewController.h"
#import "HomeDishTableViewCell.h"
#import "MsgChooseIndentViewController.h"

@interface MsgEditViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>{
    CGFloat _mainScrollViewLastContentOffSetY;
    CGFloat _tableViewLastContentOffSetY;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation MsgEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgEditTableViewCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addIndentAction:(id)sender {
    MsgChooseIndentViewController *chooseIndentVC = [[MsgChooseIndentViewController alloc] init];
    [self.navigationController pushViewController:chooseIndentVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgEditTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
