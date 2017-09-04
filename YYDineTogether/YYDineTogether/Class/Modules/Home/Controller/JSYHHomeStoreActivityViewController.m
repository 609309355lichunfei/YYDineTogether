//
//  JSYHHomeStoreActivityViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/18.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHHomeStoreActivityViewController.h"
#import "HomeTableViewCell.h"
#import "HomeDishTableViewCell.h"
#import "JSYHComboTableViewCell.h"
#import "JSYHStoreActivityHeaderTableViewCell.h"
#import "JSYHShopModel.h"
#import "JSYHDishModel.h"
#import "JSYHComboModel.h"

@interface JSYHHomeStoreActivityViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger _pageIndex;
    NSInteger _typeIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation JSYHHomeStoreActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self registUI];
}

- (void)registUI {
    _typeIndex = [_type integerValue];
    self.shoppingCartCountLabel.layer.cornerRadius = 9;
    if ([ShoppingCartManager sharedManager].count == 0) {
        self.shoppingCartCountLabel.hidden = YES;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
    } else {
        self.shoppingCartCountLabel.hidden = NO;
        self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].count];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:@"JSYHShoppingCartCountChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([ShoppingCartManager sharedManager].count == 0) {
            self.shoppingCartCountLabel.hidden = YES;
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
        } else {
            self.shoppingCartCountLabel.hidden = NO;
            self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].count];
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
        }
        
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHStoreActivityHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHStoreActivityHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StoreActivitTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"DishActivityTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHComboTableViewCell" bundle:nil] forCellReuseIdentifier:@"ComboActivityTableViewCell"];
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConnectWith:DataLoadTypeNone];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getConnectWith:DataLoadTypeMore];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getConnectWith:(DataLoadType)dataloadType {
    _pageIndex = dataloadType == DataLoadTypeNone ? 0 : _pageIndex + 1;
    
    [[JSRequestManager sharedManager] getBannerWithPage:[NSString stringWithFormat:@"%ld",_pageIndex] type:self.type lng:[JSYHLocationManager sharedManager].lng lat:[JSYHLocationManager sharedManager].lat Success:^(id responseObject) {
        
        
        if (dataloadType == DataLoadTypeNone) {
            [self.dataArray removeAllObjects];
        }
        
        NSDictionary *dataDic = responseObject[@"data"];
        if ([self.type isEqualToString:@"1"]) {
            NSArray *shopsDicArray = dataDic[@"shops"];
            self.tableView.mj_footer.hidden = shopsDicArray.count < 20 ? YES : NO;
            for (NSDictionary *shopDic in shopsDicArray) {
                JSYHShopModel *model = [[JSYHShopModel alloc] init];
                [model setValuesForKeysWithDictionary:shopDic];
                [model updateHeightWithActivity];
                [self.dataArray addObject:model];
            }
        } else if ([self.type isEqualToString:@"2"]) {
            NSArray *dishDicArray = dataDic[@"dishs"];
            self.tableView.mj_footer.hidden = dishDicArray.count < 20 ? YES : NO;
            for (NSDictionary *dishDic in dishDicArray) {
                JSYHDishModel *model = [[JSYHDishModel alloc] init];
                [model setValuesForKeysWithDictionary:dishDic];
                [[ShoppingCartManager sharedManager] updateCountWithModel:model];
                [self.dataArray addObject:model];
            }
        } else {
            NSArray *combDicArray = dataDic[@"combs"];
            self.tableView.mj_footer.hidden = combDicArray.count < 20 ? YES : NO;
            for (NSDictionary *combDic in combDicArray) {
                JSYHComboModel *model = [[JSYHComboModel alloc] init];
                [model setValuesForKeysWithDictionary:combDic];
                [[ShoppingCartManager sharedManager] updateComboCountWithModel:model];
                [self.dataArray addObject:model];
            }
        }
        if (dataloadType == DataLoadTypeNone) {
            
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        
    }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shoppingcartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 230;
    } else {
        switch (_typeIndex) {
            case 1:
            {
                JSYHShopModel *model = self.dataArray[indexPath.row];
                return model.height;
            }
                break;
            case 2:
            {
                return 100;
            }
                
            default:
            {
                return 50;
            }
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JSYHStoreActivityHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHStoreActivityHeaderTableViewCell" forIndexPath:indexPath];
        return cell;
    } else {
        switch (_typeIndex) {
            case 1:
            {
                HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreActivitTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                JSYHShopModel *model = self.dataArray[indexPath.row];
                cell.shopModel = model;
                return cell;
            }
                break;
            case 2:
            {
                HomeDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DishActivityTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                JSYHDishModel *model = self.dataArray[indexPath.row];
                cell.dishModel = model;
                return cell;
            }
                break;
                
            default:
            {
                JSYHComboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComboActivityTableViewCell" forIndexPath:indexPath];
                JSYHComboModel *model = self.dataArray[indexPath.row];
                cell.combModel = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
