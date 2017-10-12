//
//  HomeComboRecomendViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/6/6.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "HomeComboRecomendViewController.h"
#import "HomeTableViewCell.h"
#import "JSYHCombListTableViewCell.h"
#import "JSYHComboModel.h"
#import "JSYHCombListHeaderTableViewCell.h"
#import "HomeActivityViewController.h"

@interface HomeComboRecomendViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,CAAnimationDelegate>{
    NSInteger _pageIndex;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoppingCartBTBottom;
@property (weak, nonatomic) IBOutlet UIView *shoppingCartView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCartCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UIBezierPath *path;
@property (nonatomic, strong) CALayer *dotLayer;

@end

@implementation HomeComboRecomendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    self.titleLabel.text = self.mytitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shoppingCartCountLabel.layer.cornerRadius = 9;
    if ([ShoppingCartManager sharedManager].count == 0) {
        self.shoppingCartCountLabel.hidden = YES;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
    } else {
        self.shoppingCartCountLabel.hidden = NO;
        self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].count];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:@"JSYHShoppingCartCountChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([ShoppingCartManager sharedManager].count == 0) {
            self.shoppingCartCountLabel.hidden = YES;
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
        } else {
            self.shoppingCartCountLabel.hidden = NO;
            self.shoppingCartCountLabel.text = [NSString stringWithFormat:@"%ld",[ShoppingCartManager sharedManager].count];
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[ShoppingCartManager sharedManager].totalPrice];
        }
        
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHCombListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHCombListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JSYHCombListHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"JSYHCombListHeaderTableViewCell"];
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConnectWithDataLoadType:DataLoadTypeNone];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf getConnectWithDataLoadType:DataLoadTypeMore];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getConnectWithDataLoadType:(DataLoadType)dataLoadType {
    _pageIndex = dataLoadType == DataLoadTypeNone ? 0 : _pageIndex + 1;
    if (_tagid == nil) {
        [[JSRequestManager sharedManager] getBannerWithPage:[NSString stringWithFormat:@"%ld",_pageIndex] type:@"3" lng:[JSYHLocationManager sharedManager].lng lat:[JSYHLocationManager sharedManager].lat Success:^(id responseObject) {
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *combsArray = dataDic[@"combs"];
            if (combsArray.count < 20) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            if (dataLoadType == DataLoadTypeNone) {
                [self.dataArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            for (NSDictionary *combDic in combsArray) {
                JSYHComboModel *model = [[JSYHComboModel alloc] init];
                [model setValuesForKeysWithDictionary:combDic];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        } Failed:^(NSError *error) {
            if (dataLoadType == DataLoadTypeNone) {
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    } else {
        [[JSRequestManager sharedManager] getCombsWithTagid:_tagid page:nil Success:^(id responseObject) {
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *combsArray = dataDic[@"combs"];
            if (combsArray.count < 20) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
            if (dataLoadType == DataLoadTypeNone) {
                [self.dataArray removeAllObjects];
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            for (NSDictionary *combDic in combsArray) {
                JSYHComboModel *model = [[JSYHComboModel alloc] init];
                [model setValuesForKeysWithDictionary:combDic];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        } Failed:^(NSError *error) {
            if (dataLoadType == DataLoadTypeNone) {
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }
    
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearShoppingCartAction:(id)sender {
    ShoppingChartViewController *shoppingCartVC = [[ShoppingChartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return KScreenWidth * 300 / 750;
    }
    return 230;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JSYHCombListHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHCombListHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    JSYHCombListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSYHCombListTableViewCell" forIndexPath:indexPath];
    __weak JSYHCombListTableViewCell *weakCell = cell;
    cell.addBlock = ^{
        CGRect parentRect = [weakCell convertRect:weakCell.addBT.frame toView:self.view];
        
            // 这里是动画开始的方法
        [self joinCartAnimationWithRect:parentRect];
            
        
    };
    JSYHComboModel *combModel = self.dataArray[indexPath.row];
    cell.combModel = combModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -加入购物车动画
-(void)joinCartAnimationWithRect:(CGRect)rect
{
    CGFloat endPoint_x = 40;
    CGFloat endPoint_y = kScreenHeight - 45;
    
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    
    //三点曲线
    [_path addCurveToPoint:CGPointMake(endPoint_x, endPoint_y)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 180, startY - 200)];
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = UIColorFromRGB(0xfd5352).CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 20, 20);
    _dotLayer.cornerRadius = 10;
    [self.view.layer addSublayer:_dotLayer];
    [self groupAnimation];
}
#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.6f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.6f];
}
- (void)removeFromLayer:(CALayer *)layerAnimation{
    
    [layerAnimation removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1];
        shakeAnimation.autoreverses = YES;
        // 这里是下方的自定义View上面 放的btn. 自己随便定义一个 0.-
        //        [_shopCartView.btnBackImg.layer addAnimation:shakeAnimation forKey:nil];
        
        
        [_shoppingCartCountLabel.layer addAnimation:shakeAnimation forKey:nil];
        
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
        HomeActivityViewController *combVC = [[HomeActivityViewController alloc] init];
        JSYHComboModel *model = self.dataArray[indexPath.row];
        combVC.combId = model.combid.stringValue;
        [self.navigationController pushViewController:combVC animated:YES];
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
