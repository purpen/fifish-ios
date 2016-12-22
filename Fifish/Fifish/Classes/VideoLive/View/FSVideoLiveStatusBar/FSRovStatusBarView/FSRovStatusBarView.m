
//
//  FSRovStatusBarView.m
//  Fifish
//
//  Created by macpro on 16/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRovStatusBarView.h"


@interface FSRovStatusBarView ()

/**
 一键返航
 */
@property (nonatomic,strong) UIButton * returnBtn;

/**
 定深
 */
@property (nonatomic,strong) UIButton * fixedDepthBtn;

/**
 巡航
 */
@property (nonatomic,strong) UIButton * cruiseBtn;

@end



@implementation FSRovStatusBarView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.returnBtn];
        [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.fixedDepthBtn];
        [self.fixedDepthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
        }];
        
        [self addSubview:self.cruiseBtn];
        [self.cruiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

-(UIButton *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnBtn setImage:[UIImage imageNamed:@"rov_return_icon"] forState:UIControlStateNormal];
    }
    return _returnBtn;
}

-(UIButton *)fixedDepthBtn{
    if (!_fixedDepthBtn) {
        _fixedDepthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fixedDepthBtn setImage:[UIImage imageNamed:@"rov_fixedDeep_icon"] forState:UIControlStateNormal];
        
    }
    return _fixedDepthBtn;
}

-(UIButton *)cruiseBtn{
    if (!_cruiseBtn) {
        _cruiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cruiseBtn setImage:[UIImage imageNamed:@"rov_cruise_icon"] forState:UIControlStateNormal];
    }
    return _cruiseBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
