//
//  FSFrameRateViewController.m
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSGeneralSettingsCell.h"
#import "FSFrameRateViewController.h"
#import "FSCameraManager.h"




@interface FSFrameRateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * menuTableView;
@property (nonatomic,strong)NSArray     * menuTitleArrs;
@property (nonatomic,strong)NSArray     * sectionTitleArr;


@property (nonatomic,strong)       NSIndexPath  * currentsizeIdex;//当前选中视频大小
@property (nonatomic,strong)       NSIndexPath  * currentFrameRateIdex;//当前选中帧率


@end

@implementation FSFrameRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTable];
    // Do any additional setup after loading the view.
}

- (void)setUpTable{
 
    [self.view addSubview:self.menuTableView];
    [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}
- (NSArray *)menuTitleArrs{
//    NSLocalizedString(@"尺寸/帧率", nil)
    if (!_menuTitleArrs) {
        _menuTitleArrs = @[@[@"1280*720(720p)",@"1920*1080(1080p)",@"4096*2160(4k)"],@[@"25fps",@"30fps"]];
        
    }
    return _menuTitleArrs;
}

- (NSArray *)sectionTitleArr
{
    if (!_sectionTitleArr) {
        _sectionTitleArr = @[NSLocalizedString(@"尺寸", nil),NSLocalizedString(@"帧率", nil)];
    }
    return _sectionTitleArr;
}
//TODO:这个table要封装起来，每个设置页面都有
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableView.backgroundColor = SETTING_Black_COLOR;
        _menuTableView.delegate = self;
        _menuTableView.dataSource =self;
        _menuTableView.tableFooterView = [[UIView alloc] init];
        [_menuTableView registerClass:[FSGeneralSettingsCell class] forCellReuseIdentifier:GeneralSettingsCellIden];
    }
    return _menuTableView;
    
}

#pragma mark tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuTitleArrs.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menuTitleArrs[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSGeneralSettingsCell * cell = [tableView dequeueReusableCellWithIdentifier:GeneralSettingsCellIden];
    cell.textLabel.text = self.menuTitleArrs[indexPath.section][indexPath.row];
    
    if (indexPath == self.currentsizeIdex||indexPath==self.currentFrameRateIdex){
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * titleLab= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    titleLab.textColor = SETTING_Blue_COLOR;
    titleLab.text = self.sectionTitleArr[section];
    return titleLab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        self.currentsizeIdex = indexPath;
    }
    if (indexPath.section ==1) {
        self.currentFrameRateIdex = indexPath;
    }
    
    FSCameraManager * cameraManger = [[FSCameraManager  alloc] init];
//    NSMutableDictionary * params = [@{@"ChannelID":@0,@"StreamTypeId":@7,@"StreamId":@0,@"VideoSize":@3,@"VideoFramerate":@25} mutableCopy];
    NSNumber * Videosize=@112;
    NSNumber * VideoFramerate = @25;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                Videosize =@108;
            }
                break;
            case 1:
            {
                Videosize =@112;
            }
                break;
            case 2:
            {
                Videosize =@104;
            }
                break;
                
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                VideoFramerate = @25;
            }
                break;
            case 1:
            {
                VideoFramerate = @30;
            }
                break;
            default:
                break;
        }
    }
    
    NSMutableDictionary *params = [@{@"ChannelTypeId":@1,@"StreamInfoListArray":@[@{@"StreamTypeId":@3,@"StreamInfoArray":@[@{@"H264Profiles": @2,
                                                                                                                              @"StreamId": @1,
                                                                                                                              @"VideoBitrateCtrlMode": @0,
                                                                                                                              @"VideoCBRBitrate": @512,
                                                                                                                              @"VideoEncodeFormat": @0,
                                                                                                                              @"VideoFramerate": VideoFramerate,
                                                                                                                              @"VideoGop": @25,
                                                                                                                              @"VideoQuality": @50,
                                                                                                                              @"VideoSize": Videosize,
                                                                                                                              @"VideoType": @1,
                                                                                                                              @"VideoVBRMaxBitrate": @1000,
                                                                                                                              @"VideoVBRMinBitrate": @512
},
                                                                                                                            @{@"H264Profiles": @2,
                                                                                                                                                                                         @"StreamId": @1,
                                                                                                                                                                                         @"VideoBitrateCtrlMode": @0,
                                                                                                                                                                                         @"VideoCBRBitrate": @512,
                                                                                                                                                                                         @"VideoEncodeFormat": @0,
                                                                                                                                                                                         @"VideoFramerate": @25,
                                                                                                                                                                                         @"VideoGop": @25,
                                                                                                                                                                                         @"VideoQuality": @50,
                                                                                                                                                                                         @"VideoSize": @108,
                                                                                                                                                                                         @"VideoType": @1,
                                                                                                                                                                                         @"VideoVBRMaxBitrate": @1000,
                                                                                                                                                                                         @"VideoVBRMinBitrate": @512
}]}]} mutableCopy];
    [cameraManger RovSetEncodeingInfo:params Success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
    } WithFailureBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    [tableView reloadData];
}
@end
