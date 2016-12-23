//
//  FSImageBrowserModel.m
//  Fifish
//
//  Created by THN-Dong on 2016/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageBrowserModel.h"
#import "SDWebImageManager.h"
#import "FSConst.h"

@interface FSImageBrowserModel ()

/**  */
@property (nonatomic, assign, readwrite) CGRect destinationFrame;
/**  */
@property (nonatomic, assign, readwrite) BOOL isDownload;

@end

@implementation FSImageBrowserModel

-(instancetype)initWithplaceholder:(UIImage *)placholder
                      thumbnailURL:(NSURL *)thumbnailURL
                             HDURL:(NSURL *)HDURL
                     containerView:(UIView *)containerView
               positionInContainer:(CGRect)positionInContainer
                             index:(NSInteger)index{
    self = [super init];
    if (self) {
        self.placeholder = placholder;
        self.thumbnailURL = thumbnailURL;
        self.HDURL = HDURL;
        self.index = index;
        if (containerView != nil) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            CGRect originRect = [containerView convertRect:positionInContainer toView:window];
            self.originPosition = originRect;
        }
        else {
            self.originPosition = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0);
        }
    }
    return self;
}

-(void)setThumbnailURL:(NSURL *)thumbnailURL{
    if (_thumbnailURL != thumbnailURL) {
        _thumbnailURL = thumbnailURL;
    }
    if (_thumbnailURL == nil) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:self.thumbnailURL
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error,
                                    SDImageCacheType cacheType,
                                    BOOL finished,
                                    NSURL *imageURL) {
                            if (finished) {
                                weakSelf.thumbnailImage = image;
                                weakSelf.destinationFrame =
                                [weakSelf calculateDestinationFrameWithSize:weakSelf.thumbnailImage.size index:weakSelf.index];
                            }
                        }
     ];
}

-(CGRect)calculateDestinationFrameWithSize:(CGSize)size
                                     index:(NSInteger)index{
    CGRect rect = CGRectMake(KImageBrowserWidth * index,
                             (KImageBrowserHeight - size.height * SCREEN_WIDTH / size.width)/2,
                             SCREEN_WIDTH,
                             size.height * SCREEN_WIDTH / size.width);
    return rect;
}

@end
