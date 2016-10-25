//
//  FSRulersScrollView.h
//  Fifish
//
//  Created by macpro on 16/9/2.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveVideoMacro.h"
typedef enum : NSUInteger {
    RulerLeftType,//左侧
    RulerRightType,//右侧
    RulerVorizontalType,//水平
} RulerType;
@interface FSRulersScrollView : UIScrollView
/**
 *  @author MC
 *
 *  初始化方法
 *
 *  @param minvalue 坐标最大值
 *  @param maxvalue 最小值
 *  @param stpe     间隔
 *  @param frame    大小
 *
 *  @return self
 */
-(instancetype)initWithMinValue:(CGFloat)minvalue WithMaxValue:(CGFloat)maxvalue WithStpe:(CGFloat)stpe WithFrame:(CGRect)frame WithRulerType:(RulerType) type;

@property (nonatomic) CGFloat   stpe;

@end
