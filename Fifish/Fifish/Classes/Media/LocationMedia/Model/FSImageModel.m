//
//  FSImageModel.m
//  Fifish
//
//  Created by macpro on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageModel.h"

@implementation FSImageModel

-(instancetype)initWithFilePath:(NSString *)filePath{
    self = [super initWithFilePath:filePath];
    if (self) {
        UIImage * defaultimage = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:filePath], 0.1)];
        self.defaultImage = defaultimage;
    }
    return self;
}
@end
