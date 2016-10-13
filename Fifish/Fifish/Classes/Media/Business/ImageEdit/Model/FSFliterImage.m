//
//  FSFliterImage.m
//  Fifish
//
//  Created by macpro on 16/10/13.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFliterImage.h"

@implementation FSFliterImage



- (CGFloat)lightValue{
    if (_lightValue<-1) {
        _lightValue = -1.0;
    }
    if (_lightValue>1) {
        _lightValue= 1.0;
    }
    return _lightValue;
}
- (CGFloat)contrastValue{
    if (_contrastValue<0) {
        _contrastValue = 0.1;
    }
    if (_contrastValue>4) {
        _contrastValue = 4;
    }
    if (!_contrastValue) {
        _contrastValue = 1.0;
    }
    return _contrastValue;
}
- (CGFloat)staurationValue{
    if (_staurationValue<0) {
        _staurationValue = 0.1;
    }
    if (_staurationValue>2) {
        _staurationValue = 2.0;
    }
    if (!_staurationValue) {
        _staurationValue = 1.0;
    }
    return _staurationValue;
}

-(CGFloat)sharpnessValue{
    if (_sharpnessValue<-4.0) {
        _sharpnessValue = -4.0;
    }
    if (_sharpnessValue>4.0) {
        _sharpnessValue = 4.0;
    }
    return _sharpnessValue;
}

-(CGFloat)colorTemperatureValue{
    if (!_colorTemperatureValue) {
        _colorTemperatureValue = 5000;
    }
   else if (_colorTemperatureValue<1000) {
        _colorTemperatureValue =1000;
    }
   else if (_colorTemperatureValue>10000) {
        _colorTemperatureValue = 10000;
    }
   else{
       
   }
    
    return _colorTemperatureValue;
}

- (void)updataParamsWithIndex:(NSInteger)type WithValue:(CGFloat)value{

    switch (type) {
        case 0:
        {
            self.lightValue = value;
        }
            break;
        case 1:
        {
            self.contrastValue=value;
        }
            break;
        case 2:
        {
            self.staurationValue = value;
        }
            break;
        case 3:
        {
            self.sharpnessValue = value;
        }
            break;
        case 4:
        {
            self.colorTemperatureValue = value;
        }
            break;
        default:
            break;
    }
}
@end
