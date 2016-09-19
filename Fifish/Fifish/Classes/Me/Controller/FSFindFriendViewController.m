//
//  FSFindFriendViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/9/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFindFriendViewController.h"
#import "SVProgressHUD.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "InvitationModel.h"
#import "FindeFriendTableViewCell.h"
#import "FriendTableViewCell.h"

static NSString *const ShareURlText = @"我在Fiu浮游™寻找同路人；希望和你一起用文字来记录内心情绪，用滤镜来表达情感色彩，用分享去变现原创价值；带你发现美学科技的力量和感性生活的温度！来吧，去Fiu一下 >>> http://m.taihuoniao.com/fiu";

@interface FSFindFriendViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_userAry;
    NSMutableArray *_scenceAry;
}

@property(nonatomic,strong) UITableView *myTbaleView;
/**  */
@property (nonatomic, strong) NSArray *aryOne;
/**  */
@property (nonatomic, strong) NSArray *findUserAry;

@end

@implementation FSFindFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userAry = [NSMutableArray array];
    self.navigationItem.title = NSLocalizedString(@"findFriend", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTbaleView];
    //网络请求
    [self netGetData];
}

-(NSArray *)aryOne{
    if (!_aryOne) {
        InvitationModel *modelOne = [[InvitationModel alloc] initWithHeadStr:@"icon_wechat" :NSLocalizedString(@"Invite WeChat friends", nil) :NSLocalizedString(@"Share with friends", nil)];
        InvitationModel *modelTwo = [[InvitationModel alloc] initWithHeadStr:@"icon_weibo" :NSLocalizedString(@"Connect the weibo", nil) :NSLocalizedString(@"Share with friends", nil)];
        InvitationModel *modelThree = [[InvitationModel alloc] initWithHeadStr:@"Circle + User" :NSLocalizedString(@"Connect the address book", nil) :NSLocalizedString(@"Focus on what you know", nil)];
        _aryOne = [NSArray arrayWithObjects:modelOne,modelTwo,modelThree, nil];
    }
    return _aryOne;
}

-(void)netGetData{
    [SVProgressHUD show];
    
}


-(UITableView *)myTbaleView{
    if (!_myTbaleView) {
        _myTbaleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        
        _myTbaleView.delegate = self;
        _myTbaleView.dataSource = self;
        _myTbaleView.showsVerticalScrollIndicator = NO;
        _myTbaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTbaleView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    }
    return _myTbaleView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _userAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *id = @"cellOne";
        FindeFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
        if (cell == nil) {
            cell = [[FindeFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];
        }
        InvitationModel *model = self.aryOne[indexPath.row];
        [cell setUIWithModel:model];
        if (indexPath.row == 2) {
            cell.lineView.hidden = YES;
        }
        return cell;
    }else{
        static NSString *cellId = @"cellTwo";
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc] init];
        }
        cell.navi = self.navigationController;
//        FindFriendModel *model = _userAry[indexPath.section];
        cell.follow.tag = indexPath.section;
//        cell.sceneAry = model.scene;
        [cell.follow addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}


@end
