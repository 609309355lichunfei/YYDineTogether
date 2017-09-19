//
//  JSYHFeedbackViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/3.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "JSYHFeedbackViewController.h"
#import "JSYHFeedbackCollectionViewCell.h"
#import "AJImageheadData.h"

@interface JSYHFeedbackViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation JSYHFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registUI {
    [self.collectionView registerNib:[UINib nibWithNibName:@"JSYHFeedbackCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JSYHFeedbackCollectionViewCell"];
    [self.collectionView reloadData];
}
- (IBAction)hidenKeyboardAction:(id)sender {
    [self.view endEditing:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArray.count == 3) {
        return 3;
    }
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSYHFeedbackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSYHFeedbackCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == self.dataArray.count) {
        [cell.myImageView setImage:[UIImage imageNamed:@"mine_feedback_add"]];
    } else {
        UIImage *image = self.dataArray[indexPath.row];
        [cell.myImageView setImage:image];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[AJImageheadData  shareInstance] showActionSheetInView:self.view fromController:self completion:^(UIImage *image, NSData *iamgeData) {
        [self.dataArray addObject:image];
        [self.collectionView reloadData];
    } cancelBlock:^{
    }];
}

- (IBAction)submitAction:(id)sender {
    if (self.contentTextView.text.length == 0) {
        [AppManager showToastWithMsg:@"请填写返回信息"];
        return;
    }
    
    
    NSMutableArray *imageNameArray = [NSMutableArray array];
    for (NSInteger i = 0 ; i < self.dataArray.count; i ++) {
        [imageNameArray addObject:@"image.png"];
    }
    [[JSRequestManager sharedManager] postFeedback:self.contentTextView.text imageArray:self.dataArray imageNameArray:imageNameArray Success:^(id responseObject) {
        [AppManager showToastWithMsg:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } Failed:^(NSError *error) {
        [AppManager showToastWithMsg:@"提交失败"];
    }];
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
