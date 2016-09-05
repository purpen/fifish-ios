//
//  FSFSVideoLiveStatusBar.m
//  Fifish
//
//  Created by macpro on 16/8/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFSVideoLiveStatusBar.h"
#import "FSBatteryView.h"
#import "FSTemperatureView.h"
#import "FSBearingsView.h"

#import "FSOSDManager.h"
#import "RovInfo.h"

@interface FSFSVideoLiveStatusBar()

@property (nonatomic ,strong) FSBatteryView     * batteryView;//电量

@property (nonatomic ,strong) UIButton          * FifishBackBtn;//返回按钮

@property (nonatomic ,strong) FSTemperatureView * TemperatureView;//温度

@property (nonatomic ,strong) UIButton          * MenuBtn;//菜单

@property (nonatomic ,strong) UILabel           * FifishBattery;//设备电量

@property (nonatomic ,strong) FSBearingsView    * BearingsView;//方向
@end

@implementation FSFSVideoLiveStatusBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.FifishBackBtn];
        [self.FifishBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 50));
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.MenuBtn];
        [self.MenuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            
        }];
        
        [self addSubview:self.batteryView];
        [self.batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.MenuBtn.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(55, 10));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.TemperatureView];
        [self.TemperatureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.batteryView.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 10));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.BearingsView];
        [self.BearingsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.centerX.equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(100,50));
        }];
        
        [self addSubview:self.FifishBattery];
        [self.FifishBattery mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.TemperatureView.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 10));
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    [self ObserverWithOSD];
    return self;
}


- (UIButton *)FifishBackBtn{
    if (!_FifishBackBtn) {
        _FifishBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_FifishBackBtn setTitle:@"FIFISH" forState:UIControlStateNormal];
        [_FifishBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _FifishBackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_FifishBackBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _FifishBackBtn;
}

- (UIButton *)MenuBtn{
    if (!_MenuBtn) {
        _MenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _MenuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_MenuBtn setImage:[UIImage imageNamed:@"live_menu_icon"] forState:UIControlStateNormal];
        [_MenuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MenuBtn;
}

- (FSBatteryView *)batteryView{
    if (!_batteryView) {
        _batteryView = [[FSBatteryView alloc] init];
    }
    return _batteryView;
}

-(UILabel *)FifishBattery{
    if (!_FifishBattery) {
        _FifishBattery = [[UILabel alloc] init];
        _FifishBattery.textColor = [UIColor blackColor];
        _FifishBattery.textAlignment = NSTextAlignmentRight;
        _FifishBattery.font = [UIFont systemFontOfSize:10];
    }
    return _FifishBattery;
}

- (FSBearingsView *)BearingsView{
    if (!_BearingsView) {
        _BearingsView = [[FSBearingsView alloc] init];
    }
    return _BearingsView;
}



- (void)menuBtnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(VideoLiveMenuBtnClick)]) {
        [self.delegate VideoLiveMenuBtnClick];
    }
}

//返回
- (void)BtnClick:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(FifishBackBtnClick)]) {
        [self.delegate FifishBackBtnClick];
    }
}

- (FSTemperatureView *)TemperatureView{
    if (!_TemperatureView) {
        _TemperatureView = [[FSTemperatureView alloc] init];
    }
    
    return _TemperatureView;
}
//监听控制板信息
- (void)ObserverWithOSD{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRovInfo:) name:@"RovInfoChange" object:nil];
}
- (void)getRovInfo:(NSNotification *)notice{
    RovInfo *rovinfo = notice.userInfo[@"RVOINFO"];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.FifishBattery.text = [NSString stringWithFormat:@"ROV电量:%.1f％",rovinfo.Remain_battery];
        self.TemperatureView.Tempera = rovinfo.Temp;
    });
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
