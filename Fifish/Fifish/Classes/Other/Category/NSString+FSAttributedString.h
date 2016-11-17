//
//  NSString+FSAttributedString.h
//  Fifish
//
//  Created by THN-Dong on 2016/11/17.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FSAttributedString)

/**
 * 设置段落样式
 * 
 *  行高
 *  字体颜色
 *  字体
 
 *   return 富文本
 */
-(NSAttributedString*)stringWithParagraphlineSpeace:(CGFloat)lineSpacing textColor:(UIColor*)textcolor textFont:(UIFont*)font;

/**
 * 设置段落样式(后四个字符隐藏的)
 *
 *  行高
 *  字体颜色
 *  字体
 
 *   return 富文本
 */
-(NSAttributedString*)stringHideLastFourWithParagraphlineSpeace:(CGFloat)lineSpacing textColor:(UIColor*)textcolor textFont:(UIFont*)font;

/**
 * 计算富文本字体高度
 *
 *  行高
 *  字体
 *  字体所占宽度
 
 *   return 富文本
 */
-(CGFloat)getSpaceLabelHeightWithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width;

@end
