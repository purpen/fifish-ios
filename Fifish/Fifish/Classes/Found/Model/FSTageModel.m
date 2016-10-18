//
//  FSTageModel.m
//  Fifish
//
//  Created by THN-Dong on 16/9/21.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTageModel.h"
#import "MJExtension.h"

@implementation FSTageModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"tagId" : @"id",
             @"cover" : @"cover.file.small"
             };
}

@end
