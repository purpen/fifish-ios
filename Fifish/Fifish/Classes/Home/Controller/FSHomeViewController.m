//
//  FSHomeViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeViewController.h"
#import "UIBarButtonItem+FSExtension.h"
#import "FSConst.h"
#import "FSHomeViewCell.h"
#import "FSHomeModel.h"

@interface FSHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**  */
@property (nonatomic, strong) UITableView *contenTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
@end

static NSString * const CellId = @"home";

@implementation FSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview:self.contenTableView];
    [self.contenTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSHomeViewCell class]) bundle:nil] forCellReuseIdentifier:CellId];
}

-(UITableView *)contenTableView{
    if (!_contenTableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _contenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _contenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _contenTableView.backgroundColor = [UIColor yellowColor];
        _contenTableView.delegate = self;
        _contenTableView.dataSource = self;
    }
    return _contenTableView;
}

-(void)setupNav{
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"me_search" highImage:nil target:self action:@selector(searchClick)];
    self.navigationItem.leftBarButtonItem = searchItem;
}

-(void)searchClick{
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.model = self.modelAry[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeModel *model = self.modelAry[indexPath.row];
    return model.cellHeghit;
}

@end
