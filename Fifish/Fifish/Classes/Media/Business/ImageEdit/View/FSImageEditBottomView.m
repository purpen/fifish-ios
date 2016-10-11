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
 滤镜
 */
@property (nonatomic,strong) UIButton * FilterBtn;

/**
 调整
 */
@property (nonatomic,strong) UIButton * adjustmentBtn;

@end

@implementation FSImageEditBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.FilterBtn];
        [self.FilterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.mas_height);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
        }];
        
        
        UIView * lineview = [[UIView alloc] init];
        [self addSubview:lineview];
        lineview.backgroundColor = [UIColor colorWithHexString:@"3A5464"];
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
    return self;
}
- (UIButton *)FilterBtn{
    if (!_FilterBtn) {
        _FilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_FilterBtn setTitle:NSLocalizedString(@"Filter", nil) forState:UIControlStateNormal];
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
        [_adjustmentBtn setTitle:NSLocalizedString(@"Adjustment", nil) forState:UIControlStateNormal];
        [_adjustmentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_adjustmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_adjustmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adjustmentBtn;
}
- (void)btnClick:(UIButton *)btn{
    if (![self.delegate respondsToSelector:@selector(FSImageEditBottomViewChooseWithType:)]) {
        return;
    }
    
    if (btn == _FilterBtn) {
        
        btn.selected = YES;
        _adjustmentBtn.selected = NO;
        [self.delegate FSImageEditBottomViewChooseWithType:FSImageEditBottomViewFilterType];
    }
    else{
        btn.selected  = YES;
        _FilterBtn.selected = NO;
        [self.delegate FSImageEditBottomViewChooseWithType:FSImageEditBottomViewadjustmentType];
    }
    
}
@end
