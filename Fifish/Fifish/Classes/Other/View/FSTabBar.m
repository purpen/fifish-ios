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
#import "FSEquipmentViewController.h"
#import "FSNavigationViewController.h"

@interface FSTabBar()

/** 设备按钮 */
@property (nonatomic, strong) UIButton *equipmentBtn;
/**  */
@property (nonatomic, strong) UILabel *equipmentLabel;

@end

@implementation FSTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
        
    }
    return self;
}

-(UILabel *)equipmentLabel{
    if (!_equipmentLabel) {
        _equipmentLabel = [[UILabel alloc] init];
        _equipmentLabel.text = NSLocalizedString(@"equipment", nil);
        _equipmentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _equipmentLabel.font = [UIFont systemFontOfSize:12];
        _equipmentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _equipmentLabel;
}

-(UIButton *)equipmentBtn{
    if (!_equipmentBtn) {
        _equipmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_equipmentBtn setImage:[UIImage imageNamed:@"equipment"] forState:(UIControlStateNormal)];
        [_equipmentBtn setImage:[UIImage imageNamed:@"equipment"] forState:(UIControlStateHighlighted)];
        [_equipmentBtn addTarget:self action:@selector(equipmentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _equipmentBtn.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8" alpha:0.9];
    }
    return _equipmentBtn;
}

/**
 *  点击设备按钮
 */
-(void)equipmentBtnClick{
    FSEquipmentViewController *vc = [[FSEquipmentViewController alloc] init];
    FSNavigationViewController *navi = [[FSNavigationViewController alloc] initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = width / (self.items.count + 1);
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIControl *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.equipmentBtn) continue;
        
        // 计算按钮的x值
        buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;
    }
    
    
    self.equipmentLabel.frame = CGRectMake(0, 0, 70, 12);
    self.equipmentLabel.center = CGPointMake(width * 0.5, height * 0.87 - 2);
    
    self.equipmentBtn.frame = CGRectMake(buttonX, buttonY, 50, 50);
    self.equipmentBtn.layer.cornerRadius = 50 / 2;
    self.equipmentBtn.center = CGPointMake(width * 0.5, height * 0.25);
    
    [self addSubview:self.equipmentBtn];
    [self addSubview:self.equipmentLabel];
}


@end
