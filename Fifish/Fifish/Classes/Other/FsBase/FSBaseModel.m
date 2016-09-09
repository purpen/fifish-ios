//
//  FSBaseModel.m
//  Fifish
//
//  Created by macpro on 16/9/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseModel.h"

@implementation FSBaseModel
- (id)initWithDictory:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
