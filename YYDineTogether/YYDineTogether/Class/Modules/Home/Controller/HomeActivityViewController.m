//
//  HomeActivityViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeActivityViewController.h"
#import "HomeShoppingCartView.h"
#import "HomeTableViewCell.h"

@interface HomeActivityViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    CGFloat _mainScrollViewLastContentOffSetY;
    CGFloat _tableViewLastContentOffSetY;
}

@property (strong, nonatomic) HomeShoppingCartView *shoppingView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeActivityTableViewCell"];
}
- (IBAction)shoppingCartAction:(id)sender {
    if (_shoppingView == nil) {
        self.shoppingView = [[[NSBundle mainBundle] loadNibNamed:@"HomeShoppingCartView" owner:self options:nil] lastObject];
        [_shoppingView showShoppingCartView];
    } else {
        [_shoppingView removeShoppingCartView];
        _shoppingView = nil;
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeActivityTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        if (scrollView.contentOffset.y > 120) {
            if (scrollView.contentOffset.y > _mainScrollViewLastContentOffSetY) {
                [scrollView setContentOffset:CGPointMake(0, 170) animated:NO];
                scrollView.scrollEnabled = NO;
                _tableView.scrollEnabled = YES;
                _tableView.bounces = YES;
            }
        }
        
        _mainScrollViewLastContentOffSetY = scrollView.contentOffset.y;
    }
    
    if (scrollView == _tableView) {
        if (scrollView.contentOffset.y < 10) {
            if (scrollView.contentOffset.y < _tableViewLastContentOffSetY) {
                [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                scrollView.scrollEnabled = NO;
                _mainScrollView.scrollEnabled = YES;
                _mainScrollView.bounces = YES;
            }
        }
        _tableViewLastContentOffSetY = scrollView.contentOffset.y;
    }
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
