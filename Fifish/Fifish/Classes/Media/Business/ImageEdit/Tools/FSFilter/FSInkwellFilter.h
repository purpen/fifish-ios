//
//  FSInkwellFilter.h
//  FSMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImageTwoInputFilter.h"
#import "GPUImagePicture.h"
@interface FSFilter10 : GPUImageTwoInputFilter

@end

@interface FSInkwellFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource;
}

@end
