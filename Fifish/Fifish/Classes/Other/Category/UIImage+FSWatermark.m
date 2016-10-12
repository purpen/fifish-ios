//
//  UIImage+FSWatermark.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "UIImage+FSWatermark.h"

@implementation UIImage (FSWatermark)

-(UIImage *)watermarkImage:(NSString *)text{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //
    CGRect rect = CGRectMake(0, self.size.height-30, self.size.width - 10, 20);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentRight;
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:12],
                           NSParagraphStyleAttributeName:style,
                           NSForegroundColorAttributeName:[UIColor whiteColor],
                           };
    [text drawInRect:rect withAttributes:dict];
    //
    CGRect rect2 = CGRectMake(0, self.size.height-50, self.size.width - 10, 20);
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style2.alignment = NSTextAlignmentRight;
    NSDictionary *dict2 = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:13],
                           NSParagraphStyleAttributeName:style2,
                           NSForegroundColorAttributeName:[UIColor whiteColor],
                           };
    [@"FiFish" drawInRect:rect2 withAttributes:dict2];
    //
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return watermarkImage;
}

@end
