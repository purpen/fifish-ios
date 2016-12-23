//
//  FSUserModel2.h
//  Fifish
//
//  Created by THN-Dong on 2016/12/2.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "JKDBModel.h"

@interface FSUserModel2 : JKDBModel

/**  */
@property(nonatomic,copy) NSString *summary;
/**  */
@property(nonatomic,copy) NSString *userId;
/**  */
@property(nonatomic,copy) NSString *account;
/**  */
@property(nonatomic,copy) NSString *username;
/**  */
@property(nonatomic,copy) NSString *job;
/**  */
@property(nonatomic,copy) NSString *zone;
/**  */
@property(nonatomic,copy) NSString *imageUrl;
/**  */
@property (nonatomic, assign) BOOL isLogin;
/**  */
@property(nonatomic,copy) NSString *stuff_count;
/**  */
@property(nonatomic,copy) NSString *fans_count;
/**  */
@property(nonatomic,copy) NSString *follow_count;
/**  */
@property(nonatomic,copy) NSString *like_count;
/**  */
@property(nonatomic,copy) NSString *small;
/**  */
@property(nonatomic,copy) NSString *large;
/**
 0代表默认
 1代表男
 2：女
 */
@property (nonatomic, assign) NSInteger gender;
/**  */
@property (nonatomic, assign) NSInteger following;
/**  */
@property (nonatomic, assign) NSInteger followFlag;
/** 照片墙图片 */
@property (nonatomic, strong) NSString *imageStr;



@end
