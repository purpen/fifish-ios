//
//  FSdirectionManager.m
//  Fifish
//
//  Created by macpro on 16/12/27.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSdirectionManager.h"

@implementation FSdirectionManager

+ (instancetype)shared
{
    return [[self alloc]init];
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)startSensor
{
    self.manager = [[CLLocationManager alloc]init];
    self.manager.delegate = self;
    
    if ([CLLocationManager headingAvailable]) {
        self.manager.headingFilter = 1;
        [self.manager startUpdatingHeading];
        [self.manager requestWhenInUseAuthorization];
    }
}

- (void)stopSensor
{
    [self.manager stopUpdatingHeading];
    self.manager = nil;
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error.localizedDescription);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.headingAccuracy < 0)
        return;
    
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    if (_didUpdateHeadingBlock) {
        _didUpdateHeadingBlock(theHeading);
    }
}


@end
