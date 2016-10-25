//
//  FSBearingsView.m
//  Fifish
//
//  Created by macpro on 16/9/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBearingsView.h"
#import "FSRulersScrollView.h"
#import "RovInfo.h"

@interface FSBearingsView()

@property (nonatomic,strong) FSRulersScrollView * BearingsScrollView;

@property (nonatomic,strong) UIButton           * angleBtn;//角度显示


@end

@implementation FSBearingsView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        //监听rov信息
        [self ObserverWithOSD];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.BearingsScrollView];
    [self.BearingsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 25));
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self addSubview:self.angleBtn];
    [self.angleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BearingsScrollView.mas_centerX);
        make.top.equalTo(self.BearingsScrollView.mas_bottom).offset(5);
    }];
}

- (FSRulersScrollView *)BearingsScrollView{
    if (!_BearingsScrollView) {
        _BearingsScrollView = [[FSRulersScrollView alloc] initWithMinValue:0 WithMaxValue:40 WithStpe:9 WithFrame:CGRectMake(0, 0, 80, 25) WithRulerType:RulerVorizontalType];
        
    }
    return _BearingsScrollView;
}
- (UIButton *)angleBtn{
    if (!_angleBtn) {
        _angleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_angleBtn setBackgroundImage:[UIImage imageNamed:@"line_heading"] forState:UIControlStateNormal];
        _angleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _angleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_angleBtn setTitle:@"12°" forState:UIControlStateNormal];
        [_angleBtn setTitleColor:LIVEVIDEO_DEFAULT_COLOR forState:UIControlStateNormal];
    }
    return _angleBtn;
}

#pragma 监听rov信息
- (void)ObserverWithOSD{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(depthChange:) name:@"RovInfoChange" object:nil];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)depthChange:(NSNotification *)notice{
    RovInfo *rovinfo = notice.userInfo[@"RVOINFO"];
    NSInteger angel = 0;
//    *   0<X<=90：Y=X;
//    *   90<X<=180：Y=180-X;
//    *   180<X<=270：Y=X-180;
//    *   270<X<=360：Y=360-X;
    if (0<rovinfo.Heading_angle&&rovinfo.Heading_angle<=90) {
        angel = rovinfo.Heading_angle;
    }
    if (90<rovinfo.Heading_angle&&rovinfo.Heading_angle<=180) {
        angel = 180-rovinfo.Heading_angle;
    }
    if (180<rovinfo.Heading_angle&&rovinfo.Heading_angle<=270) {
        angel = rovinfo.Heading_angle-180;
    }
    if (270<rovinfo.Heading_angle&&rovinfo.Heading_angle<=360) {
        angel = 360-rovinfo.Heading_angle;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.angleBtn setTitle:[NSString stringWithFormat:@"%02ld°",(long)angel] forState:UIControlStateNormal];
       CGPoint offset = CGPointMake(fabs(rovinfo.Heading_angle-360.0)-(self.BearingsScrollView.frame.size.width/2), 0);
        [self.BearingsScrollView setContentOffset:offset animated:YES];
    });
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
