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
    
    UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    [self.view addSubview:web];
    
    [web loadRequest:[NSURLRequest requestWithURL:playerURL]];
}
@end
