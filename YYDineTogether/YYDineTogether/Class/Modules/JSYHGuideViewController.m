//
//  JSYHGuideViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHGuideViewController.h"

@interface JSYHGuideViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation JSYHGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registUI];
}

- (void)registUI {
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"JSYHGuideCollectionViewCell"];
    self.dataArray = [@[@"LaunchIcon1",@"LaunchIcon2",@"LaunchIcon3"] mutableCopy];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSYHGuideCollectionViewCell" forIndexPath:indexPath];
    [cell.contentView removeAllSubviews];
    UIImage *image = [UIImage imageNamed:self.dataArray[indexPath.row]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:kScreen_Bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = image;
    
    [cell.contentView addSubview:imageView];
    if (indexPath.row == 2) {
        UIImageView *buttonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchBT"]];
        buttonImageView.frame = CGRectMake(0, 0, 100, 100);
        buttonImageView.contentMode = UIViewContentModeCenter;
        buttonImageView.center = CGPointMake(KScreenWidth / 2, KScreenHeight - 50);
        [cell.contentView addSubview:buttonImageView];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count - 1) {
        self.changeRootBlock();
    }
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
