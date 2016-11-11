//
//  FSRecivedPrasiedModel.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRecivedPrasiedModel.h"
#import "MJExtension.h"

@implementation FSRecivedPrasiedModel

+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{
             @"avatar_large" : @"sender.avatar.large",
             @"username" : @"sender.username",
             @"stuff_kind" : @"stuff.kind",
             @"comment_on_time" : @"created_at",
             @"file_large" : @"stuff.cover.file.large",
             @"userId" : @"sender.id",
             @"stuffId" : @"stuff.id"
             };
}

@end
