//
//  FSImageFilterManager.m
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageFilterManager.h"
#import "FSfilter.h"

@implementation FSImageFilterManager
+(UIImage *)randerImageWithFilter:(FSFilterType)filtertype WithImage:(UIImage *)image{
    GPUImageFilterGroup * filter =(GPUImageFilterGroup*) [[NSClassFromString(@"FSBrannanFilter") alloc] init];
    
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    
    
    return [filter imageFromCurrentFramebuffer];
}
@end
