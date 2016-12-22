//
//  FifishH264Decoder.h
//  FFNativeDemo
//
//  Created by macpro on 16/8/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//
/*
 *
 *
 *  工程中爆黄的问题是因为老的方法和结构体即将废弃。用的库太新，没有更换新方法
 *
 *
 */
#import <Foundation/Foundation.h>
#import "FifishYUV420Data.h"
@protocol updataYUV_420FrameDelegate <NSObject>

@optional
/**
 *  @author MC
 *
 *  活的解码完的yuv数据,刷新方法
 *
 *  @param yuvFrame 一帧yuv数据
 */
- (void)updateH264FrameData:(YUV420Frame *)yuvFrame;

@end

@interface FifishH264Decoder : NSObject

@property (nonatomic, assign)id<updataYUV_420FrameDelegate> UpdataDelegate;

@property (nonatomic, assign) int   width;

@property (nonatomic, assign) int   height;

@property (nonatomic ,assign)BOOL       isRunningDecode;//解码状态记录

//输出地址
@property (nonatomic ,assign,readonly)NSString * OutputMp4FileUrl;

- (instancetype)initWithUrl:(NSString *)Url;



//开始解码
- (void)StardecodeFrame;

- (NSInteger)initWithInputUrl;

- (NSInteger) initDecodec;

@end
