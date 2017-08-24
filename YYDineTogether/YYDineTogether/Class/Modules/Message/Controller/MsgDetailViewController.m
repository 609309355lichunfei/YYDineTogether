//
//  MsgDetailViewController.m
//  YYDineTogether
//
//  Created by 吴頔 on 17/8/21.
//  Copyright © 2017年 lichunfei. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "HomeDishTableViewCell.h"
#import "MsgDetailTableViewCell.h"
#import "JSYHSharedView.h"

@interface MsgDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *indentTableView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registUI];
}

- (void)registUI {
    [self.indentTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgDetailIndentTableViewCell"];
    [self.commentTableView registerNib:[UINib nibWithNibName:@"MsgDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgDetailCommentTableViewCell"];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sharedAction:(id)sender {
    JSYHSharedView *sharedView = [[[NSBundle mainBundle] loadNibNamed:@"JSYHSharedView" owner:self options:nil] firstObject];
    sharedView.frame = kScreen_Bounds;
    [kAppWindow addSubview:sharedView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _indentTableView) {
        return 2;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _indentTableView) {
        return 100;
    } else {
        return 170;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _indentTableView) {
        HomeDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgDetailIndentTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        MsgDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgDetailCommentTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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
