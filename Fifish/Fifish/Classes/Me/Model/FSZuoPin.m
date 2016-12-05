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

+ (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}

// 将字典或者数组转化为JSON串
+ (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] != 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}


@end
