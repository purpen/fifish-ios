//
//  FSEncodingInfoModel.m
//  Fifish
//
//  Created by macpro on 16/9/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSEncodingInfoModel.h"

@implementation FSEncodingInfoModel
- (id)initWithDictory:(NSDictionary *)dic{
    self = [super initWithDictory:dic];
    if (self) {
        switch (self.VideoSize) {
            case AV_VIDEO_QCIF :
            {
                self.VideoSizeStr = @"176x144";
            }
                break;
            case AV_VIDEO_QVGA :
            {
                self.VideoSizeStr = @"320x240";
            }
                break;
            case AV_VIDEO_SIF :
            {
                self.VideoSizeStr = @"352x240";
            }
                break;
            case AV_VIDEO_CIF :
            {
                self.VideoSizeStr = @"352x288";
            }
                break;
            case AV_VIDEO_VGA :
            {
                self.VideoSizeStr = @"640x480";
            }
                break;
            case AV_VIDEO_480P :
            {
                self.VideoSizeStr = @"720x480";
            }
                break;
            case AV_VIDEO_480I :
            {
                self.VideoSizeStr = @"720x480";
            }
                break;
            case AV_VIDEO_576P :
            {
                self.VideoSizeStr = @"720 x 576";
            }
                break;
            case AV_VIDEO_576I :
            {
                self.VideoSizeStr = @"720 x 576";
            }
                break;
            case AV_VIDEO_720P :
            {
                self.VideoSizeStr = @"1280 x 720";
            }
                break;
            case AV_VIDEO_SXGA :
            {
                self.VideoSizeStr = @"1280 x 960";
            }
                break;
            case AV_VIDEO_UXGA :
            {
                self.VideoSizeStr = @"1600 x 1200";
            }
                break;
            case AV_VIDEO_1080P :
            {
                self.VideoSizeStr = @"1920 x 1080";
            }
                break;
            case AV_VIDEO_3MP :
            {
                self.VideoSizeStr = @"2048x1536";
            }
                break;
            case AV_VIDEO_INVALID :
            {
                self.VideoSizeStr = @"Unknow";
            }
                break;
            case AV_VIDEO_320_240 :
            {
                self.VideoSizeStr = @"320x240";
            }
                break;
            case AV_VIDEO_352_288 :
            {
                self.VideoSizeStr = @"352x288";
            }
                break;
            case AV_VIDEO_640_480 :
            {
                self.VideoSizeStr = @"640x480";
            }
                break;
            case AV_VIDEO_720_480 :
            {
                self.VideoSizeStr = @"720x480";
            }
                break;
            case AV_VIDEO_720_576 :
            {
                self.VideoSizeStr = @"720x576";
            }
                break;
            case AV_VIDEO_800_600 :
            {
                self.VideoSizeStr = @"800x600";
            }
                break;
            case AV_VIDEO_1024_768 :
            {
                self.VideoSizeStr = @"1024x768";
            }
                break;
            case AV_VIDEO_1280_720 :
            {
                self.VideoSizeStr = @"1280x720";
            }
                break;
            case AV_VIDEO_1280_960 :
            {
                self.VideoSizeStr = @"1280x960";
            }
                break;
            case AV_VIDEO_1280_1024 :
            {
                self.VideoSizeStr = @"1280x1024";
            }
                break;
            case AV_VIDEO_1280_1280 :
            {
                self.VideoSizeStr = @"1280x1280";
            }
                break;
            case AV_VIDEO_1920_1080 :
            {
                self.VideoSizeStr = @"1920x1080";
            }
                break;
            case AV_VIDEO_2048_1536 :
            {
                self.VideoSizeStr = @"2048x1536";
            }
                break;
            case AV_VIDEO_2048_2048 :
            {
                self.VideoSizeStr = @"2048x2048";
            }
                break;
            case AV_VIDEO_2560_1440 :
            {
                self.VideoSizeStr = @"2560x1440";
            }
                break;
            case AV_VIDEO_2592_1944 :
            {
                self.VideoSizeStr = @"2592x1944";
            }
                break;
            case AV_VIDEO_3072_2048 :
            {
                self.VideoSizeStr = @"3072x2048";
            }
                break;
            case AV_VIDEO_3840_2160 :
            {
                self.VideoSizeStr = @"3840x2160";
            }
                break;
            case AV_VIDEO_4000_3000 :
            {
                self.VideoSizeStr = @"3840x2160";
            }
                break;
            default:
                self.VideoSizeStr = @"Unknow";
                break;
        }
    }
    return self;
}
@end
