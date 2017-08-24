//
//  JSYHHomeStoreActivityViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/18.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHHomeStoreActivityViewController.h"
#import "HomeTableViewCell.h"
#import "JSYHStoreActivityHeaderTableViewCell.h"

@interface JSYHHomeStoreActivityViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JSYHHomeStoreActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHStoreActivityHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHStoreActivityHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoreActivitFoodTableViewCell"];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 230;
    }
    return 128;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JSYHStoreActivityHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHStoreActivityHeaderTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreActivitFoodTableViewCell" forIndexPath:indexPath];
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
