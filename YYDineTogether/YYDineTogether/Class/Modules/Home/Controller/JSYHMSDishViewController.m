//
//  JSYHMSDishViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/7.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHMSDishViewController.h"
#import "JSYHDishModel.h"
#import "HomeDishTableViewCell.h"
#import "HomeFoodDetailViewController.h"

@interface JSYHMSDishViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger _dishpageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dishArray;
@end

@implementation JSYHMSDishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"JSZPAPP_Dish"]) {
        UIImageView *guideImageView = [[UIImageView alloc] initWithFrame:kScreen_Bounds];
        [guideImageView setImage:[UIImage imageNamed:@"Home_dishGuide"]];
        guideImageView.contentMode = UIViewContentModeTopRight;
        guideImageView.userInteractionEnabled = YES;
        [kAppWindow addSubview:guideImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ] initWithActionBlock:^(id  _Nonnull sender) {
            [guideImageView removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"JSZPAPP_Dish"];
        }];
        [guideImageView addGestureRecognizer:tap];
    }
}

- (void)registUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDishTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeClassificationDishTableViewCell"];
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConnectWithDish:DataLoadTypeNone];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getConnectWithDish:DataLoadTypeMore];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getConnectWithDish:(DataLoadType)dataloadType {
    _dishpageIndex = dataloadType == DataLoadTypeNone ? 0 : _dishpageIndex + 1;
    [[JSRequestManager sharedManager] homepageDishWithPage:NSStringFormat(@"%ld",_dishpageIndex) lng:[JSYHLocationManager sharedManager].lng lat:[JSYHLocationManager sharedManager].lat Success:^(id responseObject) {
        
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *dishesArray = dataDic[@"dishs"];
        if (dishesArray.count < 20) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        if (dataloadType == DataLoadTypeNone) {
            [self.dishArray removeAllObjects];
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *dishDic in dishesArray) {
            JSYHDishModel *model = [[JSYHDishModel alloc] init];
            [model setValuesForKeysWithDictionary:dishDic];
            [[ShoppingCartManager sharedManager] updateCountWithModel:model];
            [self.dishArray addObject:model];
        }
        [self.tableView reloadData];
        
    } Failed:^(NSError *error) {
        if (dataloadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - UITableviewDelegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dishArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeClassificationDishTableViewCell" forIndexPath:indexPath];
    JSYHDishModel *dishModel = self.dishArray[indexPath.row];
    cell.dishModel = dishModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFoodDetailViewController *controller = [[HomeFoodDetailViewController alloc]init];
    JSYHDishModel *model = self.dishArray[indexPath.row];
    controller.dishModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSMutableArray *)dishArray {
    if (_dishArray == nil) {
        _dishArray = [NSMutableArray array];
    }
    return _dishArray;
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
