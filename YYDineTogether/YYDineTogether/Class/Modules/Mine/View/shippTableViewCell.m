//
//  shippTableViewCell.m
//  YYDineTogether
//
//  Created by 李春菲 on 17/6/5.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "shippTableViewCell.h"


@implementation shippTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)InstallTableViewCellWith:(UITableView *)tableview indexPath:(NSIndexPath *)indexPath {
    
    NSString * idefider = @"installCell";
    shippTableViewCell * cell = [tableview dequeueReusableCellWithIdentifier:idefider];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"shippTableViewCell" owner:nil options:nil]lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)configInstallTableCellWith:(NSIndexPath *)indexPath {
    
    
}
//编辑
- (IBAction)Compile:(id)sender {
    if ([self.delegate  performSelector:@selector(CompileWithBt)]) {
        [self.delegate  respondsToSelector:@selector(CompileWithBt)];
    }
}



@end
