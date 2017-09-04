
//
//  HomeComboViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/12.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeComboViewController.h"
#import "HomeActivityViewController.h"
#import "JSYHComboModel.h"
#import "SDCycleScrollView.h"

@interface HomeComboViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *comboView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (strong, nonatomic) JSYHComboModel *firstComb;
@property (strong, nonatomic) JSYHComboModel *secondComb;
@property (strong, nonatomic) JSYHComboModel *thirdComb;
@property (strong, nonatomic) NSMutableArray *combsArray;

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@end

@implementation HomeComboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registUI];
}

- (void)registUI {
    [self getConnect];
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.comboView.bounds imageURLStringsGroup:@[]];
    self.cycleScrollView.delegate = self;
    [self.comboView addSubview:self.cycleScrollView];
}

- (void)getConnect{
    [MBProgressHUD showMessage:@"加载中..."];
    [[JSRequestManager sharedManager] comboWithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *combs = dataDic[@"combs"];
        for (NSInteger i = 0; i < combs.count; i ++) {
            NSDictionary *combDic = combs[i];
            JSYHComboModel *model = [[JSYHComboModel alloc] init];
            [model setValuesForKeysWithDictionary:combDic];
            switch (i) {
                case 0:
                    self.firstComb = model;
                    break;
                case 1:
                    self.secondComb = model;
                    break;
                case 2:
                    self.thirdComb = model;
                    break;
                default:
                    [self.combsArray addObject:model];
                    break;
            }
        }
        [self fillData];
    } Failed:^(NSError *error) {
        
    }];
}

- (void)fillData {
    [self.firstImageView setImageWithURL:[NSURL URLWithString:self.firstComb.logo] placeholder:nil];
    [self.secondImageView setImageWithURL:[NSURL URLWithString:self.secondComb.logo] placeholder:nil];
    [self.thirdImageView setImageWithURL:[NSURL URLWithString:self.thirdComb.logo] placeholder:nil];
    NSMutableArray *combUrlArray = [NSMutableArray array];
    for (JSYHComboModel *model in self.combsArray) {
        NSString *logo = model.logo;
        [combUrlArray addObject:logo];
    }
    self.cycleScrollView.imageURLStringsGroup = combUrlArray;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)firstCombAction:(id)sender {
    HomeActivityViewController *vc = [[HomeActivityViewController alloc] init];
    vc.combId = [_firstComb.combid stringValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)secondCombTap:(id)sender {
    HomeActivityViewController *vc = [[HomeActivityViewController alloc] init];
    vc.combId = [_secondComb.combid stringValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)thirdCombTap:(id)sender {
    HomeActivityViewController *vc = [[HomeActivityViewController alloc] init];
    vc.combId = [_thirdComb.combid stringValue];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - cycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    JSYHComboModel *model = self.combsArray[index];
    HomeActivityViewController *vc = [[HomeActivityViewController alloc] init];
    vc.combId = [model.combid stringValue];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)combsArray {
    if (_combsArray == nil) {
        _combsArray = [NSMutableArray array];
    }
    return _combsArray;
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
