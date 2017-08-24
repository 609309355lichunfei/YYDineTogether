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


@interface HomeSearchView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *searchResultView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


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
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"JSSHSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JSSHSearchCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JSYHSearchHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JSYHSearchHeaderCollectionReusableView"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchViewTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomSearchTableViewCell"];
    
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, 20);
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
        view.removeBT.hidden = NO;
    }
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSSHSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JSSHSearchCollectionViewCell" forIndexPath:indexPath];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomSearchTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.type = ViewControllerTypeTypeFood;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (_isStoreDataSource) {
//        HomeStoreViewController *storeVC = [[HomeStoreViewController alloc] init];
//        [self.tabBarController.navigationController pushViewController:storeVC animated:YES];
//    } else {
        HomeFoodDetailViewController *controller = [[HomeFoodDetailViewController alloc]init];
        [self.viewController.tabBarController.navigationController pushViewController:controller animated:YES];
//    }
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
