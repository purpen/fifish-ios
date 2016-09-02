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

#import "FSOSDManager.h"
#import "RovInfo.h"

@interface FSFSVideoLiveStatusBar()

@property (nonatomic ,strong) FSBatteryView     * batteryView;//电量

@property (nonatomic ,strong) UIButton          * FifishBackBtn;//返回按钮

@property (nonatomic ,strong) FSTemperatureView * TemperatureView;//温度

@property (nonatomic ,strong) UIButton          * MenuBtn;//菜单

@property (nonatomic ,strong) UILabel           * FifishBattery;//设备电量


@property (nonatomic ,assign) RovInfo           * ROVinfo;//ROV信息

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
            make.size.mas_equalTo(CGSizeMake(40, 10));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.FifishBattery];
        [self.FifishBattery mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.TemperatureView.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 10));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self ObserverWithOSD];
    }
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
    self.ROVinfo = [RovInfo sharedManager];
    [self.ROVinfo addObserver:self forKeyPath:@"Temp" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"Temp"]) {
        NSLog(@"--------%f<<<<<<<",self.ROVinfo.Pitch_angle);
        self.TemperatureView.Tempera =self.ROVinfo.Temp;
        self.FifishBattery.text = [NSString stringWithFormat:@"ROV电量:%f％",self.ROVinfo.Pitch_angle];

    }
    
}
-(void)dealloc{
    [self.ROVinfo removeObserver:self forKeyPath:@"Temp"];
}
@end
