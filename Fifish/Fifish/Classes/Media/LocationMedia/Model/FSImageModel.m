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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage * defaultimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:fileUrl], 0.1)];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.defaultImage = defaultimage;
        });
    });
}
@end
