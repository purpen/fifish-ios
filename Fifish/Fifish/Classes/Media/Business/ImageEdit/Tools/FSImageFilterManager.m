//
//  FSImageFilterManager.m
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageFilterManager.h"
#import "FSfilter.h"

//FSFiveInputFilter
//FSRiseFilter

@interface FSImageFilterManager ()


@end

@implementation FSImageFilterManager
-(UIImage *)randerImageWithFilter:(FSFilterType)filtertype WithImage:(UIImage *)image{
    GPUImageFilterGroup * filter =(GPUImageFilterGroup*) [[NSClassFromString(@"GPUImageColorInvertFilter") alloc] init];
    
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    
    
    return [filter imageFromCurrentFramebuffer];
}

-(UIImage *)randerImageWithIndex:(NSString *)filterName WithImage:(UIImage *)image{
    GPUImageFilterGroup * filter =(GPUImageFilterGroup*) [[NSClassFromString(filterName) alloc] init];
    
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    
    
    return [filter imageFromCurrentFramebuffer];
}

- (NSArray *)fsFilterArr{
    if (!_fsFilterArr) {
        _fsFilterArr = @[@"FS1977Filter",
                         @"FSAmaroFilter",
                         @"FSHudsonFilter",
                         @"FSInkwellFilter",
                         @"FSLomofiFilter",
                         @"FSLordKelvinFilter",
                         @"FSNashvilleFilter",
                         @"FSSierraFilter",
                         @"FSValenciaFilter",
                         @"FSWaldenFilter",
                         @"FSXproIIFilter",
                         @"GPUImageBrightnessFilter",
                         @"GPUImageColorInvertFilter",
                         @"GPUImageSepiaFilter",
                         @"GPUImageGaussianBlurFilter",
                         @"GPUImageGaussianSelectiveBlurFilter",
                         @"GPUImageBoxBlurFilter",
                         @"GPUImageTiltShiftFilter",
                         @"GPUImageMedianFilter",
                         @"GPUImageErosionFilter",
                         @"GPUImageRGBErosionFilter",
                         @"GPUImageDilationFilter",
                         @"GPUImageRGBDilationFilter",
                         @"GPUImageOpeningFilter",
                         @"GPUImageRGBOpeningFilter",
                         @"GPUImageClosingFilter",
                         @"GPUImageRGBClosingFilter",
                         @"GPUImageNonMaximumSuppressionFilter",
                         @"GPUImageThresholdedNonMaximumSuppressionFilter",
                         @"GPUImageSobelEdgeDetectionFilter",
                         @"GPUImageCannyEdgeDetectionFilter",
                         @"GPUImageThresholdEdgeDetectionFilter",
                         @"GPUImagePrewittEdgeDetectionFilter",
                         @"GPUImageXYDerivativeFilter",
                         @"GPUImageMotionDetector",
                         @"GPUImageLocalBinaryPatternFilter",
                         @"GPUImageLowPassFilter",
                         @"GPUImageSketchFilter",
                         @"GPUImageThresholdSketchFilter",
                         @"GPUImageToonFilter",
                         @"GPUImageSmoothToonFilter",
                         @"GPUImageKuwaharaFilter",
                         @"GPUImagePixellateFilter",
                         @"GPUImagePolarPixellateFilter",
                         @"GPUImageCrosshatchFilter",
                         @"GPUImageColorPackingFilter",
                         @"GPUImageVignetteFilter",
                         @"GPUImageSwirlFilter",
                         @"GPUImageBulgeDistortionFilter",
                         @"GPUImagePinchDistortionFilter",
                         @"GPUImageStretchDistortionFilter",
                         @"GPUImageGlassSphereFilter",
                         @"GPUImageSphereRefractionFilter",
                         @"GPUImagePosterizeFilter",
                         @"GPUImageCGAColorspaceFilter",
                         @"GPUImagePerlinNoiseFilter",
                         @"GPUImage3x3ConvolutionFilter",
                         @"GPUImageEmbossFilter",
                         @"GPUImagePolkaDotFilter",
                         @"GPUImageHalftoneFilter"];
        
    }
    return _fsFilterArr;
    
}
@end
