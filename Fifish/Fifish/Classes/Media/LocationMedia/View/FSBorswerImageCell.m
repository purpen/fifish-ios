//
//  FSBorswerImageCell.m
//  Fifish
//
//  Created by macpro on 16/8/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBorswerImageCell.h"
#import "FSVideoModel.h"
#import "FSImageModel.h"

#import "UIImageView+WebCache.h"
@implementation FSBorswerImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setFileUrlStr:(NSString *)fileUrlStr{
    
  
}
- (void)setMediaModel:(FSMediaModel *)mediaModel{
    _mediaModel = mediaModel;
    if ([mediaModel isKindOfClass:[FSVideoModel class]]) {
        AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_mediaModel.fileUrl] options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        CMTimeShow(asset.duration);
        [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:CMTimeMakeWithSeconds(0,1)]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
            //获取图片
            UIImage *thumbImg = [UIImage imageWithCGImage:image];
            
            //        时长
            NSInteger  duration =ceil(CMTimeGetSeconds(asset.duration));
            NSInteger minute = duration/60.0;
            NSInteger second = duration%60;
            
            //回调主线程
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.durationLab.hidden = NO;
                self.videoIcon.hidden = NO;
                
                self.borswerImageView.image = thumbImg;
                self.durationLab.text = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
            });
        }];
    }
    
    if ([mediaModel isKindOfClass:[FSImageModel class]]) {
        self.durationLab.hidden = YES;
        self.videoIcon.hidden = YES;
        FSImageModel*  imagemediaModel = (FSImageModel *)mediaModel;
        self.borswerImageView.image = imagemediaModel.defaultImage;
        
    }
}
@end
