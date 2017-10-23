//
//  JSYHMSShopViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/7.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHMSShopViewController.h"
#import "JSYHShopModel.h"
#import "JSYHTagModel.h"
#import "HomeTableViewCell.h"
#import "HomeStoreViewController.h"
#import "JSYHMSShopTagCollectionViewCell.h"

@interface JSYHMSShopViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSInteger _selectTagIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *tagCollectionView;

@property (strong, nonatomic) NSMutableArray *tagsArray;

@property (strong, nonatomic) NSMutableArray *tableViewArray;

@end

@implementation JSYHMSShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)registUI {
    [self.tagCollectionView registerNib:[UINib nibWithNibName:@"JSYHMSShopTagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JSYHMSShopCollectionViewCell"];
    
    [[JSRequestManager sharedManager] tagsWithSuccess:^(id responseObject) {
        NSArray *tagsDicArray = responseObject[@"data"][@"tags"];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSInteger i = 0 ; i < tagsDicArray.count; i ++) {
            NSDictionary *tagDic = tagsDicArray[i];
            JSYHTagModel *model = [[JSYHTagModel alloc] init];
            [model setValuesForKeysWithDictionary:tagDic];
            model.tagIndex = i + 1;
            [dataArray addObject:model];
        }
        self.tagsArray = dataArray;
        JSYHTagModel *model = [[JSYHTagModel alloc] init];
        model.name = @"全部";
        model.tagId = @0;
        model.tagIndex = 0;
        [self.tagsArray insertObject:model atIndex:0];
        [self.tagCollectionView reloadData];
        self.contentViewWidth.constant = KScreenWidth * self.tagsArray.count;
        JSYHTagModel *tagModel = self.tagsArray.firstObject;
        [self registTableViewWithTag:tagModel];
    } Failed:^(NSError *error) {
        
    }];
}

- (void)registTableViewWithTag:(JSYHTagModel *)tagModel {
    UITableView *tableView = [[UITableView alloc]  initWithFrame:CGRectMake(KScreenWidth * tagModel.tagIndex, 0, KScreenWidth, self.scrollView.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeClassificationTableViewCell"];
    tableView.tag = 10000 + tagModel.tagIndex;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tagModel.tableView = tableView;
    MJWeakSelf;
    __weak JSYHTagModel *weakTagModel = tagModel;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConnectShopWithDataloadType:DataLoadTypeNone TagModel:weakTagModel];
    }];
    tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getConnectShopWithDataloadType:DataLoadTypeMore TagModel:weakTagModel];
    }];
    [self.tableViewArray addObject:tableView];
    [self.scrollContentView addSubview:tableView];
    [tableView.mj_header beginRefreshing];
}

- (void)getConnectShopWithDataloadType:(DataLoadType)dataloadType TagModel:(JSYHTagModel *)tagModel {
    tagModel.pageIndex = dataloadType == DataLoadTypeNone ? 0 : tagModel.pageIndex + 1;
    [[JSRequestManager sharedManager] shopsWithPage:[NSString stringWithFormat:@"%ld",tagModel.pageIndex] lng:[JSYHLocationManager sharedManager].lng lat:[JSYHLocationManager sharedManager].lat tagid:[tagModel.tagId stringValue] Success:^(id responseObject) {
        
        
        UITableView *tableView = tagModel.tableView;
        NSMutableArray *dataArray = tagModel.dataArray;
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *shopsArray = dataDic[@"shops"];
        if (dataloadType == DataLoadTypeNone) {
            [tableView.mj_header endRefreshing];
            [dataArray removeAllObjects];
        } else {
            [tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *shopDic in shopsArray) {
            JSYHShopModel *model = [[JSYHShopModel alloc] init];
            [model setValuesForKeysWithDictionary:shopDic];
            [model updateHeightWithActivity];
            [dataArray addObject:model];
        }
        tableView.mj_footer.hidden = shopsArray.count < 20 ? YES : NO;
        [tableView reloadData];
    } Failed:^(NSError *error) {
        UITableView *tableView = tagModel.tableView;
        if (dataloadType == DataLoadTypeNone) {
            [tableView.mj_header endRefreshing];
        } else {
            [tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger tagIndex = tableView.tag - 10000;
    JSYHTagModel *tagModel = _tagsArray[tagIndex];
    NSMutableArray *dataArray = tagModel.dataArray;
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tagIndex = tableView.tag - 10000;
    JSYHTagModel *tagModel = _tagsArray[tagIndex];
    NSMutableArray *dataArray = tagModel.dataArray;
    JSYHShopModel *model = dataArray[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeClassificationTableViewCell" forIndexPath:indexPath];
    NSInteger tagIndex = tableView.tag - 10000;
    JSYHTagModel *tagModel = _tagsArray[tagIndex];
    NSMutableArray *dataArray = tagModel.dataArray;
    JSYHShopModel *model = dataArray[indexPath.row];
    cell.shopModel = model;
    cell.activityBlock = ^(){
//        [tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:(UITableViewRowAnimationNone)];
        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:(UITableViewRowAnimationNone)];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeStoreViewController *storeVC = [[HomeStoreViewController alloc] init];
    NSInteger tagIndex = tableView.tag - 10000;
    JSYHTagModel *tagModel = _tagsArray[tagIndex];
    NSMutableArray *dataArray = tagModel.dataArray;
    JSYHShopModel *model = dataArray[indexPath.row];
    storeVC.shopid = [model.shopid stringValue];
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSYHTagModel *model = self.tagsArray[indexPath.row];
    NSString *name = model.name;
    CGFloat width = [name widthForFont:[UIFont systemFontOfSize:16]];
    return CGSizeMake(width + 16, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSYHMSShopTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSYHMSShopCollectionViewCell" forIndexPath:indexPath];
    JSYHTagModel *model = self.tagsArray[indexPath.row];
    cell.tagModel = model;
    cell.bottomView.hidden = indexPath.row == _selectTagIndex ? NO : YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * indexPath.row, 0) animated:YES];
    _selectTagIndex = indexPath.row;
    [self.tagCollectionView reloadData];
    [self.tagCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectTagIndex inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
    JSYHTagModel *tagModel = self.tagsArray[_selectTagIndex];
    if (tagModel.tableView == nil) {
        [self registTableViewWithTag:tagModel];
    }
}

- (NSMutableArray *)tagsArray {
    if (_tagsArray == nil) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x / self.scrollView.width;
        _selectTagIndex = index;
        [self.tagCollectionView reloadData];
        [self.tagCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
        JSYHTagModel *tagModel = self.tagsArray[index];
        if (tagModel.tableView == nil) {
            [self registTableViewWithTag:tagModel];
        }
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
