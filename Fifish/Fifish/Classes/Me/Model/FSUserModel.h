//
//  FSUserModel.h
//  Fifish
//
//  Created by THN-Dong on 16/9/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "JKDBModel.h"
@class FSHeadImageModel;

@interface FSUserModel : JKDBModel

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
@property (nonatomic, strong) FSHeadImageModel *avatar;
/**  */
@property(nonatomic,copy) NSString *imageUrl;


@end
