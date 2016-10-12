//
//  FSRegulateSliderView.m
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRegulateSliderView.h"

@interface FSRegulateSliderView ()




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
}

- (UISlider *)MainSlider{
    if (!_MainSlider) {
        _MainSlider = [[UISlider alloc] init];
        _MainSlider.backgroundColor = [UIColor clearColor];
        _MainSlider.tintColor = [UIColor blueColor];
        
        _MainSlider.value=0.5;
        _MainSlider.minimumValue=0.0;
        _MainSlider.maximumValue=1.0;
        
        [_MainSlider setMaximumTrackTintColor:[UIColor blackColor]];
        [_MainSlider setMinimumTrackTintColor:[UIColor colorWithHexString:@"2288FF"]];
//        [_MainSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
//        [_MainSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    }
    return _MainSlider;
}
@end
