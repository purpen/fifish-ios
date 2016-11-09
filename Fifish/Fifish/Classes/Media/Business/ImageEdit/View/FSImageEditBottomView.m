//
//  FSImageEditBottomView.m
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageEditBottomView.h"

@interface FSImageEditBottomView ()


/**
 第一个按钮title
 */
@property (nonatomic,strong) NSString * fristTitleStr;


/**
 第二个按钮title
 */
@property (nonatomic,strong) NSString * secondTitleStr;
@end

@implementation FSImageEditBottomView
- (instancetype)initWithFristTitle:(NSString *)fristTitle AndSencondTitle:(NSString *)secondTitle{
    self = [super init];
    
    if (self) {
        _fristTitleStr = fristTitle;
        _secondTitleStr = secondTitle;
        self.backgroundColor = FishBlackColor;
        
        [self loadUserInterface];
    }
    
    return self;
    
}
- (void)loadUserInterface{
    [self addSubview:self.FilterBtn];
    [self.FilterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.mas_height);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
    }];
    
    
    UIView * lineview = [[UIView alloc] init];
    [self addSubview:lineview];
    lineview.backgroundColor = [UIColor grayColor];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 20));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.adjustmentBtn];
    [self.adjustmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.mas_height);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
}

- (UIButton *)FilterBtn{
    if (!_FilterBtn) {
        _FilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_FilterBtn setTitle:self.fristTitleStr forState:UIControlStateNormal];
        [_FilterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_FilterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _FilterBtn.selected = YES;
        [_FilterBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _FilterBtn;
}
-(UIButton *)adjustmentBtn{
    if (!_adjustmentBtn) {
        _adjustmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_adjustmentBtn setTitle:self.secondTitleStr forState:UIControlStateNormal];
        [_adjustmentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_adjustmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_adjustmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adjustmentBtn;
}
- (void)btnClick:(UIButton *)btn{
    if (![self.delegate respondsToSelector:@selector(FSImageEditBottomViewChooseWithIndex:)]) {
        return;
    }
    
    if (btn == _FilterBtn) {
        
        btn.selected = YES;
        _adjustmentBtn.selected = NO;
        [self.delegate FSImageEditBottomViewChooseWithIndex:0];
    }
    else{
        btn.selected  = YES;
        _FilterBtn.selected = NO;
        [self.delegate FSImageEditBottomViewChooseWithIndex:1];
    }
    
}
@end
