//
//  FSUserModel.m
//  Fifish
//
//  Created by THN-Dong on 16/9/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSUserModel.h"
#import "MJExtension.h"

@implementation FSUserModel


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"userId" : @"_id"
             };
}

@end
