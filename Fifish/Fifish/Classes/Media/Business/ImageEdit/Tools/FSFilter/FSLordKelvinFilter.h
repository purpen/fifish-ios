//
//  FSLordKelvinFilter.h
//  FSMeituApp
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImageTwoInputFilter.h"
#import "GPUImagePicture.h"
@interface FSFilter2 : GPUImageTwoInputFilter

@end

@interface FSLordKelvinFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource;
}

@end
