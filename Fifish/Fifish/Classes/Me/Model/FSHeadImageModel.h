//
//  FSHeadImageModel.h
//  Fifish
//
//  Created by THN-Dong on 16/9/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSHeadImageModel : NSObject

/**  */
@property(nonatomic,copy) NSString *small;
/**  */
@property(nonatomic,copy) NSString *large;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
