//
//  FSHomeVideoView.m
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeVideoView.h"
#import "FSZuoPin.h"
#import "UIImageView+WebCache.h"
#import "FSProgressViewProgress.h"

@interface FSHomeVideoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet FSProgressViewProgress *progressView;

@end

@implementation FSHomeVideoView

-(void)setModel:(FSZuoPin *)model{
    _model = model;
    self.timeBtn.layer.masksToBounds = YES;
    self.timeBtn.layer.cornerRadius = 5;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.file_large] placeholderImage:[UIImage imageNamed:@"shuffling_default"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        _model.pictureProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:_model.pictureProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    NSInteger duration = [model.duration integerValue];
    NSString *str;
    if (duration > 60) {
        NSInteger minutes = duration / 60;
        NSString *str2;
        if (minutes > 10) {
            str2 = [NSString stringWithFormat:@"%ld",minutes];
        } else {
            str2 = [NSString stringWithFormat:@"0%ld",minutes];
        }
        NSInteger seconds = duration - minutes * 60;
        if (seconds > 10) {
            str = [NSString stringWithFormat:@"%@:%ld",str2 ,seconds];
        } else {
            str = [NSString stringWithFormat:@"%@:0%ld",str2 ,seconds];
        }
    } else {
        if (duration > 10) {
            str = [NSString stringWithFormat:@"00:%ld",duration];
        } else {
            str = [NSString stringWithFormat:@"00:0%ld",duration];
        }
    }
    [self.timeBtn setTitle:str forState:UIControlStateNormal];
}

@end
