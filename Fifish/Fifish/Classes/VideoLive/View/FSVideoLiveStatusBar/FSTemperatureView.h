//
//  FSTemperatureView.h
//  Fifish
//
//  Created by macpro on 16/8/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseView.h"
@interface FSTemperatureView : FSBaseView
//温度
@property (nonatomic , assign) NSString * Tempera;

//根据温度单位的选项刷新UI
- (void)updateUI;
@end
