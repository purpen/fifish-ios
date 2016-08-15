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
#import "OpenGLFrameView.h"
@interface VideoLiveController()<updataYUV_420FrameDelegate>

@property (nonatomic, strong)FifishH264Decoder * ViedoDecoder;

@property (nonatomic, strong)OpenGLFrameView   * VideoGlView;

@end
@implementation VideoLiveController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)dismissVC{
    self.ViedoDecoder.isRunningDecode = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [self.ViedoDecoder StardecodeFrame];
    [self AddVideoView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 50);
    [btn setTitle:@"FIFISH" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double deviceLevel = [UIDevice currentDevice].batteryLevel;
    
    
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    NSLog(@"%f",deviceLevel);
}

- (void)AddVideoView{ 
    [self.view addSubview:self.VideoGlView];
}
- (OpenGLFrameView *)VideoGlView{
    if (!_VideoGlView) {
        _VideoGlView = [[OpenGLFrameView alloc] initWithFrame:CGRectMake(0, 0,self.ViedoDecoder.width,self.ViedoDecoder.height)];
    }
    return _VideoGlView;
    
}
- (FifishH264Decoder *)ViedoDecoder{
    if (!_ViedoDecoder) {
        _ViedoDecoder  = [[FifishH264Decoder alloc] initWithUrl:@"rtsp://admin:admin@192.168.2.158:554/channel1/2"];
        _ViedoDecoder.UpdataDelegate = self;
    }
    return _ViedoDecoder;
}
- (void)updateH264FrameData:(YUV420Frame *)yuvFrame{
    [self.VideoGlView render:yuvFrame];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}
@end
