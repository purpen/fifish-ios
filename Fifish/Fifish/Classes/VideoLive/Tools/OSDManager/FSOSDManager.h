//
//  FSOSDManager.h
//  Fifish
//
//  Created by macpro on 16/9/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FSOSDMannagrDelegate <NSObject>

- (void)connectWithOSDsuccess;
- (void)connectWithOSDerror:(NSError *)error;


@end

@interface FSOSDManager : NSObject

@property (nonatomic,assign)id<FSOSDMannagrDelegate>delegate;


+ (FSOSDManager *)sharedManager;

//开始连接
- (void)starConnectWithOSD;


//断开连接
- (void)stopConnectWithOSD;

//发送消息
- (void)sendMessage:(NSString *)message;

@end
