//
//  FW1977Filter.h
//  FWMeituApp
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImagePicture.h"
#import "GPUImageThreeInputFilter.h"

@interface FSFilter9 : GPUImageThreeInputFilter

@end

@interface FS1977Filter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
}

@end
