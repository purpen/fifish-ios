//
//  FSZuoPin.h
//  Fifish
//
//  Created by THN-Dong on 16/8/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FSZuoPinTypePicture = 1,
    FSZuoPinTypeVideo = 11
} FSZuoPinType;

@interface FSZuoPin : NSObject

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/** 帖子的类型 */
@property (nonatomic, assign) FSZuoPinType type;
/** 图片控件的frame */
@property (nonatomic, assign, readonly) CGRect pictureF;
@end
