//
//  FSVideoModel.m
//  Fifish
//
//  Created by macpro on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoModel.h"

@implementation FSVideoModel
- (instancetype)initWithFilePath:(NSString *)filePath{
    self = [super initWithFilePath:filePath];
    if (self) {
        
        self.videoAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:self.videoAsset];
        
        //截图方向纠正
        generator.appliesPreferredTrackTransform = YES;
        [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:CMTimeMakeWithSeconds(0,1)]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
            //获取图片
            UIImage *thumbImg = [UIImage imageWithCGImage:image];
            self.defaultImage = thumbImg;
            //        时长
            self.duration =ceil(CMTimeGetSeconds(self.videoAsset.duration));

        }];
    }
    return self;
}
- (UIImage *)VideoPicture{
    return  self.defaultImage;
}
@end
