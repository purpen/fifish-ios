//
//  FSFansModel.h
//  Fifish
//
//  Created by THN-Dong on 2016/11/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSFansModel : NSObject

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
