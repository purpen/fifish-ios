//
//  FSCommentModel.m
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSCommentModel.h"
#import "MJExtension.h"

@implementation FSCommentModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             
             @"idFiled" : @"id",
             @"userId" : @"user.id",
             @"username" : @"user.username",
             @"user_avatar_large" : @"user.avatar.large",
             @"reply_user_Id" : @"reply_user.id",
             @"reply_user_name" : @"reply_user.username",
             @"reply_user_avatar_large" : @"reply_user.avatar.large"
             
             };
}

-(CGFloat)cellHeghit{
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 55, MAXFLOAT);
    CGFloat textH = [self.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    _cellHeghit = 39 + textH + 10;
    
    return _cellHeghit;
}

@end
