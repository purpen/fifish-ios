//
//  FishBaseViewController.h
//  Fifish
//
//  Created by macpro on 16/8/15.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSConst.h"
#import "SVProgressHUD.h"
#import "Masonry.h"
@interface FishBaseViewController : UIViewController

@property (nonatomic,strong) UIButton * NavLeftBtn;

@property (nonatomic,strong) UIButton * NavRightBtn;

//返回
- (void)NavBack;

//设置左边导航
- (void)setDefaultLeftNav;

- (void)setRightItem:(UIView *)view;

- (void)setLeftItem:(UIView *)view;

//设置导航
- (void)setNavWithView:(UIView *)view;

//设置导航背景颜色
- (void)setNavBackColor:(UIColor *)backColor;

@end
