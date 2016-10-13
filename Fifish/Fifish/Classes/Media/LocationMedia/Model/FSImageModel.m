//
//  FSImageModel.m
//  Fifish
//
//  Created by macpro on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageModel.h"

@implementation FSImageModel
-(void)setFileUrl:(NSString *)fileUrl{
    [super setFileUrl:fileUrl];
    UIImage * defaultimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:fileUrl], 0.1)];
        self.defaultImage = defaultimage;
}
@end
