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
             @"large" : @"avatar.large"
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(![dictionary[@"account"] isKindOfClass:[NSNull class]]){
        self.account = dictionary[@"account"];
    }
    
    if(![dictionary[@"zone"] isKindOfClass:[NSNull class]]){
        self.zone = dictionary[@"zone"];
    }
    
    if(![dictionary[@"summary"] isKindOfClass:[NSNull class]]){
        self.summary = dictionary[@"summary"];
    }
    
    if(![dictionary[@"id"] isKindOfClass:[NSNull class]]){
        self.userId = dictionary[@"id"];
    }
    
    if(![dictionary[@"stuff_count"] isKindOfClass:[NSNull class]]){
        self.stuff_count = dictionary[@"stuff_count"];
    }
    
    if(![dictionary[@"fans_count"] isKindOfClass:[NSNull class]]){
        self.fans_count = dictionary[@"fans_count"];
    }
    
    if(![dictionary[@"follow_count"] isKindOfClass:[NSNull class]]){
        self.follow_count = dictionary[@"follow_count"];
    }
    
    if(![dictionary[@"username"] isKindOfClass:[NSNull class]]){
        self.username = dictionary[@"username"];
    }
    
    if(![dictionary[@"like_count"] isKindOfClass:[NSNull class]]){
        self.like_count = dictionary[@"like_count"];
    }
    
    if(![dictionary[@"job"] isKindOfClass:[NSNull class]]){
        self.job = dictionary[@"job"];
    }
    
    if(![dictionary[@"avatar"] isKindOfClass:[NSNull class]]){
        self.avatar = [[FSHeadImageModel alloc] initWithDictionary:dictionary[@"avatar"]];
    }
    
    return self;
}

@end
