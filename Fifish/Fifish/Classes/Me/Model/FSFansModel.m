//
//  FSFansModel.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFansModel.h"
#import "MJExtension.h"

@implementation FSFansModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             
             @"userId" : @"user.id",
             @"userName" : @"user.username",
             @"summary" : @"user.summary",
             @"userHeadImage" : @"user.avatar.large",
             @"followFlag" : @"is_follow"
             
             };
}

@end
