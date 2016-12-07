//
//  NSString+FSAttributedString.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/17.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "NSString+FSAttributedString.h"

@implementation NSString (FSAttributedString)

-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing textColor:(UIColor *)textcolor textFont:(UIFont *)font andIsAll:(BOOL)flag{
    //设置段落
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = flag ? 4 : lineSpacing;
    
    //NSKernAttributeName 字体间距
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSKernAttributeName : @(0.5f),
                                 NSForegroundColorAttributeName : textcolor,
                                 NSFontAttributeName : font
                                 };
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    return attriStr;
}

-(NSAttributedString *)stringHideLastFourWithParagraphlineSpeace:(CGFloat)lineSpacing textColor:(UIColor *)textcolor textFont:(UIFont *)font{
    NSUInteger n = 0;
    NSInteger m = 0;
    if (SCREEN_HEIGHT == 667.0) {
        if (self.length <= 70) {
            n = 0;
            m = 0;
        } else if (self.length >= 74) {
            m = 4;
            n = 54 - m;
        } else {
            n = 70;
            m = self.length - n;
        }
    } else if (SCREEN_HEIGHT == 736.0) {
        if (self.length <= 52) {
            n = 0;
            m = 0;
        } else if (self.length >= 56) {
            m = 4;
            n = 56 - m;
        } else {
            n = 52;
            m = self.length - n;
        }
    } else {
        if (self.length <= 53) {
            n = 0;
            m = 0;
        } else if (self.length >= 57) {
            m = 4;
            n = 57 - m;
        } else {
            n = 53;
            m = self.length - n;
        }
    }
    //设置段落
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    //NSKernAttributeName 字体间距
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSKernAttributeName : @(0.5f),
                                 NSForegroundColorAttributeName : textcolor,
                                 NSFontAttributeName : font
                                 };
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    if (n) {
        [attriStr addAttribute:NSForegroundColorAttributeName
         
                         value:[UIColor whiteColor]
         
                         range:NSMakeRange(n, m)];
    }
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
