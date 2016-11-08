//
//  FSMessageViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMessageViewController.h"
#import "FSMessageTableViewCell.h"
#import "FSNewFansViewController.h"
#import "FSRecivedPriaseViewController.h"
#import "FSCommentViewController.h"
#import "FSRecivedPriaseViewController.h"
#import "FSMeViewController.h"
#import "FSTabBarController.h"

@interface FSMessageViewController () <UITableViewDelegate, UITableViewDataSource>

/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
/**  */
@property (nonatomic, copy) NSString *alert_fans_count;
/**  */
@property(nonatomic,copy) NSString *alert_like_count;
/**  */
@property(nonatomic,copy) NSString *alert_comment_count;

@end

@implementation FSMessageViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进行网络请求，获取对应的信息数
    FBRequest *request = [FBAPI getWithUrlString:@"/me/alertCount" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.modelAry removeAllObjects];
        NSDictionary *dataDict = result[@"data"];
        self.alert_fans_count = dataDict[@"alert_fans_count"];
        self.alert_like_count = dataDict[@"alert_like_count"];
        self.alert_comment_count = dataDict[@"alert_comment_count"];
        NSDictionary *dict1 = @{@"icon" : @"message_newFriend", @"typeLabel" : NSLocalizedString(@"The new fan", nil), @"count" : self.alert_fans_count};
        NSDictionary *dict2 = @{@"icon" : @"message_prasied", @"typeLabel" : NSLocalizedString(@"Received praise", nil), @"count" : self.alert_like_count};
        NSDictionary *dict3 = @{@"icon" : @"message_comment", @"typeLabel" : NSLocalizedString(@"comments", nil), @"count" : self.alert_comment_count};
        [self.modelAry addObject:dict1];
        [self.modelAry addObject:dict2];
        [self.modelAry addObject:dict3];
        [self.myTableView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = NSLocalizedString(@"Message", nil);
    [self.view addSubview:self.myTableView];
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
    return self.modelAry.count;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            FSNewFansViewController *vc = [[FSNewFansViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            FSRecivedPriaseViewController *vc = [[FSRecivedPriaseViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            FSCommentViewController *vc = [[FSCommentViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
