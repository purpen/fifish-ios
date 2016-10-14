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
@property(nonatomic,copy) NSString *view_count;
/**  */
@property(nonatomic,copy) NSString *user_id;
/** 1是图片 2是视频 */
@property(nonatomic,copy) NSString *kind;
/**  */
@property(nonatomic,copy) NSString *username;
/**  */
@property (nonatomic, strong) NSArray *tags;
/**  */
@property (nonatomic, assign) NSInteger is_love;
/**  */
@property(nonatomic,copy) NSString *created_at;
/**  */
@property(nonatomic,copy) NSString *address;
/**  */
@property(nonatomic,copy) NSString *avatar_small;
/**  */
@property(nonatomic,copy) NSString *avatar_large;
/**  */
@property(nonatomic,copy) NSString *srcfile;
/**  */
@property(nonatomic,copy) NSString *file_small;
/**  */
@property(nonatomic,copy) NSString *file_large;
/**  */
@property (nonatomic, assign) NSInteger is_follow;
/**  */
@property(nonatomic,copy) NSString *filepath;
/**  */
@property(nonatomic,copy) NSString *duration;

@end
