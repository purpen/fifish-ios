//
//  FSRecivedPrasiedModel.h
//  Fifish
//
//  Created by THN-Dong on 2016/11/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSRecivedPrasiedModel : NSObject

/**  */
@property(nonatomic,copy) NSString *avatar_large;
/**  */
@property(nonatomic,copy) NSString *username;
/**  
 1是图片
 2是视频
 */
@property (nonatomic, assign) NSInteger stuff_kind;
/**  */
@property(nonatomic,copy) NSString *comment_on_time;
/**  */
@property(nonatomic,copy) NSString *file_large;
/**  */
@property(nonatomic,copy) NSString *userId;
/**  */
@property(nonatomic,copy) NSString *stuffId;
/**  */
@property(nonatomic,copy) NSString *content;

@end
