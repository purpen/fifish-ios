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
#import "FSSettingManager.h"

#import "RovInfo.h"
@interface FSVideoDepthRulerView()

//左边刻度尺
@property (nonatomic, strong)FSRulersScrollView * leftRulersScrowView;

//右边刻度尺
@property (nonatomic, strong)FSRulersScrollView * rightRulersScrowView;

//左边框
@property (nonatomic, strong)UIImageView        * leftLineView;

//右边框
@property (nonatomic, strong)UIImageView        * RightLineView;

@property (nonatomic, strong)UILabel            * depthLab;//深度单位

@property (nonatomic)CGFloat                    deepCoefficient;//深度换算系数，单位为英尺系数为3.3，米为1

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
        make.centerX.equalTo(self.mas_centerX).offset(-150);
    }];
    
    [self addSubview:self.leftLineView];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftRulersScrowView.mas_right).offset(5);
        make.centerY.equalTo(self.leftRulersScrowView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(6, 200));
    }];
    
    [self addSubview:self.rightRulersScrowView];
    [self.rightRulersScrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftRulersScrowView);
        make.bottom.mas_equalTo (self.leftRulersScrowView);
        make.width.mas_equalTo(@30);
        make.centerX.equalTo(self.mas_centerX).offset(150);
    }];
    
    [self addSubview:self.RightLineView];
    [self.RightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightRulersScrowView.mas_left).offset(-5);
        make.centerY.equalTo(self.leftRulersScrowView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(6, 200));
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
}

-(FSRulersScrollView *)leftRulersScrowView{
    if (!_leftRulersScrowView) {
        _leftRulersScrowView = [[FSRulersScrollView alloc] initWithMinValue:0 WithMaxValue:100.0 WithStpe:3.f WithFrame:CGRectMake(0, 0, 30, self.frame.size.height-40) WithRulerType:RulerLeftType];
        _leftRulersScrowView.backgroundColor =[UIColor clearColor];
    }
    return _leftRulersScrowView;
    
}

- (UIImageView *)leftLineView{
    if (!_leftLineView) {
        _leftLineView = [[UIImageView alloc] init];
        _leftLineView.image = [UIImage imageNamed:@"left_line"];
    }
    return _leftLineView;
}

- (FSRulersScrollView *)rightRulersScrowView{
    if (!_rightRulersScrowView) {
        _rightRulersScrowView = [[FSRulersScrollView alloc] initWithMinValue:0 WithMaxValue:100.0 WithStpe:3.f WithFrame:CGRectMake(0, 0, 30, self.frame.size.height-40) WithRulerType:RulerRightType];
        _rightRulersScrowView.backgroundColor =[UIColor clearColor];
    }
    return _rightRulersScrowView;
}

- (UIImageView *)RightLineView{
    if (!_RightLineView) {
        _RightLineView = [[UIImageView alloc] init];
        _RightLineView.image = [UIImage imageNamed:@"right_line"];
    }
    return _RightLineView;
}

-(UILabel *)depthLab{
    if (!_depthLab) {
        _depthLab = [[UILabel alloc] init];
        _depthLab.font = [UIFont systemFontOfSize:10];
        _depthLab.textAlignment = NSTextAlignmentLeft;
        _depthLab.textColor = LIVEVIDEO_DEFAULT_COLOR;
        
    }
    [self updataUI];
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
        _currentLineView.backgroundColor = LIVEVIDEO_DEFAULT_COLOR;
    }
    return _currentLineView;
}

-(void)updataUI{
    //英尺为单位
    if ([FSSettingManager getDeepUnit]==0) {
        _depthLab.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Depth", nil),NSLocalizedString(@"foot", nil)];
        self.deepCoefficient = 3.3;
    }
    //米为单位
    else{
        _depthLab.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Depth", nil),NSLocalizedString(@"metre", nil)];
        
        //初始化深度系数为1.单位为米；例：传回数据为10此时就是10*1为1米。如果单位为英尺此时系数为3.3，10*3.3为33英尺。
        self.deepCoefficient = 1;
    }
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
        [self.leftRulersScrowView setContentOffset:point animated:YES];
        [self.rightRulersScrowView setContentOffset:point animated:YES];
        [self.depthBtn setTitle:[NSString stringWithFormat:@"-%.2f",rovinfo.Depth*self.deepCoefficient] forState:UIControlStateNormal];
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
