//
//  FSImageSettingViewController.m
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageSettingViewController.h"
#import "FSImageSettingTableViewCell.h"

#import "FSCameraInfoModel.h"

#import "FSCameraManager.h"//camera管理类

@interface FSImageSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView         * menuTableview;

@property (nonatomic,strong)NSArray             * menuTitleArrs;//菜单

@property (nonatomic,strong)FSCameraInfoModel   * camearInfoModel;

@end

@implementation FSImageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpMenulist];
    
    [self getCameraInfo];
    // Do any additional setup after loading the view.
}

//获取摄像头信息
- (void)getCameraInfo{
    
    FSCameraManager * cameramManager = [[FSCameraManager alloc] init];
    [cameramManager RovGetCameraSuccess:^(NSDictionary *responseObject) {
        self.camearInfoModel = [[FSCameraInfoModel alloc] initWithDictory:responseObject[@"body"]];
        [self.menuTableview reloadData];
    } WithFailureBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)setUpMenulist{
    [self.view addSubview:self.menuTableview];
    [self.menuTableview mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (NSArray *)menuTitleArrs{
    if (!_menuTitleArrs) {
        _menuTitleArrs = @[NSLocalizedString(@"背光补偿", nil),NSLocalizedString(@"低照度", nil),NSLocalizedString(@"模式", nil)];
    }
    return _menuTitleArrs;
}
- (UITableView *)menuTableview{
    if (!_menuTableview) {
        _menuTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableview.delegate = self;
        _menuTableview.dataSource = self;
        _menuTableview.tableFooterView = [[UIView alloc] init];
        _menuTableview.backgroundColor = [UIColor blackColor];
        [_menuTableview registerClass:[FSImageSettingTableViewCell class] forCellReuseIdentifier:ImageSettingTableViewCellIden];
    }
    return _menuTableview;
}
#pragma mark tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuTitleArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FSImageSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ImageSettingTableViewCellIden];
    cell.textLabel.text = self.menuTitleArrs[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.Cellswitch.on = self.camearInfoModel.BackLight;
        }
            break;
        case 1:
        {
            cell.Cellswitch.on = self.camearInfoModel.LowLumEnable;
        }
            break;
        case 2:
        {
            
            switch (self.camearInfoModel.DayToNightModel) {
                case 0:
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@%@%@)",NSLocalizedString(@"自动", nil),NSLocalizedString(@"日", nil),NSLocalizedString(@"夜", nil),NSLocalizedString(@"模式", nil)];
                    break;
                }
                case 1:
                {
                    cell.detailTextLabel.text = NSLocalizedString(@"彩色", nil);
                    break;
                }
                case 2:
                {
                    cell.detailTextLabel.text = NSLocalizedString(@"黑白", nil);
                    break;
                }
                default:
                    break;
            }
            cell.Cellswitch.hidden = YES;
        }
            break;
        default:
            break;
    }
    return cell;
}



@end
