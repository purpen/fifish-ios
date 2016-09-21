//
//  FSZuoPin.m
//  Fifish
//
//  Created by THN-Dong on 16/8/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSZuoPin.h"
#import "FSConst.h"
#import "MJExtension.h"

@implementation FSZuoPin

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"idFeild" : @"id",
             @"fileurl" : @"photo.fileurl",
             @"width" : @"photo.width",
             @"height" : @"photo.height"
             };
}

-(CGFloat)cellHeight{
    
    _cellHeight = [self.height floatValue] / ([self.width floatValue] / [UIScreen mainScreen].bounds.size.width);
    return _cellHeight;
    
}

@end
