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

//-(CGFloat)cellHeight{
//    if (!_cellHeight) {
//        if (self.type == FSZuoPinTypePicture) { // 图片
//            // 图片显示出来的宽度
//            CGFloat pictureW = SCREEN_WIDTH;
//            // 显示显示出来的高度
//            CGFloat pictureH = pictureW * SCREEN_HEIGHT / SCREEN_WIDTH;
//            
//            // 计算图片控件的frame
//            CGFloat pictureX = 0;
//            CGFloat pictureY = 10;
//            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
//            
//            _cellHeight += pictureH + XMGTopicCellMargin;
//        } else if (self.type == XMGTopicTypeVoice) { // 声音帖子
//            CGFloat voiceX = XMGTopicCellMargin;
//            CGFloat voiceY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
//            CGFloat voiceW = maxSize.width;
//            CGFloat voiceH = voiceW * self.height / self.width;
//            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
//            
//            _cellHeight += voiceH + XMGTopicCellMargin;
//        }
//    }
//    return _cellHeight;
//}

@end
