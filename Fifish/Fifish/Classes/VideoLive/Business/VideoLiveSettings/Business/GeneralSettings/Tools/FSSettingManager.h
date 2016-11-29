//
//  FSSettingManager.h
//  Fifish
//
//  Created by macpro on 16/11/29.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSSettingManager : NSObject

/**
 获取深度单位。0为英尺，1为米

 @return 深度单位类型
 */
+ (NSInteger)getDeepUnit;

/**
 获取温度单位 0为摄氏度，1为华氏度

 @return 
 */
+ (NSInteger)GetTemperatureUnit;

/**
 设置深度单位
 */
+ (void)setDeepUnit:(NSInteger)unit;

/**
 设置温度单位
 */
+ (void)setTemperatureUnit:(NSInteger)unit;
@end
