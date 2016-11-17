//
//  NSString+FSAttributedString.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/17.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "NSString+FSAttributedString.h"

@implementation NSString (FSAttributedString)

-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing textColor:(UIColor *)textcolor textFont:(UIFont *)font{
    //设置段落
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    //NSKernAttributeName 字体间距
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSKernAttributeName : @(0.5f)
                                 };
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    NSDictionary *attriBute = @{
                                NSForegroundColorAttributeName : textcolor,
                                NSFontAttributeName : font
                                };
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    return attriStr;
}

-(NSAttributedString *)stringHideLastFourWithParagraphlineSpeace:(CGFloat)lineSpacing textColor:(UIColor *)textcolor textFont:(UIFont *)font{
    //设置段落
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    //NSKernAttributeName 字体间距
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSKernAttributeName : @(0.5f)
                                 };
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    NSDictionary *attriBute = @{
                                NSForegroundColorAttributeName : textcolor,
                                NSFontAttributeName : font
                                };
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    [attriStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor whiteColor]
     
                          range:NSMakeRange(69 - 5, 5)];
    return attriStr;
}

-(CGFloat)getSpaceLabelHeightWithSpeace:(CGFloat)lineSpeace withFont:(UIFont *)font withWidth:(CGFloat)width{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpeace;
    NSDictionary *dic = @{
                          NSFontAttributeName : font,
                          NSParagraphStyleAttributeName : paraStyle,
                          NSKernAttributeName : @(0.5f)
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
