//
//  FSImageFilterManager.m
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageFilterManager.h"
#import "FSfilter.h"

#import "GPUImageFilter.h"
#import "GPUImageBrightnessFilter.h"
#import "GPUImageContrastFilter.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageSharpenFilter.h"
#import "GPUImageWhiteBalanceFilter.h"
//FSFiveInputFilter
//FSRiseFilter

@interface FSImageFilterManager ()

//亮度
@property (nonatomic,strong)GPUImageBrightnessFilter * BrightnessFilter;

//对比度
@property (nonatomic,strong)GPUImageContrastFilter   * ContrastFilter;

//饱和度
@property (nonatomic,strong)GPUImageSaturationFilter * SaturationFilter;

//锐度
@property (nonatomic,strong)GPUImageSharpenFilter    *SharpenFilter;

//色温
@property (nonatomic,strong)GPUImageWhiteBalanceFilter * WhiteBalanceFilter;

@end

@implementation FSImageFilterManager

//test
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
    //原图
    if([filterName isEqualToString:@"original"]){
        return image;
    }
    GPUImageFilterGroup * filter =(GPUImageFilterGroup*) [[NSClassFromString(filterName) alloc] init];
    
    [filter forceProcessingAtSize:image.size];
    [filter useNextFrameForImageCapture];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    
    
    return [filter imageFromCurrentFramebuffer];
}

- (UIImage *)randerImageWithProgress:(CGFloat)progressValue WithImage:(UIImage *)image WithImageParamType:(FSImageParamType)paramType{
    
    GPUImagePicture * randerpic = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageFilter * fiter;
    
    switch (paramType) {
        case FSImageParamOfLight:
        {
            fiter = self.BrightnessFilter;
            self.BrightnessFilter.brightness = progressValue;
        }
            break;
        case FSImageParamOfcontrast:
        {
            fiter = self.ContrastFilter;
            self.ContrastFilter.contrast = progressValue;
        }
            break;
        case FSImageParamOfstauration:
        {
            fiter = self.SaturationFilter;
            self.SaturationFilter.saturation = progressValue;
        }
            break;
        case FSImageParamOfsharpness:
        {
            fiter = self.SharpenFilter;
            self.SharpenFilter.sharpness = progressValue;
        }
            break;
        case FSImageParamOfcolorTemperature:
        {
            fiter = self.WhiteBalanceFilter;
            self.WhiteBalanceFilter.temperature = progressValue;
        }
            break;
        default:
            
            break;
    }
    
    [fiter useNextFrameForImageCapture];
    [fiter forceProcessingAtSize:image.size];
    [randerpic addTarget:fiter];
    [randerpic processImage];
    return [fiter imageFromCurrentFramebuffer];
    
    return nil;
}

- (GPUImageBrightnessFilter *)BrightnessFilter{
    if (!_BrightnessFilter) {
        _BrightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        
    }
    return _BrightnessFilter;
}
- (GPUImageContrastFilter *)ContrastFilter{
    if (!_ContrastFilter) {
        _ContrastFilter = [[GPUImageContrastFilter alloc] init];
        
    }
    return _ContrastFilter;
}

- (GPUImageSaturationFilter *)SaturationFilter{
    if (!_SaturationFilter) {
        _SaturationFilter = [[GPUImageSaturationFilter alloc] init];
    }
    return _SaturationFilter;
}
- (GPUImageSharpenFilter *)SharpenFilter{
    if (!_SharpenFilter) {
        _SharpenFilter =[[GPUImageSharpenFilter alloc] init];
        
    }
    return _SharpenFilter;
}
- (GPUImageWhiteBalanceFilter *)WhiteBalanceFilter{
    if (!_WhiteBalanceFilter) {
        _WhiteBalanceFilter = [[GPUImageWhiteBalanceFilter alloc] init];
    }
    return _WhiteBalanceFilter;
}










- (NSArray *)fsFilterArr{
    if (!_fsFilterArr) {
        _fsFilterArr = @[@"original",
                         @"FS1977Filter",
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
                         @"GPUImageSepiaFilter",
                         @"GPUImageGaussianBlurFilter",
                         @"GPUImageMedianFilter",
                         @"GPUImageErosionFilter",
                         @"GPUImageRGBErosionFilter",
                         @"GPUImageDilationFilter",
                         @"GPUImageRGBDilationFilter",
                         @"GPUImageRGBOpeningFilter",
                         @"GPUImageRGBClosingFilter",
                         @"GPUImageSmoothToonFilter",
                         @"GPUImageVignetteFilter",
                         @"GPUImagePinchDistortionFilter",
                         ];
        
    }
    return _fsFilterArr;
    
}
- (NSArray *)fsFilterNameArr{
    if (!_fsFilterNameArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FSfilterName" ofType:@"plist"];
       _fsFilterNameArr = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _fsFilterNameArr;
}
//  @[@"FS1977Filter",
//@"FSAmaroFilter",
//@"FSHudsonFilter",
//@"FSInkwellFilter",
//@"FSLomofiFilter",
//@"FSLordKelvinFilter",
//@"FSNashvilleFilter",
//@"FSSierraFilter",
//@"FSValenciaFilter",
//@"FSWaldenFilter",
//@"FSXproIIFilter",
//@"GPUImageBrightnessFilter",
//                      @"GPUImageColorInvertFilter",
//@"GPUImageSepiaFilter",
//@"GPUImageGaussianBlurFilter",
//                         @"GPUImageGaussianSelectiveBlurFilter",
//                         @"GPUImageBoxBlurFilter",
//                        @"GPUImageTiltShiftFilter",
//@"GPUImageMedianFilter",
//@"GPUImageErosionFilter",
//@"GPUImageRGBErosionFilter",
//@"GPUImageDilationFilter",
//@"GPUImageRGBDilationFilter",
//@"GPUImageOpeningFilter",
//@"GPUImageRGBOpeningFilter",
//@"GPUImageClosingFilter",
//@"GPUImageRGBClosingFilter",
//                       @"GPUImageNonMaximumSuppressionFilter",
//                         @"GPUImageThresholdedNonMaximumSuppressionFilter",
//                         @"GPUImageSobelEdgeDetectionFilter",
//                         @"GPUImageCannyEdgeDetectionFilter",
//                         @"GPUImageThresholdEdgeDetectionFilter",
//                         @"GPUImagePrewittEdgeDetectionFilter",
//                         @"GPUImageXYDerivativeFilter",
//                         @"GPUImageMotionDetector",
//                         @"GPUImageLocalBinaryPatternFilter",
//                         @"GPUImageLowPassFilter",
//                         @"GPUImageSketchFilter",
//                         @"GPUImageThresholdSketchFilter",
//                         @"GPUImageToonFilter",
//@"GPUImageSmoothToonFilter",
//                         @"GPUImageKuwaharaFilter",
//                         @"GPUImagePixellateFilter",
//                         @"GPUImagePolarPixellateFilter",
//                       @"GPUImageCrosshatchFilter",
//@"GPUImageColorPackingFilter",
//@"GPUImageVignetteFilter",
//                       @"GPUImageSwirlFilter",
//                         @"GPUImageBulgeDistortionFilter",
//@"GPUImagePinchDistortionFilter",
//                         @"GPUImageStretchDistortionFilter",
//                         @"GPUImageGlassSphereFilter",
//                         @"GPUImageSphereRefractionFilter",
//                         @"GPUImagePosterizeFilter",
//                         @"GPUImageCGAColorspaceFilter",
//                         @"GPUImagePerlinNoiseFilter",
//                         @"GPUImage3x3ConvolutionFilter",
//                         @"GPUImageEmbossFilter",
//                         @"GPUImagePolkaDotFilter",
//                         @"GPUImageHalftoneFilter"
//];
@end
