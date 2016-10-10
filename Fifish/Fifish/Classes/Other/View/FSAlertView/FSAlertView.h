//
//  FSAlertView.h
//  Fifish
//
//  Created by macpro on 16/10/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSAlertView : NSObject
-(void)showAlertView:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message canceltitle:(NSString *)cancelButtonTitle oktitle:(NSString *)otherButtonTitle confirmBlock:(void (^)())confirm cancelBlock:(void (^)())cancle;

@end
