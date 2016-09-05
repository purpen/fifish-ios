//
//  FSVideoDepthRulerView.m
//  Fifish
//
//  Created by macpro on 16/9/2.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoDepthRulerView.h"
#import "Masonry.h"
#import "FSRulersScrollView.h"

#import "RovInfo.h"
@interface FSVideoDepthRulerView()

//左边刻度尺
@property (nonatomic, strong)FSRulersScrollView * leftRulersScrowView;

//右边刻度尺
@property (nonatomic, strong)FSRulersScrollView * rightRulersScrowView;

@property (nonatomic, strong)UILabel            * depthLab;//深度单位

@property (nonatomic, strong)UIButton           * depthBtn;//深度数值

@property (nonatomic,strong)UIView              * currentLineView;//标识线



@end


@implementation FSVideoDepthRulerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpUI];
        //监听深度
        [self ObserverWithOSD];
    }
    return self;
}

- (void)setUpUI{
    
    [self addSubview:self.leftRulersScrowView];
    [self.leftRulersScrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.bottom.mas_equalTo (self.mas_bottom).offset(-20);
        make.width.mas_equalTo(@30);
        make.centerX.equalTo(self.mas_centerX).offset(-100);
    }];
    
    [self addSubview:self.depthBtn];
    [self.depthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftRulersScrowView.mas_left);
        make.centerY.equalTo(self.leftRulersScrowView.mas_centerY);
    }];
    
    [self addSubview:self.depthLab];
    [self.depthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.depthBtn.mas_left);
        make.bottom.equalTo(self.depthBtn.mas_top);
    }];
    
    [self addSubview:self.currentLineView];
    [self.currentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftRulersScrowView.mas_centerY);
        make.right.equalTo(self.leftRulersScrowView.mas_right);
        make.size.mas_equalTo(CGSizeMake(20, 2));
    }];
    
    [self addSubview:self.rightRulersScrowView];
    [self.rightRulersScrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftRulersScrowView);
        make.bottom.mas_equalTo (self.leftRulersScrowView);
        make.width.mas_equalTo(@30);
        make.centerX.equalTo(self.mas_centerX).offset(100);
    }];
}
-(FSRulersScrollView *)leftRulersScrowView{
    if (!_leftRulersScrowView) {
        _leftRulersScrowView = [[FSRulersScrollView alloc] initWithMinValue:0 WithMaxValue:100.0 WithStpe:3.f WithFrame:CGRectMake(0, 0, 30, self.frame.size.height-40) WithRulerType:RulerLeftType];
        _leftRulersScrowView.backgroundColor =[UIColor clearColor];
    }
    return _leftRulersScrowView;
    
}

-(UILabel *)depthLab{
    if (!_depthLab) {
        _depthLab = [[UILabel alloc] init];
        _depthLab.font = [UIFont systemFontOfSize:10];
        _depthLab.textAlignment = NSTextAlignmentLeft;
        _depthLab.textColor = [UIColor blackColor];
        _depthLab.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"unit", nil),NSLocalizedString(@"metre", nil)];
    }
    return _depthLab;
}

- (UIButton *)depthBtn{
    if (!_depthBtn) {
        _depthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_depthBtn setBackgroundImage:[UIImage imageNamed:@"line_depth"] forState:UIControlStateNormal];
        _depthBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_depthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _depthBtn;
}
- (UIView *)currentLineView{
    if (!_currentLineView) {
        _currentLineView = [[UIView alloc] init];
        _currentLineView.backgroundColor = [UIColor blackColor];
    }
    return _currentLineView;
}
- (FSRulersScrollView *)rightRulersScrowView{
    if (!_rightRulersScrowView) {
        _rightRulersScrowView = [[FSRulersScrollView alloc] initWithMinValue:0 WithMaxValue:100.0 WithStpe:3.f WithFrame:CGRectMake(0, 0, 30, self.frame.size.height-40) WithRulerType:RulerRightType];
        _rightRulersScrowView.backgroundColor =[UIColor clearColor];
    }
    return _rightRulersScrowView;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint point = CGPointMake(0,(rovinfo.Depth*self.leftRulersScrowView.stpe)-(self.leftRulersScrowView.frame.size.height/2));
//        NSLog(@">>>>>>>>heading:%.2f",rovinfo.Heading_angle);
        [self.leftRulersScrowView setContentOffset:point animated:YES];
        [self.rightRulersScrowView setContentOffset:point animated:YES];
        [self.depthBtn setTitle:[NSString stringWithFormat:@"-%.2f",rovinfo.Depth] forState:UIControlStateNormal];
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
