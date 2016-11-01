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
             @"avatar_small" : @"user.avatar.small",
             @"avatar_large" : @"user.avatar.large",
             @"width" : @"cover.width",
             @"height" : @"cover.height",
             @"file_small" : @"cover.file.small",
             @"file_large" : @"cover.file.large",
             @"srcfile" : @"cover.file.srcfile",
             @"filepath" : @"cover.filepath",
             @"duration" : @"cover.duration"
             };
}


@end
