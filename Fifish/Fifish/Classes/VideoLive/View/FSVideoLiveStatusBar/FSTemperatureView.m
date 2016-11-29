//
//  FSTemperatureView.m
//  Fifish
//
//  Created by macpro on 16/8/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTemperatureView.h"
#import "FSSettingManager.h"
#import "LiveVideoMacro.h"
@interface FSTemperatureView ()

@property (nonatomic ,strong) UIImageView * temperatureIconView;

@property (nonatomic ,strong) UILabel     * temperatureLab;

@property (nonatomic)         CGFloat       temperatureCoefficient;//温度系数


/**
 温度单位
 */
@property (nonatomic, strong, nonnull) NSString    * temperatureUnit;


@end


@implementation FSTemperatureView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.temperatureIconView];
        [self.temperatureIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(11, 11));
            make.left.equalTo(self.mas_left);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.temperatureLab];
        [self.temperatureLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 11));
            make.left.equalTo(self.temperatureIconView.mas_right).offset(5);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (UILabel *)temperatureLab{
    
    if (!_temperatureLab) {
        _temperatureLab  = [[UILabel alloc] init];
        _temperatureLab.font = [UIFont systemFontOfSize:10];
        _temperatureLab.textColor = LIVEVIDEO_DEFAULT_COLOR;
        _temperatureLab.textAlignment = NSTextAlignmentLeft;
        _temperatureLab.text = @"18°";
        self.temperatureCoefficient = 1.0;//初始温度系数为1。默认为摄氏度
        _temperatureUnit = @"℃";//默认为摄氏度单位
    }
    
    return _temperatureLab;
}

- (UIImageView *)temperatureIconView{
    if (!_temperatureIconView) {
        _temperatureIconView = [[UIImageView alloc] init];
        _temperatureIconView.image = [UIImage imageNamed:@"Temperature_icon"];
    }
    return _temperatureIconView;
}
- (void)setTempera:(NSString *)Tempera{
    _Tempera = Tempera;
    self.temperatureLab.text = [NSString stringWithFormat:@"%@%.1f",self.temperatureUnit,[_Tempera integerValue]*self.temperatureCoefficient];
}

-(void)updateUI{
    //摄氏度为单位
    if ([FSSettingManager GetTemperatureUnit]==0) {
        
        self.temperatureUnit = @"℃";
        self.temperatureCoefficient = 1.0;
    }
    //华氏度为单位
    else{
   
        self.temperatureUnit = @"℉";
        self.temperatureCoefficient = 33.8;
    }
}
@end
