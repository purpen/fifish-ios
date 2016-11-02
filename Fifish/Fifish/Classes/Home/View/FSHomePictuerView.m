//
//  FSHomePictuerView.m
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomePictuerView.h"
#import "UIImageView+WebCache.h"
#import "FSZuoPin.h"
#import "FSProgressViewProgress.h"

@interface FSHomePictuerView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet FSProgressViewProgress *progressView;


@end

@implementation FSHomePictuerView

-(void)setModel:(FSZuoPin *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.file_large] placeholderImage:[UIImage imageNamed:@"shuffling_default"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        _model.pictureProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:_model.pictureProgress animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}

@end
