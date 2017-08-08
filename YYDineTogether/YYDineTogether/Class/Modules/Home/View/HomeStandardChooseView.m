//
//  HomeStandardChooseView.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/7/13.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeStandardChooseView.h"
#import "HomeStandardCollectionViewCell.h"
#import "HomeStandarHeaderCollectionReusableView.h"

@interface HomeStandardChooseView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *doneBT;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation HomeStandardChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registUI];
}

- (void)registUI {
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeStandardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeStandardCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeStandarHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeStandardHeaderView"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)doneAction:(id)sender {
    [self removeFromSuperview];
}

- (void)showView {
    self.frame = kScreen_Bounds;
    [kAppWindow addSubview:self];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(100, 50);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HomeStandarHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeStandardHeaderView" forIndexPath:indexPath];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeStandardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeStandardCollectionViewCell" forIndexPath:indexPath];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
