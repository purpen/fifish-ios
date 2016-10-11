//
//  FSLordKelvinFilter.h
//  FSMeituApp
//
//  Created by hzkmn on 16/1/8.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
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
