//
//  FSOSDManager.h
//  Fifish
//
//  Created by macpro on 16/9/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSOSDManager : NSObject

+ (FSOSDManager *)sharedManager;

//开始连接
- (void)starConnectWithOSD;

@end
