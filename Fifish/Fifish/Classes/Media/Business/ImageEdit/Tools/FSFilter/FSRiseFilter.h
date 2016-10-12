//
//  FSRiseFilter.h
//  FSMeituApp
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImagePicture.h"
#import "GPUImageThreeInputFilter.h"
@interface FSFilter4 : GPUImageThreeInputFilter

@end

@interface FSRiseFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
    GPUImagePicture *imageSource3;
}

@end
