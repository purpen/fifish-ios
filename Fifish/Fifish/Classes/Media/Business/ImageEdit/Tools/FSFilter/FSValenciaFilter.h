//
//  FSValenciaFilter.h
//  FSMeituApp
//
//  Created by hzkmn on 16/1/11.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "GPUImageFilterGroup.h"

#import "GPUImageThreeInputFilter.h"
#import "GPUImagePicture.h"
@interface FSFilter8 : GPUImageThreeInputFilter

@end

@interface FSValenciaFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
}

@end
