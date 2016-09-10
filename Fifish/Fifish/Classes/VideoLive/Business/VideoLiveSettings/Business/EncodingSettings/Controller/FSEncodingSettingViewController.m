//
//  FSEncodingSettingViewController.m
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSEncodingInfoModel.h"
#import "FSCameraManager.h"

#import "FSEncodingSettingViewController.h"
#import "FSFrameRateViewController.h"



static NSString * const EncodingSettingCellIedn = @"EncodingSettingcellIden";
@interface FSEncodingSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * menuTableView;

@property (nonatomic, strong)NSArray     * titleArr;

@property (nonatomic, strong)FSEncodingInfoModel * encodingModel;



@end

@implementation FSEncodingSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
    [self getCameraInfo];
    // Do any additional setup after loading the view.
}
- (void)getCameraInfo{
    FSCameraManager * cameraManager = [[FSCameraManager alloc] init];
    [cameraManager getVideoEncordeInfoWithSuccessBlock:^(NSDictionary *responseObject) {
        //这是什么垃圾数据结构！
        id resobj=responseObject[@"body"][@"StreamInfoListArray"][0][@"StreamInfoArray"];
        if ([resobj isKindOfClass:[NSArray class]]) {
            self.encodingModel = [[FSEncodingInfoModel alloc] initWithDictory:resobj[0]];
        }
        NSLog(@"%@",responseObject);
        [self.menuTableView reloadData];
    } WithFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)setupTable{
    [self setdissMissBtn];
    [self.view addSubview:self.menuTableView];
    [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableView.delegate = self;
        _menuTableView.dataSource =self;
        _menuTableView.backgroundColor = SETTING_Black_COLOR;
        _menuTableView.tableFooterView = [[UIView alloc] init];
    }
    return _menuTableView;
}   
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr =@[[NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"尺寸", nil),NSLocalizedString(@"帧率", nil)]];
    }
    return _titleArr;
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:EncodingSettingCellIedn];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EncodingSettingCellIedn];
    }
    cell.textLabel.textColor = SETTING_Gray_COLOR;
    cell.backgroundColor = SETTING_Black_COLOR;
    cell.detailTextLabel.textColor = SETTING_Gray_COLOR;
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@fps",self.encodingModel.VideoSizeStr,self.encodingModel.VideoFramerate];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSFrameRateViewController * FSFrameRateVc = [[FSFrameRateViewController alloc] init];
    FSFrameRateVc.title = self.titleArr[indexPath.row];
    FSFrameRateVc.view.frame = self.view.frame;
    [self.navigationController pushViewController:FSFrameRateVc animated:YES];
}
@end
