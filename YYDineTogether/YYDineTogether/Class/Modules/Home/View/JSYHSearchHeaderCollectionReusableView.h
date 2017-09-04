//
//  JSYHSearchHeaderCollectionReusableView.h
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/10.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSYHSearchHeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeBT;

@property (copy, nonatomic)  void (^removeBlock)();

@end
