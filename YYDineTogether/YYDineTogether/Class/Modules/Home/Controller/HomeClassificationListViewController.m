//
//  HomeClassificationListViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/11.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeClassificationListViewController.h"
#import "HomeTableViewCell.h"
#import "HomeFilterView.h"
#import "HomeStoreViewController.h"

@interface HomeClassificationListViewController ()<UITableViewDelegate, UITableViewDataSource, HomeFilterViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic)  HomeFilterView *filterView;


@end

@implementation HomeClassificationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeClassificationTableViewCell"];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchAction:(id)sender {
    
}

- (IBAction)filterAction:(id)sender {
    if (_filterView.superview == _mainView) {
        [self.filterView removeFromSuperview];
        return;
    }
    self.filterView = [[[NSBundle mainBundle] loadNibNamed:@"HomeFilterView" owner:self options:nil] lastObject];
    self.filterView.frame = self.mainView.bounds;
    self.filterView.delegate = self;
    [self.mainView addSubview:self.filterView];
}

- (IBAction)changeTitleTapAction:(id)sender {
    if ([self.myTitleLabel.text isEqualToString:@"美食店"]) {
        self.myTitleLabel.text = @"美味菜";
    } else {
        self.myTitleLabel.text = @"美食店";
    }
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeClassificationTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeStoreViewController *storeVC = [[HomeStoreViewController alloc] init];
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark - HomeFilterViewDelegate
- (void)homeFilterViewSelectedString:(NSString *)string {
    
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
