
//
//  FSRovStatusBarView.m
//  Fifish
//
//  Created by macpro on 16/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRovStatusBarView.h"
#import "RovInfo.h"

@interface FSRovStatusBarView ()

/**
 一键返航
 */
@property (nonatomic,strong) UIButton * returnBtn;


/**
 是否返航
 */
@property (nonatomic) BOOL    isreturn;

/**
 定深
 */
@property (nonatomic,strong) UIButton * fixedDepthBtn;


/**
 是否定深
 */
@property (nonatomic) BOOL    isfixedDepth;
/**
 巡航
 */
@property (nonatomic,strong) UIButton * cruiseBtn;


/**
 是否巡航
 */
@property (nonatomic) BOOL    iscruise;
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
        
        //监听当前状态
        [self addObserverRovInfo];
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
        [_fixedDepthBtn setImage:[UIImage imageNamed:@"rov_fixedDeep_seleted_icon"] forState:UIControlStateHighlighted];
    }
    return _fixedDepthBtn;
}

-(UIButton *)cruiseBtn{
    if (!_cruiseBtn) {
        _cruiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cruiseBtn setImage:[UIImage imageNamed:@"rov_cruise_icon"] forState:UIControlStateNormal];
        [_cruiseBtn setImage:[UIImage imageNamed:@"rov_cruise_seleted_icon"] forState:UIControlStateHighlighted];
    }
    return _cruiseBtn;
}

#pragma mark RovDelegate
- (void)addObserverRovInfo{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChange:) name:@"RovInfoChange" object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)statusChange:(NSNotification*)notice{
    RovInfo *rovinfo = notice.userInfo[@"RVOINFO"];
    if (self.isfixedDepth!=rovinfo.isFixedDepth) {
        NSLog(@"%d",self.isfixedDepth);
        self.isfixedDepth = rovinfo.isFixedDepth;
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.fixedDepthBtn.highlighted = self.isfixedDepth;
        });
        
    }
    
    if (self.iscruise!=rovinfo.isFixedCruise) {
        self.iscruise = rovinfo.isFixedCruise;
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.cruiseBtn.highlighted = self.iscruise;
        });
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
