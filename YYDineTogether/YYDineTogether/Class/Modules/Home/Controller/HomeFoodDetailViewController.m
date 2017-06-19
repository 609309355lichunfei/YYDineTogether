//
//  HomeFoodDetailViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeFoodDetailViewController.h"

@interface HomeFoodDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractButton;
@property (strong, nonatomic) HomeShoppingCartView *shoppingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingCartBTBottom;

@end

@implementation HomeFoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shoppingCartAction:(id)sender {
    if (_shoppingView == nil) {
        self.shoppingView = [[[NSBundle mainBundle] loadNibNamed:@"HomeShoppingCartView" owner:self options:nil] lastObject];
        [_shoppingView showShoppingCartView];
        self.shoppingCartBTBottom.constant = 0;
    } else {
        [_shoppingView removeShoppingCartView];
        self.shoppingCartBTBottom.constant = 25;
        _shoppingView = nil;
    }
}
- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

- (IBAction)addAction:(id)sender {
    if (_subtractButton.isHidden) {
        _numberLabel.hidden = NO;
        _numberLabel.text = @"1";
        _subtractButton.hidden = NO;
    } else {
        _numberLabel.text =  [NSString stringWithFormat:@"%ld",[_numberLabel.text integerValue] + 1];
    }
}
- (IBAction)subtractAction:(id)sender {
    if ([_numberLabel.text isEqualToString:@"1"]) {
        _numberLabel.text = @"0";
        _subtractButton.hidden = YES;
        _numberLabel.hidden = YES;
    } else {
        _numberLabel.text =  [NSString stringWithFormat:@"%ld",[_numberLabel.text integerValue] + 1];
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
