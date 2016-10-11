//
//  FSSierraFilter.h
//  FSMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImageFourInputFilter.h"
#import "GPUImagePicture.h"
@interface FSFilter11 : GPUImageFourInputFilter

@end

@interface FSSierraFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
    GPUImagePicture *imageSource3;
}

@end
