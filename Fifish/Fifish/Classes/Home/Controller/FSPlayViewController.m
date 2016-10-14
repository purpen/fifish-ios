//
//  FSPlayViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/14.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSPlayViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FSPlayViewController ()

{
    AVPlayer                    *_player;
    AVAudioSession              *_session;
    NSString                    *_urlString;
}

@end

@implementation FSPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _session = [AVAudioSession sharedInstance];
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    _player = [AVPlayer playerWithURL:[NSURL URLWithString:self.videoUrl]];
    self.player = _player;
    self.videoGravity = AVLayerVideoGravityResizeAspect;
    self.showsPlaybackControls = true;
    [self.player play];
}

@end
