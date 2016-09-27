//
//  FSCommentModel.h
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSCommentModel : NSObject

/**  */
@property(nonatomic,copy) NSString *idFiled;
/**  */
@property(nonatomic,copy) NSString *content;
/**  */
@property(nonatomic,copy) NSString *userId;
/**  */
@property (nonatomic, assign) CGFloat cellHeghit;
/**  */
@property(nonatomic,copy) NSString *username;
/**  */
@property(nonatomic,copy) NSString *user_avatar_large;
/**  */
@property(nonatomic,copy) NSString *reply_user_Id;
/**  */
@property(nonatomic,copy) NSString *reply_user_name;
/**  */
@property(nonatomic,copy) NSString *reply_user_avatar_large;
/**  */
@property(nonatomic,copy) NSString *created_at;

@end
