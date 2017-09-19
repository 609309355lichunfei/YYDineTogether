//
//  JSYHMSShopTagCollectionViewCell.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/9/8.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSYHTagModel;
@interface JSYHMSShopTagCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) JSYHTagModel *tagModel;
@end
