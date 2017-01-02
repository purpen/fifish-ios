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
#import "FSRecordView.h"/*录制按钮view*/

#import "RovInfo.h"

#import "FSConst.h"

//测试用
#import "UIView+Toast.h"
@interface FSVideoDepthRulerView()

//左边刻度尺
@property (nonatomic, strong)FSRulersScrollView * leftRulersScrowView;

//右边刻度尺
@property (nonatomic, strong)FSRulersScrollView * rightRulersScrowView;


@property (nonatomic, strong)UILabel            * depthLab;//深度单位

@property (nonatomic)CGFloat                    deepCoefficient;//深度换算系数，单位为英尺系数为3.3，米为1

@property (nonatomic, strong)UIButton           * depthBtn;//深度数值

@property (nonatomic,strong)UIView              * currentLineView;//标识线

@property (nonatomic,strong)FSRecordView        * RecordView;//录制按钮view

//测试用的基准值，用于校准传感器偏差
@property (nonatomic)       CGFloat               testOriginalDeptch;
//是否需要校准当前值
@property (nonatomic)       BOOL                  needRecordDeptchValue;


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
    [self addSubview:self.depthBtn];
    [self.depthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.depthLab];
    [self.depthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.depthBtn.mas_left);
        make.bottom.equalTo(self.depthBtn.mas_top);
    }];
    
    [self addSubview:self.leftRulersScrowView];
    [self.leftRulersScrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.bottom.mas_equalTo (self.mas_bottom).offset(-20);
        make.width.mas_equalTo(@60);
        make.left.mas_equalTo(self.depthBtn.mas_right).offset(5);
    }];
    
    [self addSubview:self.currentLineView];
    [self.currentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftRulersScrowView.mas_centerY);
        make.left.equalTo(self.leftRulersScrowView.mas_left);
        make.size.mas_equalTo(CGSizeMake(20, 2));
    }];
    
    [self addSubview:self.RecordView];
    [self.RecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 110));
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

-(FSRulersScrollView *)leftRulersScrowView{
    if (!_leftRulersScrowView) {
        _leftRulersScrowView = [[FSRulersScrollView alloc] initWithMinValue:0 WithMaxValue:100.0 WithStpe:3.f WithFrame:CGRectMake(0, 0, 60, self.frame.size.height-40) WithRulerType:RulerLeftType];
        _leftRulersScrowView.backgroundColor =[UIColor clearColor];
    }
    return _leftRulersScrowView;
    
}


- (FSRulersScrollView *)rightRulersScrowView{
    if (!_rightRulersScrowView) {
        _rightRulersScrowView = [[FSRulersScrollView alloc] initWithMinValue:0 WithMaxValue:100.0 WithStpe:3.f WithFrame:CGRectMake(0, 0, 30, self.frame.size.height-40) WithRulerType:RulerRightType];
        _rightRulersScrowView.backgroundColor =[UIColor clearColor];
    }
    return _rightRulersScrowView;
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
        [_depthBtn setTitleColor:LIVEVIDEO_WHITE_COLOR forState:UIControlStateNormal];
        [_depthBtn addTarget:self action:@selector(recordCurrentDepth:) forControlEvents:UIControlEventTouchDownRepeat];
        _depthBtn.titleLabel.font = [UIFont systemFontOfSize:10];
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

//录制拍照VIEW
-(FSRecordView *)RecordView{
    if (!_RecordView) {
        
        _RecordView = [[FSRecordView alloc] init];
    
    }
    
    return _RecordView;
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
    if (self.needRecordDeptchValue ==YES) {
        self.testOriginalDeptch = rovinfo.Depth;
        self.needRecordDeptchValue = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
             [KEY_WINDOW makeToast:[NSString stringWithFormat:@"方向初始成功，初始角度为:%f",self.testOriginalDeptch]];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint point = CGPointMake(0,((rovinfo.Depth-self.testOriginalDeptch)*self.leftRulersScrowView.stpe)-(self.leftRulersScrowView.frame.size.height/2));
        [self.leftRulersScrowView setContentOffset:point animated:YES];
//        [self.rightRulersScrowView setContentOffset:point animated:YES;
        [self.depthBtn setTitle:[NSString stringWithFormat:@"-%.2f",(rovinfo.Depth-self.testOriginalDeptch)*self.deepCoefficient] forState:UIControlStateNormal];
    });
}

#pragma mark test
- (void)recordCurrentDepth:(UIButton *)btn{
    self.needRecordDeptchValue = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
