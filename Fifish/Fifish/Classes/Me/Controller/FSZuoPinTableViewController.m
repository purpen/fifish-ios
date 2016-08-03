//
//  FSZuoPinTableViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/29.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSZuoPinTableViewController.h"
#import "FSZuoPinTableViewCell.h"


@interface FSZuoPinTableViewController ()

@end

static NSString * const CellId = @"zuoPin";

@implementation FSZuoPinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化表格
    [self setupTableView];
    
}

-(void)setupTableView{
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSZuoPinTableViewCell class]) bundle:nil] forCellReuseIdentifier:CellId];
}




@end
