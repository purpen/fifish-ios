//
//  FSZuoPin.m
//  Fifish
//
//  Created by THN-Dong on 16/8/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSZuoPin.h"
#import "FSConst.h"

@implementation FSZuoPin

{
    CGFloat _cellHeight;
}

-(CGFloat)cellHeight{
    if (!_cellHeight) {
        if (self.type == FSZuoPinTypePicture) { // 图片
            // 图片显示出来的宽度
            CGFloat pictureW = SCREEN_WIDTH;
            // 显示显示出来的高度
            CGFloat pictureH = pictureW * SCREEN_HEIGHT / SCREEN_WIDTH;
            
            // 计算图片控件的frame
            CGFloat pictureX = 0;
            CGFloat pictureY = 10;
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            _cellHeight += pictureH + 10;
        } else if (self.type == FSZuoPinTypeVideo) { // 视频
            CGFloat videoX = 0;
            CGFloat videoY = 20;
            CGFloat videoW = SCREEN_WIDTH;
            CGFloat videoH = videoW * SCREEN_HEIGHT / SCREEN_WIDTH;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            
            _cellHeight += videoH + 0;
        }
    }
    return _cellHeight;
}

@end
