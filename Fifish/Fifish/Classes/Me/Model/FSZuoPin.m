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
             @"userId" : @"user.id",
             @"username" : @"user.username",
             @"avatar_url" : @"user.avatar.small",
             @"width" : @"photo.width",
             @"height" : @"photo.height",
             @"file_small" : @"photo.file.small"
             };
}


@end
