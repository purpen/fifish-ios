//
//  VideoLiveController.m
//  Fifish
//
//  Created by macpro on 16/8/15.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "VideoLiveController.h"
#import "FSTabBarController.h"
#import "FifishH264Decoder.h"
@interface VideoLiveController()<updataYUV_420FrameDelegate>

@property (nonatomic, strong)FifishH264Decoder * ViedoDecoder;

@end
@implementation VideoLiveController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self DecodeWithUrl];
}
- (void)DecodeWithUrl{
    [self.ViedoDecoder StardecodeFrame];
}
- (FifishH264Decoder *)ViedoDecoder{
    if (!_ViedoDecoder) {
        _ViedoDecoder  = [[FifishH264Decoder alloc] initWithUrl:@"rtsp://admin:admin@192.168.2.158:554/channel1/2"];
        _ViedoDecoder.UpdataDelegate = self;
    }
    return _ViedoDecoder;
}
- (void)updateH264FrameData:(YUV420Frame *)yuvFrame{
    NSLog(@"%d",yuvFrame->width);
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}
@end
