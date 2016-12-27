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

@end
