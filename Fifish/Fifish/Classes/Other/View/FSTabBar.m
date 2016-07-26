//
//  FSTabBar.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTabBar.h"
#import "UIView+FSExtension.h"
#import "FSConst.h"
#import "UIColor+FSExtension.h"

@interface FSTabBar()

/** 设备按钮 */
@property (nonatomic, weak) UIButton *equipmentBtn;
/**  */
@property (nonatomic, weak) UILabel *equipmentLabel;

@end

@implementation FSTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置tabbar的背景图片
        if (SCREEN_WIDTH <= 320) {
            self.backgroundImage = [UIImage imageNamed:@"tabBar_small"];
        } else {
            self.backgroundImage = [UIImage imageNamed:@"tabBar_long"];
        }
        
        // 添加发布按钮
        UIButton *equipmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [equipmentBtn setBackgroundImage:[UIImage imageNamed:@"equipment"] forState:UIControlStateNormal];
        [equipmentBtn setBackgroundImage:[UIImage imageNamed:@"equipment_selected"] forState:UIControlStateHighlighted];
        equipmentBtn.size = equipmentBtn.currentBackgroundImage.size;
        [self addSubview:equipmentBtn];
        self.equipmentBtn = equipmentBtn;
        
        UILabel *equipmentLabel = [[UILabel alloc] init];
        equipmentLabel.text = NSLocalizedString(@"equipment", nil);
        equipmentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        equipmentLabel.font = [UIFont systemFontOfSize:12];
        equipmentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:equipmentLabel];
        self.equipmentLabel = equipmentLabel;
        
        self.shadowImage = [UIImage new];
        self.translucent = YES;
    }
    return self;
}

/**
 *  点击设备按钮
 */
-(void)equipmentBtnClick{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 标记按钮是否已经添加过监听器
    static BOOL added = NO;
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // 设置发布按钮的frame
    self.equipmentBtn.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    self.equipmentLabel.frame = CGRectMake(0, 0, 70, 12);
    self.equipmentLabel.center = CGPointMake(width * 0.5, height * 0.87 - 2);
    for (UIControl *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.equipmentBtn) continue;
        
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;
        
        if (added == NO) {
            // 监听按钮点击
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if (SCREEN_WIDTH > 375) {
        self.equipmentBtn.center = CGPointMake(width * 0.5, height * 0.2);
    } else {
        self.equipmentBtn.center = CGPointMake(width * 0.5, height * 0.3);
    }
    
    added = YES;
}


- (void)buttonClick
{
    // 发出一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTabBarDidSelectNotification object:nil userInfo:nil];
}

@end
