//
//  VideoLiveController.m
//  Fifish
//
//  Created by macpro on 16/8/15.
//  Copyright © 2016年 Dong. All rights reserved.
//
//controller
#import "VideoLiveController.h"
#import "FSTabBarController.h"
#import "FSVideoPlayerController.h"
#import "FSLiveSettingsViewController.h"

//other
#import "FifishH264Decoder.h"
#import "FSOSDManager.h"

//view
#import "OpenGLFrameView.h"
#import "FSFSVideoLiveStatusBar.h"
#import "FSVideoDepthRulerView.h"
#import "FSVideoLiveBottomBar.h"
@interface VideoLiveController()<updataYUV_420FrameDelegate,FSVidoLiveStatusBarDelegate,FSOSDMannagrDelegate>


@property (nonatomic, strong)FifishH264Decoder * ViedoDecoder;//解码器


@property (nonatomic, strong)OpenGLFrameView   * VideoGlView;//videoview


@property (nonatomic, strong)FSFSVideoLiveStatusBar * statusBar;//状态栏


@property (nonatomic, strong)FSVideoDepthRulerView  * DetpthView;//深度尺


@property (nonatomic, strong)FSVideoLiveBottomBar   * bottomBar;//录像拍照view

@property (nonatomic, assign)FSOSDManager           * fishMannager;


//lodingView
@property (nonatomic, strong)UIActivityIndicatorView * activityIndicatorView;

@end
@implementation VideoLiveController
- (void)viewDidLoad{
    //禁止休眠
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    [super viewDidLoad];
    [self SetUpUI];
    //获取设备信息，建立连接
    [self ConnectWithROV];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)ConnectWithROV{
    _fishMannager =  [FSOSDManager sharedManager];
    [_fishMannager starConnectWithOSD];
    _fishMannager.delegate =self;
}

- (void)SetUpUI{
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
    
    [self.view addSubview:self.DetpthView];
    [self.DetpthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusBar.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)dealloc{
    //终止连接
    _fishMannager.delegate = nil;
    [_fishMannager stopConnectWithOSD];
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //解码，添加播放视图
    if (self.ViedoDecoder.isRunningDecode == NO) {
       [self.ViedoDecoder StardecodeFrame];
    }
    [self AddVideoView];
    
    //状态栏、录像栏拿到最前面
    [self.view bringSubviewToFront:self.statusBar];
    [self.view bringSubviewToFront:self.DetpthView];
    [self.view bringSubviewToFront:self.bottomBar];
}
- (UIActivityIndicatorView *)activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];   
    }
    return _activityIndicatorView;
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
//深度尺
- (FSVideoDepthRulerView *)DetpthView{
    if (!_DetpthView) {
        _DetpthView = [[FSVideoDepthRulerView alloc] init];
    }
    return _DetpthView;
}
//底部栏
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
    [self.activityIndicatorView stopAnimating];
    [self.VideoGlView render:yuvFrame];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

#pragma OSDmannagerDelegate
- (void)connectWithOSDsuccess{
    
}
- (void)connectWithOSDerror:(NSError *)error{
    [self.view makeToast:[NSString stringWithFormat:@"与设备连接异常:%@",error.localizedDescription]];
}
#pragma mark VideoStatusBarDelegate
- (void)FifishBackBtnClick{
    //停止解码
    self.ViedoDecoder.isRunningDecode = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//菜单
- (void)VideoLiveMenuBtnClick{
//    self.ViedoDecoder.isRunningDecode = NO;
//    FSVideoPlayerController * player = [[FSVideoPlayerController alloc]init];
//    player.fileUrl = self.ViedoDecoder.OutputMp4FileUrl;
//    [self presentViewController:player animated:YES completion:nil];
//    
    FSLiveSettingsViewController * settingVc = [[FSLiveSettingsViewController alloc] init];
    [self presentViewController:settingVc animated:YES completion:nil];
}
@end
