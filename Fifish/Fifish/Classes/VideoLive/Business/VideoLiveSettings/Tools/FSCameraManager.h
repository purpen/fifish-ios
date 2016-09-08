//
//  FSCameraManager.h
//  Fifish
//
//  Created by macpro on 16/9/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^RequestSuccessBlock)(NSDictionary * responseObject);
typedef void(^RequestFailureBlock)(NSError * error);


@interface FSCameraManager : NSObject
- (instancetype)init;

- (void)getCameraInfoWithSuccessBlock:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock;


@end
