//
//  JSYHCombListTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/14.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHCombListTableViewCell.h"
#import "JSYHComboModel.h"
#import "JSYHCombListCollectionViewCell.h"
#import "JSYHDishModel.h"


@interface JSYHCombListTableViewCell ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *issaleImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *priceCoverView;
@property (weak, nonatomic) IBOutlet UILabel *discountpriceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *collectBT;
@property (weak, nonatomic) IBOutlet UIButton *startBT;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation JSYHCombListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
    MJWeakSelf;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        weakSelf.didSelectBlock();
    }];
    [self.contentView addGestureRecognizer:tap];
}

- (void)registUI {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"JSYHCombListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JSYHCombListCollectionViewCell"];
}

- (void)setCombModel:(JSYHComboModel *)combModel {
    _combModel = combModel;
    self.titleLabel.text = _combModel.name;
    self.discountpriceLabel.text = [NSString stringWithFormat:@"%@",_combModel.price];
    self.priceLabel.text = [NSString stringWithFormat:@"原¥%@",_combModel.originalprice];
    if ([_combModel.price isEqualToNumber:_combModel.originalprice]) {
        self.priceLabel.hidden = YES;
        self.priceCoverView.hidden = YES;
    } else {
        self.priceLabel.hidden = NO;
        self.priceCoverView.hidden = NO;
    }
    self.dataArray = _combModel.dishs;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 130);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSYHCombListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSYHCombListCollectionViewCell" forIndexPath:indexPath];
    JSYHDishModel *dishModel = self.dataArray[indexPath.row];
    cell.dishModel = dishModel;
    return cell;
}

- (IBAction)orderAction:(id)sender {
    [[ShoppingCartManager sharedManager] addToShoppingCartWitComb:self.combModel];
    self.addBlock();
}

- (IBAction)starAction:(id)sender {
    
}

- (IBAction)collectAction:(id)sender {
    
}


- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
