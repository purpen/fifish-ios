//
//  FSTemperatureView.m
//  Fifish
//
//  Created by macpro on 16/8/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTemperatureView.h"
#import "LiveVideoMacro.h"
@interface FSTemperatureView ()

@property (nonatomic ,strong) UIImageView * temperatureIconView;

@property (nonatomic ,strong) UILabel     * temperatureLab;


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
    self.temperatureLab.text = [NSString stringWithFormat:@"%@℃",_Tempera];
}
@end
