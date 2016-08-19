//
//  FSVideoPlayerController.m
//  Fifish
//
//  Created by macpro on 16/8/19.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation FSVideoPlayerController
- (void)viewDidLoad{
    [super viewDidLoad];
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setTitle:@"play" forState:UIControlStateNormal];
    playBtn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:playBtn];
    [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"%@",self.fileUrl);
}
- (void)play:(UIButton *)btn{
    
    NSURL *playerURL = [NSURL URLWithString:self.fileUrl];
    
    //初始化
    AVPlayerViewController *playerView = [[AVPlayerViewController alloc]init];
    
    //AVPlayerItem 视频的一些信息  创建AVPlayer使用的
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:playerURL];
    
    //通过AVPlayerItem创建AVPlayer
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:item];
    
    //给AVPlayer一个播放的layer层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    layer.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    
    layer.backgroundColor = [UIColor greenColor].CGColor;
    
    //设置AVPlayer的填充模式
    layer.videoGravity = AVLayerVideoGravityResize;
    
    [self.view.layer addSublayer:layer];
    
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    playerView.player = player;
    
    //关闭AVPlayerViewController内部的约束
    playerView.view.translatesAutoresizingMaskIntoConstraints = YES;
    
//    [self showViewController:playerView sender:nil];
}
@end
