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
            case AV_VIDEO_QSIF :
            {
                self.VideoSizeStr = @"176x120";
            }
                break;
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
            case AV_VIDEO_576P :
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
            case AV_VIDEO_INVALID :
            {
                self.VideoSizeStr = @"Unknow";
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
