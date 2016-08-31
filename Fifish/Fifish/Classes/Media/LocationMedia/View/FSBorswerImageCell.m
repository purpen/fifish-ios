//
//  FSBorswerImageCell.m
//  Fifish
//
//  Created by macpro on 16/8/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBorswerImageCell.h"


@implementation FSBorswerImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setVideoAsset:(AVURLAsset *)videoAsset{
    _videoAsset = videoAsset;
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:_videoAsset];
    CMTimeShow(_videoAsset.duration);
    [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:CMTimeMakeWithSeconds(0,1)]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        //获取图片
        UIImage *thumbImg = [UIImage imageWithCGImage:image];
        
//        时长
        NSInteger  duration = CMTimeGetSeconds(_videoAsset.duration);
        NSInteger minute = duration/60;
        NSInteger second = duration%60;
        
        
        
        //回调主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.borswerImageView.image = thumbImg;
            self.durationLab.text = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
        });
    }];
}
@end
