//
//  AreaModel.h
//  Fiu
//
//  Created by THN-Dong on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * name;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
