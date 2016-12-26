//
//  FSImageItem.m
//  Fifish
//
//  Created by THN-Dong on 2016/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageItem.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "FSProgressViewProgress.h"
#import "Masonry.h"

const CGFloat kMaximumZoomScale = 3.0f;
const CGFloat kMinimumZoomScale = 1.0f;
const CGFloat kDuration = 0.3f;

@interface FSImageItem ()<UIScrollViewDelegate>

@property (nonatomic, strong) FSProgressViewProgress *progressView;

@end

@implementation FSImageItem

-(FSProgressViewProgress *)progressView{
    if (!_progressView) {
        _progressView = [[FSProgressViewProgress alloc] init];
    }
    return _progressView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.maximumZoomScale = kMaximumZoomScale;
        self.minimumZoomScale = kMinimumZoomScale;
        self.zoomScale = 1.0f;
        [self addSubview:self.imageView];
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self->_imageView.center);
            make.width.height.mas_equalTo(60);
        }];
        self.progressView.hidden = YES;
        [self setupGestures];
    }
    return self;
}

-(void)setupGestures{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(handleTwoFingerTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    doubleTap.numberOfTapsRequired = 2;
    twoFingerTap.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:singleTap];
    [self.imageView addGestureRecognizer:doubleTap];
    [self.imageView addGestureRecognizer:twoFingerTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

-(void)setImageModel:(FSImageBrowserModel *)imageModel{
    if (_imageModel != imageModel) {
        _imageModel = imageModel;
    }
    self.zoomScale = 1.0f;
    if (self.isFirstShow) {
        if (self.imageModel.thumbnailImage) {
            [self loadHdImage:YES];
        } else {
            [self performSelector:@selector(loadHdImage:) withObject:@(YES) afterDelay:0.5];
        }
    } else {
        [self loadHdImage:NO];
    }
}

-(void)loadHdImage:(BOOL)animated{
    if (!self.imageModel.thumbnailImage) {
        self.imageView.image = self.imageModel.placeholder;
        if (!self.imageModel.placeholder) {
            return;
        }
        self.imageView.frame = [self calculateDestinationFrameWithSize:self.imageModel.thumbnailImage.size];
        return;
    }
    CGRect destinationRect = [self calculateDestinationFrameWithSize:self.imageModel.thumbnailImage.size];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL isImageCached = [manager cachedImageExistsForURL:self.imageModel.HDURL];
    __weak typeof(self) weakSelf = self;
    if (!isImageCached) {
        self.imageView.image = self.imageModel.thumbnailImage;
        if (animated) {
            self.imageView.frame = self.imageModel.originPosition;
            [UIView animateWithDuration:0.18f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 weakSelf.imageView.center = weakSelf.center;
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     [weakSelf downloadImageWithDestinationRect:destinationRect];
                                 }
                             }];
        } else {
            self.imageView.center = weakSelf.center;
            [self downloadImageWithDestinationRect:destinationRect];
        }
    }
    else {
        if (animated) {
            self.imageView.frame = self.imageModel.originPosition;
            [self.imageView sd_setImageWithURL:self.imageModel.HDURL];
            [UIView animateWithDuration:kDuration
                                  delay:0.0f
                 usingSpringWithDamping:0.7f
                  initialSpringVelocity:0.0f
                                options:0
                             animations:^{
                                 weakSelf.imageView.frame = destinationRect;
                             } completion:^(BOOL finished) {
                                 
                             }];
        } else {
            [self.imageView sd_setImageWithURL:self.imageModel.HDURL];
            self.imageView.frame = destinationRect;
        }
    }
}

-(void)downloadImageWithDestinationRect:(CGRect)destinationRect{
    __weak typeof(self) weakSelf = self;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDWebImageOptions options = SDWebImageRetryFailed | SDWebImageLowPriority;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [manager downloadImageWithURL:self.imageModel.HDURL
                                             options:options
                                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                //hud
                                                self.progressView.hidden = NO;
                                                CGFloat pictureProgress = 1.0 * receivedSize / expectedSize;
                                                [self.progressView setProgress:pictureProgress animated:YES];
                                            }
                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                               __strong typeof(weakSelf) sself = weakSelf;
                                               if (finished && image) {
                                                   //hide hud
                                                   self.progressView.hidden = YES;
                                                   sself.imageView.image = image;
                                                   sself.imageModel.thumbnailImage = image;
                                                   if ([sself.eventDelegate respondsToSelector:@selector(didFinishedDownLoadHDImage)]) {
                                                       [sself.eventDelegate didFinishedDownLoadHDImage];
                                                   }
                                                   [UIView animateWithDuration:kDuration
                                                                         delay:0.0f
                                                        usingSpringWithDamping:0.7f
                                                         initialSpringVelocity:0.0f
                                                                       options:0
                                                                    animations:^{
                                                                        sself.imageView.frame = destinationRect;
                                                                    } completion:nil];
                                               }
                                           }];
                   });
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

-(CGRect)calculateDestinationFrameWithSize:(CGSize)size{
    CGRect rect;
    rect = CGRectMake(0.0f,
                      (SCREEN_HEIGHT - size.height * SCREEN_WIDTH/size.width)/2,
                      SCREEN_WIDTH,
                      size.height*SCREEN_WIDTH/size.width);
    if (rect.size.height > SCREEN_HEIGHT) {
        rect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    }
    self.contentSize = rect.size;
    return rect;
}

#pragma mark - UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    [scrollView setZoomScale:scale + 0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 :0.0f;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0f;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.numberOfTapsRequired == 1){
        if ([self.eventDelegate respondsToSelector:@selector(didClickedItemToHide)]){
            [self.eventDelegate didClickedItemToHide];
        }
    }
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        if (self.zoomScale == 1) {
            float newScale = [self zoomScale] * 2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:self]];
            [self zoomToRect:zoomRect animated:YES];
        } else {
            float newScale = [self zoomScale] / 2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:self]];
            [self zoomToRect:zoomRect animated:YES];
        }
    }
}

-(void)handleTwoFingerTap:(UITapGestureRecognizer *)gestureRecognizer{
    float newScale = [self zoomScale] / 2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:self]];
    [self zoomToRect:zoomRect animated:YES];
}

-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width = self.frame.size.width / scale;
    zoomRect.origin.x = center.x - zoomRect.size.width / 2;
    zoomRect.origin.y = center.y - zoomRect.size.height / 2;
    return zoomRect;
}

@end
