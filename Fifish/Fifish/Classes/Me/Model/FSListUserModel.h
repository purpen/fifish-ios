//
//  FSListUserModel.h
//  Fifish
//
//  Created by THN-Dong on 16/9/20.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

@interface FSListUserModel : JKDBModel

/**  */
@property(nonatomic,copy) NSString *userId;
/**  */
@property(nonatomic,copy) NSString *userName;
/**  */
@property(nonatomic,copy) NSString *summary;
/**  */
@property(nonatomic,copy) NSString *userHeadImage;
/**  */
@property (nonatomic, assign) NSInteger followFlag;

@end
