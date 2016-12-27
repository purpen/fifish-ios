//
//  FSdirectionManager.h
//  Fifish
//
//  Created by macpro on 16/12/27.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CLHeading.h>

@interface FSdirectionManager : NSObject<CLLocationManagerDelegate>

+ (instancetype)shared;
- (void)startSensor;
- (void)stopSensor;

@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, copy) void (^didUpdateHeadingBlock)(CLLocationDirection theHeading);

@end
