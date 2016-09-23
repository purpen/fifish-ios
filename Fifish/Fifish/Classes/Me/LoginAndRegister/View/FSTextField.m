//
//  FSTextField.m
//  Fifish
//
//  Created by THN-Dong on 16/7/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTextField.h"

static NSString * const FSPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation FSTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    // 不成为第一响应者
    [self resignFirstResponder];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:self.textColor forKeyPath:FSPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor whiteColor] forKeyPath:FSPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}

@end
