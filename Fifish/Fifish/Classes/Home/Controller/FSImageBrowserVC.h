//
//  FSImageBrowserVC.h
//  Fifish
//
//  Created by THN-Dong on 2016/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  图片浏览器
 */
@interface FSImageBrowserVC : UIViewController

/** 消失的时候是否启动缩放动画 */
@property (nonatomic, assign) BOOL isScalingToHide;
/** 是否显示页码 */
@property (nonatomic, assign) BOOL isShowPageControl;

/**
 *  构造方法
 *
 *
 *
 *
 *
 */
-(instancetype)initWithImageBrowserModels:(NSArray*)imageModels
                             currentIndex:(NSInteger)index;


/**
 *  显示图片浏览器
 */
-(void)show;

@end
