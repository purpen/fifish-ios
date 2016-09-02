//
//  AreaModel.m
//  Fiu
//
//  Created by THN-Dong on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.idField = [dictionary[@"_id"] integerValue];
    }
    if(![dictionary[@"city"] isKindOfClass:[NSNull class]]){
        self.name = dictionary[@"city"];
    }
    
    return self;
}
@end
