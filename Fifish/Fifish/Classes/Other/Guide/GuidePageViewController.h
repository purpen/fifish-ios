//
//  GuidePageViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    shouYe = 1,
    welcomePage = 0
} LanchFlag;

@interface GuidePageViewController : UIViewController

/** 标识 */
@property (nonatomic, assign) LanchFlag flag;

-(instancetype)initWithPicArr:(NSArray*)picArr andRootVC:(UIViewController*)controller;


@end
