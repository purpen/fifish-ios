//
//  FSTagModel.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTagModel.h"
#import "MJExtension.h"

@implementation FSTagModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"tagId" : @"id"
             };
}

@end
