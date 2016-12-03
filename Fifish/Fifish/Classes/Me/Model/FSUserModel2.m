//
//  FSUserModel2.m
//  Fifish
//
//  Created by THN-Dong on 2016/12/2.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSUserModel2.h"
#import "MJExtension.h"

@implementation FSUserModel2

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userId" : @"id",
             @"small" : @"avatar.small",
             @"large" : @"avatar.large",
             @"gender" : @"sex",
             @"followFlag" : @"is_follow"
             };
}


@end
