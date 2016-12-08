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


/**
 记录当前参数，因为参数显示UI要求为0-1。各个参数范围不同，通过type换算
 */
@property (nonatomic)       NSInteger  paramsType;

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
        _MainSlider.userInteractionEnabled = YES;
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
            MaxValue = 0.5;
            MinValue = -0.5;
            CurrentValue = fsimage.lightValue;//值的范围是-1 - 1，不能显示太黑或者太白，只允许-0.5-0.5。标准值是0
            
        }
            break;
        case 1:
        {
            MaxValue = 1.0;
            MinValue = -1.0;
            CurrentValue = fsimage.contrastValue-1;//值的范围是0-4，为了方便计算，只允许0-2。标准值是1
        }
            break;
        case 2:
        {
            MaxValue = 1.0;
            MinValue = -1.0;
            CurrentValue = (fsimage.staurationValue-1)/2.0;//值的范围是0-2，显示要求是-1-1，所以当前值是差值的比例。
        }
            break;
        case 3:
        {
            MaxValue = 1.0;
            MinValue = -1.0;
            CurrentValue = fsimage.sharpnessValue/8.0;//值的范围是-4 - 4，所以当前值是差值的比例
        }
            break;
        case 4:
        {
            MaxValue = 1.0;
            MinValue = -1.0;
            CurrentValue = (fsimage.colorTemperatureValue-5000)/5000.0;//值的范围是1000 - 10000，所以当前值是差值的比例
        }
            break;
        default:
            break;
    }
    /*记录当前编辑状态*/
    self.paramsType = type;
    
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
    
    /*根据UI要求换算完的结果*/
    CGFloat resultValue;
    switch (self.paramsType) {
        case 0:
        {
            //亮度不做换算，但需要判断，不能让图片太黑或者太白。
            resultValue = sender.value;
        }
            break;
        
        case 1:
        {
            resultValue = sender.value+1;//显示时减1，现在加回来
        }
            break;
        case 2:
        {
            resultValue = sender.value*2.0+1;//显示时除以2，现在乘回来
        }
            break;
        case 3:
        {
            resultValue = sender.value*8.0;//显示时除以8，现在乘回来
        }
            break;
        case 4:
        {
            resultValue = sender.value*5000+5000;//
        }
            break;
        default:
            break;
    }
    
    [self.delegate FSRegulateSliderViewSliderValueChangeWithValue:resultValue];
}
@end
