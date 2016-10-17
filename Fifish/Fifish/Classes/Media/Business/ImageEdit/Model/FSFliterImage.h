//
//  FSFliterImage.h
//  Fifish
//
//  Created by macpro on 16/10/13.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSFliterImage : NSObject
/**
 亮度             -1 - 0 - 1
 */
@property (nonatomic) CGFloat  lightValue;

/**
 对比度            0.0 - 1.0 - 4,
 */
@property (nonatomic) CGFloat  contrastValue;

/**
 饱和度            0.0 - 1.0 - 2.0
 */
@property (nonatomic) CGFloat  staurationValue;

/**
 锐度             -4.0 - 0 - 4.0
 */
@property (nonatomic) CGFloat  sharpnessValue;

/**
 色温             1000 - 5000 - 10000
 */
@property (nonatomic) CGFloat  colorTemperatureValue;

@property (nonatomic , copy) UIImage * image;

- (void)updataParamsWithIndex:(NSInteger)type WithValue:(CGFloat)value;


@end
