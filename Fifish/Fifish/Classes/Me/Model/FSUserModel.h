//
//  FSUserModel.h
//  Fifish
//
//  Created by THN-Dong on 16/9/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "JKDBModel.h"

@interface FSUserModel : JKDBModel

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


@end
