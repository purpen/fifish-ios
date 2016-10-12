//
//  FSRegulateSliderView.h
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseView.h"

@protocol FSRegulateSliderViewDelegate <NSObject>

- (void)FSRegulateSliderViewSliderValueChangeWithValue:(CGFloat)value;


@end

@interface FSRegulateSliderView : FSBaseView
@property (nonatomic,strong)UISlider * MainSlider;

@property (nonatomic,assign)id<FSRegulateSliderViewDelegate>delegate;

@end
