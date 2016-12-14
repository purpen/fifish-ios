//
//  FSGuideManager.h
//  Fifish
//
//  Created by THN-Dong on 2016/12/14.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FSGuideManager : NSObject

+(instancetype)shared;

-(void)showGuideViewWithImages:(NSArray*)images;

@end
