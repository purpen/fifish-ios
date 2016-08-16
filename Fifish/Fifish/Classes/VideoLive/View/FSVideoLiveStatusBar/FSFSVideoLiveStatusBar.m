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

#import "Masonry.h"
@interface FSFSVideoLiveStatusBar()

@property (nonatomic ,strong) FSBatteryView     * batteryView;//电量

@property (nonatomic ,strong) UIButton          * FifishBackBtn;//返回按钮

@property (nonatomic ,strong) FSTemperatureView * TemperatureView;//温度

@property (nonatomic ,strong) UIButton          * MenuBtn;//菜单
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
//        [self addSubview:self.TemperatureView];
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
    }
    return _MenuBtn;
}

- (FSBatteryView *)batteryView{
    if (!_batteryView) {
        _batteryView = [[FSBatteryView alloc] init];
    }
    return _batteryView;
}
- (void)BtnClick:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(FifishBackBtnClick)]) {
        [self.delegate FifishBackBtnClick];
    }
}
@end
