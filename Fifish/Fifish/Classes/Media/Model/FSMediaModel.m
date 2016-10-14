//
//  FSMediaModel.m
//  Fifish
//
//  Created by macpro on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMediaModel.h"

@implementation FSMediaModel
- (UIImage *)flietrImage{
    if (!_flietrImage) {
        _flietrImage = [UIImage imageWithContentsOfFile:self.fileUrl];
    }
    return _flietrImage;
}
@end
