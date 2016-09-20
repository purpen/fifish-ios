//
//  FSZuoPin.h
//  Fifish
//
//  Created by THN-Dong on 16/8/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSConst.h"


@interface FSZuoPin : NSObject

/**  */
@property(nonatomic,copy) NSString *content;
/**  */
@property(nonatomic,copy) NSString *like_count;
/**  */
@property(nonatomic,copy) NSString *idFeild;
/**  */
@property(nonatomic,copy) NSString *comment_count;
/**  */
@property(nonatomic,copy) NSString *fileurl;
/**  */
@property(nonatomic,copy) NSString *width;
/**  */
@property(nonatomic,copy) NSString *height;
/**  */
@property(nonatomic,copy) NSString *view_count;
/**  */
@property (nonatomic, assign) CGFloat cellHeight;
/**  */
@property(nonatomic,copy) NSString *user_id;
/** 1是图片 2是视频 */
@property(nonatomic,copy) NSString *kind;

@end
