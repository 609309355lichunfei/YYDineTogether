//
//  IndentTableViewCell.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/15.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "IndentTableViewCell.h"
#import "IndentCellTableViewCell.h"
#import "JSYHOrderModel.h"
#import "JSYHShopModel.h"
#import "JSYHPreOrderTableViewCell.h"
#import "JSYHPayWayViewController.h"

@interface IndentTableViewCell ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger _time;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondBT;
@property (weak, nonatomic) IBOutlet UIButton *firstBT;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (strong, nonatomic) NSTimer *timer;


@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation IndentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registUI];
}

- (void)registUI {
    self.secondBT.layer.cornerRadius = 2;
    self.firstBT.layer.cornerRadius = 2;
    self.firstBT.layer.borderWidth = 0.5;
    self.firstBT.layer.borderColor = [UIColorFromRGB(0xfd5353) CGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHPreOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndentCellTableViewCell"];
}

- (void)setOrderModel:(JSYHOrderModel *)orderModel {
    _orderModel = orderModel;
    self.timeLabel.text = [AppManager timestampSwitchTime:_orderModel.ordertime];
//    if (_orderModel.paystatus == 0) {
//        self.statusLabel.text = @"待支付";
//        self.firstBT.hidden = NO;
//        self.secondBT.hidden = NO;
//    } else {
//        self.firstBT.hidden = YES;
//        self.secondBT.hidden = YES;
//    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    switch (_orderModel.status) {
        case 1:{
            self.statusLabel.text = @"待支付";
            if (600 > ([AppManager getNowTimestamp] + [UserManager sharedManager].timerinterval - _orderModel.ordertime) && ([AppManager getNowTimestamp] + [UserManager sharedManager].timerinterval - _orderModel.ordertime) > 0) {
                _time = 600 - ([AppManager getNowTimestamp] + [UserManager sharedManager].timerinterval - _orderModel.ordertime) + 10;
                NSString *minute = [NSString stringWithFormat:@"%ld",_time / 60];
                if (_time % 60 > 9) {
                    NSString *second = [NSString stringWithFormat:@"%ld",_time % 60];
                    self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                } else {
                    NSString *second = [NSString stringWithFormat:@"0%ld",_time % 60];
                    self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                }
                    self.timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
                        _time --;
                        if (_time == 0) {
                            [_timer invalidate];
                        }
                        NSString *minute = [NSString stringWithFormat:@"%ld",_time / 60];
                        if (_time % 60 > 9) {
                            NSString *second = [NSString stringWithFormat:@"%ld",_time % 60];
                            self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                        } else {
                            NSString *second = [NSString stringWithFormat:@"0%ld",_time % 60];
                            self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                        }
                        
                        
                    } repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:(NSRunLoopCommonModes)];
                
                
            } else {
                self.timerLabel.text = @"00:00";
            }
            self.timerImageView.hidden = NO;
            self.timerLabel.hidden = NO;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = NO;
            break;}
        case 2:{
            self.statusLabel.text = @"等待商家接单 (0/5)";
            if (300 > ([AppManager getNowTimestamp] + [UserManager sharedManager].timerinterval - _orderModel.ordertime) && ([AppManager getNowTimestamp] + [UserManager sharedManager].timerinterval - _orderModel.ordertime) > 0) {
                _time = 300 - ([AppManager getNowTimestamp] - _orderModel.paytime) + [UserManager sharedManager].timerinterval + 10;
                NSString *minute = [NSString stringWithFormat:@"%ld",_time / 60];
                if (_time % 60 > 9) {
                    NSString *second = [NSString stringWithFormat:@"%ld",_time % 60];
                    self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                } else {
                    NSString *second = [NSString stringWithFormat:@"0%ld",_time % 60];
                    self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                }
                if (self.timer == nil) {
                    self.timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
                        _time --;
                        if (_time == 0) {
                            [self.timer invalidate];
                        }
                        NSString *minute = [NSString stringWithFormat:@"%ld",_time / 60];
                        if (_time % 60 > 9) {
                            NSString *second = [NSString stringWithFormat:@"%ld",_time % 60];
                            self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                        } else {
                            NSString *second = [NSString stringWithFormat:@"0%ld",_time % 60];
                            self.timerLabel.text = [NSString stringWithFormat:@"%@:%@",minute,second];
                        }
                    } repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:(NSRunLoopCommonModes)];
                }
                
            } else {
                self.timerLabel.text = @"00:00";
            }
            self.timerImageView.hidden = NO;
            self.timerLabel.hidden = NO;
            self.firstBT.hidden = NO;
            self.secondBT.hidden = YES;
            break;}
        case 3:
            self.statusLabel.text = @"等待商家接单";
            self.timerImageView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = YES;
            break;
        case 4:
            self.statusLabel.text = @"订单进行中";
            self.timerImageView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = YES;
            break;
        case 9:
            self.statusLabel.text = @"配送中";
            self.timerImageView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = YES;
            break;
        case 10:
            self.statusLabel.text = @"已完成";
            self.timerImageView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = YES;
            break;
        case 11:
            self.statusLabel.text = @"支付超时";
            self.timerImageView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = YES;
            break;
        case 12:
            self.statusLabel.text = @"已取消";
            self.timerImageView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = YES;
            break;
        case 13:
            self.statusLabel.text = @"已退款";
            self.timerImageView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = YES;
            break;
        case 14:
            self.statusLabel.text = @"接单超时";
            self.timerImageView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = YES;
            break;
        case 15:
            self.statusLabel.text = @"配送超时";
            self.timerImageView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.firstBT.hidden = YES;
            self.secondBT.hidden = YES;
            break;
            
        default:
            break;
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%@",_orderModel.lastprice];
    self.dataArray = _orderModel.shops;
    [self.tableView reloadData];
}

- (IBAction)firstBTAction:(id)sender {
//    self.firstBlock(self.orderModel);
    [MBProgressHUD showMessage:@"取消订单"];
    [[JSRequestManager sharedManager] cancelorderWithOrderNO:self.orderModel.order_no Success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        self.firstBlock(_orderModel);
    } Failed:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [AppManager showToastWithMsg:@"取消成功"];
    }];
}


- (IBAction)secondBTAction:(id)sender {
//    self.secondBlock(self.orderModel);
    JSYHPayWayViewController *paywayVC = [[JSYHPayWayViewController alloc] init];
    paywayVC.order_no = self.orderModel.order_no;
    paywayVC.price = [NSString stringWithFormat:@"%@",self.orderModel.lastprice];
    [self.viewController.tabBarController.navigationController pushViewController:paywayVC animated:YES];
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHShopModel *model = self.dataArray[indexPath.row];
    return model.orderHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSYHPreOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndentCellTableViewCell" forIndexPath:indexPath];
    JSYHShopModel *model = self.dataArray[indexPath.row];
    cell.shopModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -懒加载
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
