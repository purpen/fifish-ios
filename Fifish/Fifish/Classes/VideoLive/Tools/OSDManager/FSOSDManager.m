//
//  FSOSDManager.m
//  Fifish
//
//  Created by macpro on 16/9/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSOSDManager.h"

#import "SVProgressHUD.h"

#import "GCDAsyncSocket.h"

#import "RovInfo.h"



NSString * const Fish_OSD_Host = @"192.168.2.222";
NSInteger  const Fish_OSD_Port = 4321;

@interface FSOSDManager()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket * OSDConnectSocket;

@end


@implementation FSOSDManager

+(FSOSDManager *)sharedManager{
    static dispatch_once_t predicate;
    static FSOSDManager * sharedManager;
    dispatch_once(&predicate, ^{
        sharedManager=[[FSOSDManager alloc] init];
    });
    return sharedManager;
}

- (void)starConnectWithOSD{
    NSError * error;
    [self.OSDConnectSocket connectToHost:Fish_OSD_Host onPort:Fish_OSD_Port error:&error];
    if (error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:error.localizedDescription];
        });
        
    }
    else{
        [self.OSDConnectSocket readDataWithTimeout:3 tag:1];
        [self.OSDConnectSocket writeData:[@"app_connect" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:1];
    }
}
- (void)stopConnectWithOSD{
    if ([self.OSDConnectSocket isConnected]) {
        [self.OSDConnectSocket setDelegate:nil];
        [self.OSDConnectSocket disconnect];
    }
}
- (GCDAsyncSocket *)OSDConnectSocket{
    if (!_OSDConnectSocket) {
        dispatch_queue_t scoketQueue = dispatch_queue_create("OSDScoket queue", NULL);
        _OSDConnectSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:scoketQueue];
    }
    if (!self.delegate) {
        _OSDConnectSocket.delegate = self;
    }
    return _OSDConnectSocket;
}





#pragma mark - 代理方法表示连接成功/失败 回调函数
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功");
    if ([self.delegate respondsToSelector:@selector(connectWithOSDsuccess)]) {
        [self.delegate connectWithOSDsuccess];
    }
    // 等待数据来啊
    if ([sock.connectedHost isEqualToString:Fish_OSD_Host]) {
        [sock readDataWithTimeout:-1 tag:200];
    }

}

// 如果对象关闭了 这里也会调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"连接失败 %@", err.localizedDescription);
    if ([self.delegate respondsToSelector:@selector(connectWithOSDerror:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate connectWithOSDerror:err];
        });
    }
    // 断线重连
    if ([sock.connectedHost isEqualToString:Fish_OSD_Host]) {
        [sock connectToHost:Fish_OSD_Host onPort:Fish_OSD_Port withTimeout:-1 error:nil];
    }
}
#pragma mark - 消息发送成功 代理函数
- (void)sendMessage:(NSString *)message{
    [self.OSDConnectSocket writeData:[message dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:1];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"消息发送成功");
}
//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//    NSLog(@"%@",data);
    if ([sock.connectedHost isEqualToString:Fish_OSD_Host]) {
        [[RovInfo sharedManager] updataWithRovDataInfo:data];
    }
    [sock readDataWithTimeout:-1 tag:200];
}
@end
