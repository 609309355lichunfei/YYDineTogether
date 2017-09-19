//
//  HomeComboRecomendViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/6.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeComboRecomendViewController.h"
#import "HomeTableViewCell.h"
#import "JSYHCombListTableViewCell.h"
#import "JSYHComboModel.h"
#import "JSYHCombListHeaderTableViewCell.h"

@interface HomeComboRecomendViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) HomeShoppingCartView *shoppingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingCartBTBottom;
@property (weak, nonatomic) IBOutlet UIView *shoppingCartView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;


@end

@implementation HomeComboRecomendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHCombListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHCombListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHCombListHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHCombListHeaderTableViewCell"];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

- (IBAction)shoppingCartAction:(id)sender {
    if (_shoppingView == nil) {
        self.shoppingView = [[[NSBundle mainBundle] loadNibNamed:@"HomeShoppingCartView" owner:self options:nil] lastObject];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [_shoppingView removeShoppingCartView];
            _shoppingView = nil;
        }];
        [_shoppingView addGestureRecognizer:tap];
        [_shoppingView showShoppingCartView];
    } else {
        [_shoppingView removeShoppingCartView];
        _shoppingView = nil;
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return KScreenWidth * 188 / 750 + 60;
    }
    return 220;
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
        JSYHCombListHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHCombListHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    JSYHCombListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHCombListTableViewCell" forIndexPath:indexPath];
//    JSYHComboModel *combModel = self.dataArray[indexPath.row];
//    cell.combModel = combModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
