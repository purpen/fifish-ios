//
//  FSHeadImageModel.m
//  Fifish
//
//  Created by THN-Dong on 16/9/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHeadImageModel.h"

@implementation FSHeadImageModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    
    if(![dict[@"small"] isKindOfClass:[NSNull class]]){
        self.small = dict[@"small"];
    }
    
    if(![dict[@"large"] isKindOfClass:[NSNull class]]){
        self.large = dict[@"large"];
    }
    
    return self;
    
}

@end
