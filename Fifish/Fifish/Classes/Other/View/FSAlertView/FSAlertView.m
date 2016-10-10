//
//  FSAlertView.m
//  Fifish
//
//  Created by macpro on 16/10/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSAlertView.h"
typedef void (^confirm)();
typedef void (^cancle)();

@interface FSAlertView (){
    confirm confirmParam;
    cancle  cancleParam;
}
@end
@implementation FSAlertView
- (void)showAlertView:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message canceltitle:(NSString *)cancelButtonTitle oktitle:(NSString *)otherButtonTitle confirmBlock:(void (^)())confirm cancelBlock:(void (^)())cancle{
    confirmParam=confirm;
    cancleParam=cancle;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        cancle();
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        confirm();
    }];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}
@end
