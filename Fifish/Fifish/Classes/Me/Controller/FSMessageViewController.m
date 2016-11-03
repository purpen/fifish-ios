//
//  FSMessageViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMessageViewController.h"
#import "FSMessageTableViewCell.h"

@interface FSMessageViewController () <UITableViewDelegate, UITableViewDataSource>

/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;

@end

@implementation FSMessageViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = NSLocalizedString(@"Message", nil);
    [self.view addSubview:self.myTableView];
    NSDictionary *dict1 = @{@"icon" : @"message_newFriend", @"typeLabel" : NSLocalizedString(@"The new fan", nil)};
    NSDictionary *dict2 = @{@"icon" : @"message_prasied", @"typeLabel" : NSLocalizedString(@"Received praise", nil)};
    NSDictionary *dict3 = @{@"icon" : @"message_comment", @"typeLabel" : NSLocalizedString(@"comments", nil)};
    [self.modelAry addObject:dict1];
    [self.modelAry addObject:dict2];
    [self.modelAry addObject:dict3];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH) style:UITableViewStylePlain];
        _myTableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:@"FSMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"FSMessageTableViewCell"];
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSMessageTableViewCell"];
    if (indexPath.row == 2) {
        cell.lineView.hidden = YES;
    }
    NSDictionary *dict = self.modelAry[indexPath.row];
    cell.dict = dict;
    return cell;
}

@end
