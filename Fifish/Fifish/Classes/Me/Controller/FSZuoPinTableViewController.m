//
//  FSZuoPinTableViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/29.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSZuoPinTableViewController.h"
#import "FSZuoPinTableViewCell.h"
#import "FSZuoPin.h"


@interface FSZuoPinTableViewController ()

@end

static NSString * const CellId = @"zuoPin";

@implementation FSZuoPinTableViewController

-(void)setZuoPins:(NSMutableArray *)zuoPins{
    _zuoPins = zuoPins;
    [self.tableView reloadData];
}

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.zuoPins.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSZuoPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.zuopin = self.zuoPins[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSZuoPin *zuoPin = self.zuoPins[indexPath.row];
    return zuoPin.cellHeight;
}

@end
