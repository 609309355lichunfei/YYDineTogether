//
//  HomeActivityViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeActivityViewController.h"
#import "HomeShoppingCartView.h"
#import "JSYHSharedView.h"
#import "JSYHComboModel.h"
#import "JSYHDishModel.h"
#import "HomeDishTableViewCell.h"

@interface HomeActivityViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    CGFloat _mainScrollViewLastContentOffSetY;
    CGFloat _tableViewLastContentOffSetY;
}

@property (strong, nonatomic) HomeShoppingCartView *shoppingView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopCartBTBottom;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) JSYHComboModel *model;

@end

@implementation HomeActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)registUI {
    self.shoppingCartCountLabel.layer.cornerRadius = 9;
    if ([ShoppingCartManager sharedManager].shoppingCartDataArray.count == 0) {
        self.shoppingCartCountLabel.hidden = YES;
    } else {
        self.shoppingCartCountLabel.hidden = NO;
        self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].shoppingCartDataArray.count];
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:@"JSYHShoppingCartCountChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([ShoppingCartManager sharedManager].shoppingCartDataArray.count == 0) {
            self.shoppingCartCountLabel.hidden = YES;
        } else {
            self.shoppingCartCountLabel.hidden = NO;
            self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].shoppingCartDataArray.count];
        }
        
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeActivityTableViewCell"];
    [self getConnect];
}

- (void)getConnect {
    [[JSRequestManager sharedManager] getCombDetailWithComboid:_combId lng:@"0" lat:@"0" Success:^(id responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        NSDictionary *combDic = dataDic[@"comb"];
        self.model = [[JSYHComboModel alloc] init];
        self.model.combid = combDic[@"id"];
        [self.model setValuesForKeysWithDictionary:combDic];
        [self fillData];
    } Failed:^(NSError *error) {
        
    }];
}

- (void)fillData {
    self.infoLabel.text = self.model.info;
    for (NSInteger i = 0; i < self.model.imgs.count; i ++) {
        NSString *imgUrlStr = self.model.imgs[i];
        switch (i) {
            case 0:
                [self.firstImageView setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholder:nil];
                break;
            case 1:
                [self.secondImageView setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholder:nil];
                break;
            case 2:
                [self.thirdImageVIew setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholder:nil];
                break;
                
            default:
                break;
        }
    }
    self.dataArray = self.model.dishs;
    self.tableViewHeight.constant = 128 * self.dataArray.count;
    [self.tableView reloadData];
}

- (IBAction)shoppingCartAction:(id)sender {
//    if (_shoppingView == nil) {
//        self.shoppingView = [[[NSBundle mainBundle] loadNibNamed:@"HomeShoppingCartView" owner:self options:nil] lastObject];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//            [_shoppingView removeShoppingCartView];
//            _shoppingView = nil;
//        }];
//        [_shoppingView addGestureRecognizer:tap];
//        [_shoppingView showShoppingCartView];
//    } else {
//        [_shoppingView removeShoppingCartView];
//        _shoppingView = nil;
//    }
}
- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sharedAction:(id)sender {
    JSYHSharedView *sharedView = [[[NSBundle mainBundle] loadNibNamed:@"JSYHSharedView" owner:self options:nil] firstObject];
    sharedView.frame = kScreen_Bounds;
    [kAppWindow addSubview:sharedView];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeActivityTableViewCell" forIndexPath:indexPath];
//    cell.type = ViewControllerTypeTypeFood;
    JSYHDishModel *model = self.model.dishs[indexPath.row];
    cell.dishModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
