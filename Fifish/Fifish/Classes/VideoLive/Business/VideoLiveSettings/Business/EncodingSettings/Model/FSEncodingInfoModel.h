//
//  FSEncodingInfoModel.h
//  Fifish
//
//  Created by macpro on 16/9/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseModel.h"

typedef enum :NSUInteger{
    AV_VIDEO_QSIF = 0,             // 176 x 120
    AV_VIDEO_QCIF,                // 176 x 144
    AV_VIDEO_QVGA,                // 320 x 240
    AV_VIDEO_SIF,                // 352 x 240
    AV_VIDEO_CIF,               // 352 x 288
    AV_VIDEO_VGA,               // 640 x 480
    AV_VIDEO_480P,              // 720 x 480
    AV_VIDEO_576P,              // 720 x 576
    AV_VIDEO_720P,              // 1280 x 720
    AV_VIDEO_SXGA,              // 1280 x 960
    AV_VIDEO_UXGA,              // 1600 x 1200
    AV_VIDEO_1080P,             // 1920 x 1080
    AV_VIDEO_INVALID,           // invalid size
} AV_VIDEO_SIZE;

@interface FSEncodingInfoModel : FSBaseModel
@property (nonatomic , strong) NSString * VideoFramerate;

@property (nonatomic , strong) NSString * VideoEncodeFormat;

@property (nonatomic , strong) NSString * H264Profiles;

@property (nonatomic , strong) NSString * VideoGop;

@property (nonatomic , strong) NSString * VideoBitrateCtrlMode;

@property (nonatomic , strong) NSString * VideoCBRBitrate;

@property (nonatomic , strong) NSString * VideoQuality;

@property (nonatomic , strong) NSString * VideoVBRMaxBitrate;


@property (nonatomic , strong) NSString * StreamId;

@property (nonatomic , strong) NSString * VideoVBRMinBitrate;


@property (nonatomic) AV_VIDEO_SIZE  VideoSize;

@property (nonatomic , strong) NSString * VideoSizeStr;

@end
