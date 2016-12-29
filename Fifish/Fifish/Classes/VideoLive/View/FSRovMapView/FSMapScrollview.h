//
//  FSMapScrollview.h
//  Fifish
//
//  Created by macpro on 16/12/27.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSMapScrollview : UIScrollView


/**
 坐标数组
 */
@property (nonatomic , strong) NSMutableArray * pointArrs;

//添加坐标点
- (void)Addpoints:(CGPoint)point;

/**
 根据角度个距离添加坐标点

 @param currentAngle 当前角度
 @param distence 相对于上一次数据传过来的距离差
 */
- (void)addPointWithCurrentAngel:(CGFloat)currentAngle distence:(CGFloat)distence;

@end
