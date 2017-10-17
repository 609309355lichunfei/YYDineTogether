//
//  HomeSearchView.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeSearchView.h"
#import "HomSearchTableViewCell.h"
#import "JSYHSearchHeaderCollectionReusableView.h"
#import "JSSHSearchCollectionViewCell.h"
#import "HomeTableViewCell.h"
#import "HomeFoodDetailViewController.h"
#import "JSYHShopModel.h"
#import "JSYHDishModel.h"
#import "HomeStoreViewController.h"
#import "DB_Helper.h"

@interface HomeSearchView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>{
    NSInteger _pageindex;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *searchResultView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *hotKeywordArray;

@property (strong, nonatomic) NSMutableArray *keywordArray;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSString *keyword;


@end

@implementation HomeSearchView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registUI];
}

- (void)registUI {
//    self.textView = [YYTextView new];
//    _textView.backgroundColor = [UIColor clearColor];
//    _textView.userInteractionEnabled = YES;
//    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    _textView.frame = _recommendView.bounds;
//    _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    _textView.allowsCopyAttributedString = YES;
//    _textView.allowsPasteAttributedString = YES;
//    _textView.delegate = self;
//    _textView.scrollIndicatorInsets = _textView.contentInset;
//    [_recommendView addSubview:_textView];
    
    self.keywordArray = [[[DB_Helper defaultHelper] getKeywordArray] mutableCopy];
    self.hotKeywordArray = @[@"泡椒牛蛙",@"奶茶",@"农家小炒肉",@"干锅包菜",@"泡芙",@"大鸡排",@"重庆小面",@"皮蛋瘦肉粥",@"啤酒炸鸡",@"抹茶拿铁"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"JSSHSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JSSHSearchCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JSYHSearchHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JSYHSearchHeaderCollectionReusableView"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchViewTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomSearchTableViewCell"];
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConnectWithDataLoadType:DataLoadTypeNone];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getConnectWithDataLoadType:DataLoadTypeMore];
    }];
}

- (void)getConnectWithSearchKeyWord:(NSString *)keyword {
    self.keyword = keyword;
    if (![self.keywordArray containsObject:keyword]) {
        [self.keywordArray addObject:keyword];
        [[DB_Helper defaultHelper] updateSearchKeywordWithArray:self.keywordArray];
    }
    
    [self.collectionView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getConnectWithDataLoadType:(DataLoadType)dataLoadType {
    _pageindex = dataLoadType == DataLoadTypeNone ? 0 : _pageindex + 1;
    [[JSRequestManager sharedManager] getSearchWithKey:self.keyword page:[NSString stringWithFormat:@"%ld",_pageindex] Success:^(id responseObject) {
        if (dataLoadType == DataLoadTypeNone) {
            [self.dataArray removeAllObjects];
        }
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *shopDicArray = dataDic[@"shops"];
        self.tableView.mj_footer.hidden = shopDicArray.count < 20 ? YES : NO;
        for (NSDictionary *shopDic in shopDicArray) {
            JSYHShopModel *model = [[JSYHShopModel alloc] init];
            [model setValuesForKeysWithDictionary:shopDic];
            [model updateHeightWithSearchView];
            for (JSYHDishModel *dishModel in model.dishs) {
                dishModel.shopid = [model.shopid integerValue];
                dishModel.shoplogo = model.logo;
                dishModel.shopname = model.name;
                [[ShoppingCartManager sharedManager] updateCountWithModel:dishModel];
            }
            [self.dataArray addObject:model];
        }
        if (dataLoadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } Failed:^(NSError *error) {
        if (dataLoadType == DataLoadTypeNone) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return self.keywordArray.count;
    }
    return self.hotKeywordArray.count;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSString *keyword = self.keywordArray[indexPath.row];
        return CGSizeMake([keyword widthForFont:[UIFont systemFontOfSize:12]] + 16, 20);
    } else {
        NSString *keyword = self.hotKeywordArray[indexPath.row];
        return CGSizeMake([keyword widthForFont:[UIFont systemFontOfSize:12]] + 16, 20);
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.width, 50);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    JSYHSearchHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JSYHSearchHeaderCollectionReusableView" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        view.titleLabel.text = @"热门推荐";
        view.removeBT.hidden = YES;
    } else {
        view.titleLabel.text = @"历史搜索";
        view.removeBlock = ^(){
            [self.keywordArray removeAllObjects];
            [[DB_Helper defaultHelper] updateSearchKeywordWithArray:self.keywordArray];
            [self.collectionView reloadData];
        };
        view.removeBT.hidden = NO;
    }
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSSHSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSSHSearchCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 1) {
        cell.titleLabel.text = self.keywordArray[indexPath.row];
    } else {
        cell.titleLabel.text = self.hotKeywordArray[indexPath.row];
    }
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.didSelectBlock(self.keywordArray[indexPath.row]);
    } else {
        self.didSelectBlock(self.hotKeywordArray[indexPath.row]);
    }
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHShopModel *model = self.dataArray[indexPath.row];
    return model.searchHeigh;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomSearchTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JSYHShopModel *model = self.dataArray[indexPath.row];
    cell.shopModel = model;
    cell.activityBlock = ^{
        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:(UITableViewRowAnimationAutomatic)];
    };
//    cell.type = ViewControllerTypeTypeFood;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeStoreViewController *storeVC = [[HomeStoreViewController alloc] init];
    JSYHShopModel *model = self.dataArray[indexPath.row];
    storeVC.shopid = [model.shopid stringValue];
    [self.viewController.navigationController pushViewController:storeVC animated:YES];
}

- (void)setType:(SearchViewType)type {
    if (type == SearchViewTypeResult) {
        self.collectionView.hidden = YES;
        self.searchResultView.hidden = NO;
    } else {
        self.collectionView.hidden = NO;
        self.searchResultView.hidden = YES;
    }
}

#pragma mark -懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


//- (void)createTagLabelWithTagsArray:(NSArray *)tagsArray withTextView:(YYTextView *)textView{
//    NSMutableAttributedString *text = [NSMutableAttributedString new];
//    UIFont *font = [UIFont boldSystemFontOfSize:16];
//    for (int i = 0; i < tagsArray.count; i++) {
//        NSString *tag = tagsArray[i];
//        UIColor *tagStrokeColor = RGB(190, 190, 190);
//        UIColor *tagFillColor = RGB(243, 243, 243);
//        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
//        [tagText insertString:@"   " atIndex:0];
//        [tagText appendString:@"   "];
//        tagText.font = font;
//        tagText.color = RGB(190, 190, 190);
//        [tagText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.rangeOfAll];
//        
//        YYTextBorder *border = [YYTextBorder new];
//        border.strokeWidth = 0;
//        border.strokeColor = tagStrokeColor;
//        border.fillColor = tagFillColor;
//        border.cornerRadius = 0; // a huge value
//        border.lineJoin = kCGLineJoinBevel;
//        
//        border.insets = UIEdgeInsetsMake(-2, -5.5, -2, -8);
//        [tagText setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
//        
//        [text appendAttributedString:tagText];
//    }
//    text.lineSpacing = 10;
//    text.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    [text appendString:@"\n"];
//    textView.attributedText = text;
//    textView.selectedRange = NSMakeRange(text.length, 0);
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
