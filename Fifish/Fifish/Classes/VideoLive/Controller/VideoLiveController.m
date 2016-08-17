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

//view
#import "OpenGLFrameView.h"
#import "FSFSVideoLiveStatusBar.h"
#import "FSVideoLiveBottomBar.h"
@interface VideoLiveController()<updataYUV_420FrameDelegate,FSVidoLiveStatusBarDelegate>

@property (nonatomic, strong)FifishH264Decoder * ViedoDecoder;//解码器


@property (nonatomic, strong)OpenGLFrameView   * VideoGlView;//videoview


@property (nonatomic, strong)FSFSVideoLiveStatusBar * statusBar;//状态栏


//录像拍照view
@property (nonatomic, strong)FSVideoLiveBottomBar   * bottomBar;


@end
@implementation VideoLiveController
- (void)viewDidLoad{
    
    
    //禁止休眠
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.statusBar];
    [self.statusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@60);
    }];
    
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@100);
    }];
}
- (void)dealloc{
    
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}
- (void)viewDidAppear:(BOOL)animated{
    [self.ViedoDecoder StardecodeFrame];
    [self AddVideoView];
    
    //状态栏、录像栏拿到最前面
    [self.view bringSubviewToFront:self.statusBar];
    [self.view bringSubviewToFront:self.bottomBar];
}

//状态栏
- (FSFSVideoLiveStatusBar *)statusBar{
    if (!_statusBar) {
        _statusBar = [[FSFSVideoLiveStatusBar alloc] init];
        _statusBar.delegate = self;
        _statusBar.backgroundColor = [UIColor clearColor];
    }
    return _statusBar;
}
- (FSVideoLiveBottomBar *)bottomBar{
    if (!_bottomBar) {
        _bottomBar = [[FSVideoLiveBottomBar alloc] init];
        _bottomBar.backgroundColor = [UIColor clearColor];
    }
    return _bottomBar;
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


#pragma mark VideoStatusBarDelegate
- (void)FifishBackBtnClick{
    //停止解码
    self.ViedoDecoder.isRunningDecode = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
