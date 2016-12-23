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

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userId" : @"id",
             @"small" : @"avatar.small",
             @"large" : @"avatar.large",
             @"gender" : @"sex",
             @"followFlag" : @"is_follow"
             };
}

//-(instancetype)init{
//    if (self = [super init]) {
//        int value = (arc4random() % 10) + 1;
//        NSString *str = [NSString stringWithFormat:@"me_bg_large%d",1];
//        self.imageStr = str;
//    }
//    return self;
//}

@end
