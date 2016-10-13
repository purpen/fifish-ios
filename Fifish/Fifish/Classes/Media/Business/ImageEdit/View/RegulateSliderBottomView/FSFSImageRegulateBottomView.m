//
//  FSFSImageRegulateBottomView.m
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFSImageRegulateBottomView.h"
#import "FSImageEditBottomView.h"

@interface FSFSImageRegulateBottomView ()<FSImageEditBottomViewDelegate,FSRegulateSliderViewDelegate>

@property (nonatomic,strong) FSImageEditBottomView  * bottomView;


@end


@implementation FSFSImageRegulateBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUserInterface];
    }
    return self;
}
- (void)makeUserInterface{
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo([NSNumber numberWithFloat:ImageEditBottomBarHei]);
    }];
    
    [self addSubview:self.SliderView];
    [self.SliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.height.mas_equalTo(@100);
    }];
}
- (FSImageEditBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[FSImageEditBottomView alloc] initWithFristTitle:NSLocalizedString(@"Cancel", nil) AndSencondTitle:NSLocalizedString(@"Confirm", nil)];
        _bottomView.FilterBtn.selected = NO;
        _bottomView.adjustmentBtn.selected = NO;
        _bottomView.delegate =self;
        
    }
    return _bottomView;
}

- (FSRegulateSliderView *)SliderView{
    if (!_SliderView) {
        _SliderView = [[FSRegulateSliderView alloc] init];
        _SliderView.delegate =self;
    }
    return _SliderView;
}
#pragma mark FSImageEditBottomViewDelegate
- (void)FSImageEditBottomViewChooseWithIndex:(NSInteger)index{
    if (index == 0) {
        [self.RegulateBottomViewDelegate FSFSImageRegulateBottomViewCancel];
    }
    else{
        [self.RegulateBottomViewDelegate FSFSImageRegulateBottomViewConfirm];
    }
}

#pragma mark FSRegulateSliderViewDelegate
-(void)FSRegulateSliderViewSliderValueChangeWithValue:(CGFloat)value{
    
    [self.RegulateBottomViewDelegate FSFSImageRegulateBottomViewSliderValuechange:value];
}
@end
