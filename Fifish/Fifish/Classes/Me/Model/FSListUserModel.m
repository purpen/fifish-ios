//
//  FSListUserModel.m
//  Fifish
//
//  Created by THN-Dong on 16/9/20.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSListUserModel.h"
#import "MJExtension.h"

@implementation FSListUserModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             
             @"userId" : @"follower.id",
             @"userName" : @"follower.username",
             @"summary" : @"follower.summary",
             @"userHeadImage" : @"follower.avatar.large",
             @"followFlag" : @"is_follow"
             
             };
}

@end
