//
//  FSImageScrollView.m
//  Fifish
//
//  Created by THN-Dong on 2016/9/28.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageScrollView.h"
#import "UIImageView+WebCache.h"
#import "FSProgressViewProgress.h"
#import "Masonry.h"

@interface FSImageScrollView () <UIScrollViewDelegate>

{
    CGSize _imageSize;
}

@property (strong, nonatomic) UIImageView *imageView;
/**  */
@property (nonatomic, strong) FSProgressViewProgress *progressView;

@end

@implementation FSImageScrollView

-(FSProgressViewProgress *)progressView{
    if (!_progressView) {
        _progressView = [[FSProgressViewProgress alloc] init];
    }
    return _progressView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
        self.alwaysBounceVertical = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.imageView.frame = frameToCenter;
}

-(void)displayImageUrl:(NSString *)imageUrl{
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    self.zoomScale = 1.0;
    
    self.imageView = [[UIImageView alloc] init];
    [self.imageView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageView.mas_centerX);
        make.centerY.mas_equalTo(self.imageView.mas_centerY);
        make.width.height.mas_equalTo(100);
    }];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"shuffling_default"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        CGFloat pictureProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:pictureProgress animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    self.imageView.clipsToBounds = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    CGRect frame = self.imageView.frame;
    frame.size.height = SCREEN_HEIGHT;
    frame.size.width = SCREEN_WIDTH;
    self.imageView.frame = frame;
    [self configureForImageSize:self.imageView.bounds.size];
}

- (void)displayImage:(UIImage *)image {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    self.zoomScale = 1.0;
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.clipsToBounds = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    CGRect frame = self.imageView.frame;
//    frame.size.height = 210;
    frame.size.width = self.bounds.size.width;
    self.imageView.frame = frame;
    [self configureForImageSize:self.imageView.bounds.size];
}

- (void)configureForImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 2.0;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
