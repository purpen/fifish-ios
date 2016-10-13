//
//  FSRegulateSliderView.h
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseView.h"
@class FSFliterImage;
@protocol FSRegulateSliderViewDelegate <NSObject>

- (void)FSRegulateSliderViewSliderValueChangeWithValue:(CGFloat)value;


@end

@interface FSRegulateSliderView : FSBaseView




@property (nonatomic,assign)id<FSRegulateSliderViewDelegate>delegate;

@property (nonatomic)   CGFloat sliderCurrentValue;

//- (void)setSliederMinValue:(CGFloat)min MaxValue:(CGFloat)Max CurrentValue:(CGFloat)current;
- (void)setSliederWithType:(NSInteger)type AndImage:(FSFliterImage *)fsimage;
@end
