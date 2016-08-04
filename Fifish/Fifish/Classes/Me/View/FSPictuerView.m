//
//  FSPictuerView.m
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSPictuerView.h"
#import "UIImageView+WebCache.h"

@implementation FSPictuerView

-(void)setZuoPin:(FSZuoPin *)zuoPin{
    _zuoPin = zuoPin;
    // 设置图片
    [self.imagView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

-(void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
