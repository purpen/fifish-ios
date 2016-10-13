//
//  FSRegulateSliderView.m
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRegulateSliderView.h"
#import "FSFliterImage.h"
@interface FSRegulateSliderView ()


@property (nonatomic,strong)UISlider * MainSlider;

@property (nonatomic,strong)UILabel  * ValueLab;


@end

@implementation FSRegulateSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUserInterFace];
    }
    return self;
}
- (void)makeUserInterFace{
    self.backgroundColor = [UIColor colorWithHexString:@"262E35"];
    [self addSubview:self.MainSlider];
    [self.MainSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.ValueLab];
    [self.ValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.MainSlider.mas_top).offset(-10);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (UISlider *)MainSlider{
    if (!_MainSlider) {
        _MainSlider = [[UISlider alloc] init];
        _MainSlider.backgroundColor = [UIColor clearColor];
        _MainSlider.tintColor = [UIColor blueColor];
        
        _MainSlider.value=50;
        _MainSlider.minimumValue=0;
        _MainSlider.maximumValue=100;
        
        [_MainSlider setMaximumTrackTintColor:[UIColor blackColor]];
        [_MainSlider setMinimumTrackTintColor:[UIColor colorWithHexString:@"2288FF"]];
        [_MainSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
//        [_MainSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
//        [_MainSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    }
    return _MainSlider;
}
- (UILabel *)ValueLab{
    if (!_ValueLab) {
        _ValueLab = [[UILabel alloc] init];
        _ValueLab.font = [UIFont systemFontOfSize:14];
        _ValueLab.textColor = [UIColor whiteColor];
    }
    return _ValueLab;
}
- (void)setSliederWithType:(NSInteger)type AndImage:(FSFliterImage *)fsimage{
    CGFloat MaxValue,MinValue,CurrentValue;
    switch (type) {
        case 0:
        {
            MaxValue = 1.0;
            MinValue = -1.0;
            CurrentValue = fsimage.lightValue;
            
        }
            break;
        case 1:
        {
            MaxValue = 4.0;
            MinValue = 0;
            CurrentValue = fsimage.contrastValue;
        }
            break;
        case 2:
        {
            MaxValue = 2.0;
            MinValue = 0;
            CurrentValue = fsimage.staurationValue;
        }
            break;
        case 3:
        {
            MaxValue = 4.0;
            MinValue = -4.0;
            CurrentValue = fsimage.sharpnessValue;
        }
            break;
        case 4:
        {
            MaxValue = 10000;
            MinValue = 1000;
            CurrentValue = fsimage.colorTemperatureValue;
        }
            break;
        default:
            break;
    }
    self.ValueLab.text = [NSString stringWithFormat:@"%.2f",CurrentValue];
    self.MainSlider.maximumValue = MaxValue;
    self.MainSlider.minimumValue = MinValue;
    self.MainSlider.value = CurrentValue;
}
//-(void)setSliederMinValue:(CGFloat)min MaxValue:(CGFloat)Max CurrentValue:(CGFloat)current{
//    self.ValueLab.text = [NSString stringWithFormat:@"%.2f",current];
//    self.MainSlider.maximumValue = Max;
//    self.MainSlider.minimumValue = min;
//    self.MainSlider.value = current;
//}
- (CGFloat)sliderCurrentValue{
    return self.MainSlider.value;
}
- (void)sliderValueChange:(UISlider *)sender{
    self.ValueLab.text = [NSString stringWithFormat:@"%.2f",sender.value];
    [self.delegate FSRegulateSliderViewSliderValueChangeWithValue:sender.value];
}
@end
