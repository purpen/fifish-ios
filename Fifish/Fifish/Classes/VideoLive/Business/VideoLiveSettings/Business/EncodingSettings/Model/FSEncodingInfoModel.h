//
//  FSEncodingInfoModel.h
//  Fifish
//
//  Created by macpro on 16/9/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseModel.h"

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


@property (nonatomic , strong) NSString * VideoSize;

@end
