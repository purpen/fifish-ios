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
#import "FSCameraManager.h"
#import "FSOSDManager.h"

#import <Photos/Photos.h>
#import "FSliveVideoConst.h"


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


@property (nonatomic,strong)UITapGestureRecognizer * tapGestureRecognizer;//点击手势
@property (nonatomic)        BOOL                   HiddenOSD;//隐藏OSD

@property (nonatomic)       CGFloat                 currentLight ;//获取当前屏幕亮度


//lodingView
@property (nonatomic, strong)UIActivityIndicatorView * activityIndicatorView;

@end
@implementation VideoLiveController
- (void)viewDidLoad{
    //禁止休眠
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    //屏幕亮度，先保存当前亮度
    self.currentLight = [[UIScreen mainScreen] brightness];
    //设置为最亮
    [[UIScreen mainScreen] setBrightness: 1];
    
    [super viewDidLoad];
    
    [self SetUpUI];
    
    //校准camera时间
    [self calibrateCameraTime];
    
    //获取设备信息，建立连接
    [self ConnectWithROV];
    
    //初始化手势
    [self setGesture];
    
    
    //监听拍照通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhoto) name:FSNoticeTakePhoto object:nil];
}
- (void)takePhoto{
    [self.VideoGlView snapshotPicture];
}
- (void)calibrateCameraTime{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[[FSCameraManager alloc] init] RovSetTimeZoneSuccess:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
        } WithFailureBlock:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    });
    
}

//添加手势
- (void)setGesture{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

//连接ROV
- (void)ConnectWithROV{
    _fishMannager =  [FSOSDManager sharedManager];
    [_fishMannager starConnectWithOSD];
    _fishMannager.delegate =self;
}

- (void)SetUpUI{
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

#pragma mark dealloc
- (void)dealloc{
    //终止连接
    _fishMannager.delegate = nil;
    _ViedoDecoder.isRunningDecode = NO;
    [_fishMannager stopConnectWithOSD];
    
    //移除监听通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //重置设备方向
    [UIApplication sharedApplication].idleTimerDisabled=NO;
    
    //还原亮度
    [[UIScreen mainScreen] setBrightness: self.currentLight];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //解码，添加播放视图.从设置页面进来也会走这里。
    if (self.ViedoDecoder.isRunningDecode == NO&&self.ViedoDecoder) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.ViedoDecoder initWithInputUrl];
            [self.ViedoDecoder StardecodeFrame];
        });
        
    }
    [self AddVideoView];
    
    //状态栏、录像栏拿到最前面
    [self.view bringSubviewToFront:self.statusBar];
    [self.view bringSubviewToFront:self.DetpthView];
    [self.view bringSubviewToFront:self.bottomBar];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.ViedoDecoder.isRunningDecode = NO;
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

//添加视频播放VIEW
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
        //rtsp://218.204.223.237:554/live/1/66251FC11353191F/e7ooqwcfbqjoo80j.sdp
        _ViedoDecoder  = [[FifishH264Decoder alloc] initWithUrl:@"rtsp://admin:admin@192.168.2.158:554/channel2/1"];
//        _ViedoDecoder  = [[FifishH264Decoder alloc] initWithUrl:@"http://pull99.a8.com/live/1476687770278362.flv"];
//        _ViedoDecoder  = [[FifishH264Decoder alloc] initWithUrl:@"http://pull99.a8.com/live/1476690710257396.flv"];
//        _ViedoDecoder  = [[FifishH264Decoder alloc] initWithUrl:@"rtsp://218.204.223.237:554/live/1/66251FC11353191F/e7ooqwcfbqjoo80j.sdp"];
        _ViedoDecoder.UpdataDelegate = self;
    }
    return _ViedoDecoder;
}

//解码后的视频数据送到openGl渲染
- (void)updateH264FrameData:(YUV420Frame *)yuvFrame{
    [self.VideoGlView render:yuvFrame];
    [self.activityIndicatorView stopAnimating];
}

//横屏
- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskLandscape;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation

{
    
    return UIInterfaceOrientationLandscapeRight;
    
}

#pragma mark GestureMethd
//单击手势控制深度尺和偏航角显示与隐藏
- (void)handleTap:(UITapGestureRecognizer*)tap{
    self.HiddenOSD = !self.HiddenOSD;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.statusBar.BearingsView.alpha = !self.HiddenOSD;
                         self.DetpthView.alpha = !self.HiddenOSD;
                     }
                     completion:nil];
}


#pragma OSDmannagerDelegate
- (void)connectWithOSDsuccess{
    
}

- (void)connectWithOSDerror:(NSError *)error{
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Equipment connection exception", nil),error.localizedDescription]];
    [SVProgressHUD dismiss];
}

#pragma mark VideoStatusBarDelegate
- (void)FifishBackBtnClick{
    //停止解码
    self.ViedoDecoder.isRunningDecode = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//菜单
- (void)VideoLiveMenuBtnClick{
    FSLiveSettingsViewController * settingVc = [[FSLiveSettingsViewController alloc] init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;//推出的界面透明,不管用
    [self presentViewController:settingVc animated:YES completion:nil];
}
@end
