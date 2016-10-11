//
//  FW1977Filter.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
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
