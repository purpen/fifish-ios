//
//  FSVideoModel.m
//  Fifish
//
//  Created by macpro on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoModel.h"

@implementation FSVideoModel
- (instancetype)initWithFilePath:(NSString *)filePath{
    self = [super initWithFilePath:filePath];
    if (self) {
        self.videoAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    }
    return self;
}
@end
