//
//  FSEncodingInfoModel.h
//  Fifish
//
//  Created by macpro on 16/9/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseModel.h"

typedef enum :NSUInteger{
    AV_VIDEO_BEGIN = 0,         // 00 -- invalid size
    AV_VIDEO_QCIF,              // 01 -- 176x144
    AV_VIDEO_QVGA,              // 02 -- 320x240
    AV_VIDEO_SIF,               // 03 -- 352x240
    AV_VIDEO_CIF,               // 04 -- 352x288
    AV_VIDEO_VGA,               // 05 -- 640x480
    AV_VIDEO_480P,              // 06 -- 720x480
    AV_VIDEO_480I,              // 07 -- 720x480 I
    AV_VIDEO_576P,              // 08 -- 720x576
    AV_VIDEO_576I,              // 09 -- 720x576 I
    AV_VIDEO_720P,              // 10 -- 1280x720
    AV_VIDEO_SXGA,              // 11 -- 1280x960
    AV_VIDEO_UXGA,              // 12 -- 1600x1200
    AV_VIDEO_1080P,             // 13 -- 1920x1080
    AV_VIDEO_3MP,               // 14 -- 2048x1536
    AV_VIDEO_INVALID,           // invalid size
    
    AV_VIDEO_EX_BEGIN = 100,     // video ex start
    AV_VIDEO_320_240,           // 101 320x240
    AV_VIDEO_352_288,           // 102 352x288
    AV_VIDEO_640_480,           // 103 640x480
    AV_VIDEO_720_480,           // 104 720x480
    AV_VIDEO_720_576,           // 105 720x576
    AV_VIDEO_800_600,           // 106 800x600
    AV_VIDEO_1024_768,          // 107 -- 1024x768
    AV_VIDEO_1280_720,          // 108 -- 1280x720
    AV_VIDEO_1280_960,          // 109 -- 1280x960
    AV_VIDEO_1280_1024,         // 110 -- 1280x1024
    AV_VIDEO_1280_1280,         // 111 -- 1280x1280
    AV_VIDEO_1920_1080,         // 112 -- 1920x1080 2MP
    AV_VIDEO_2048_1536,         // 113 -- 2048x1536 3MP
    AV_VIDEO_2048_2048,         // 114 -- 2048x2048
    AV_VIDEO_2560_1440,         // 115 -- 2560x1440
    AV_VIDEO_2688_1512,         // 116 -- 2688x1512 4MP
    AV_VIDEO_2592_1944,         // 117 -- 2592x1944 5MP
    AV_VIDEO_3072_2048,         // 118 -- 3072x2048 6MP
    AV_VIDEO_3840_2160,         // 119 -- 3840x2160 8MP
    AV_VIDEO_4000_3000,         // 119 -- 3840x2160 8MP
    AV_VIDEO_EX_END,            // video ex end

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
