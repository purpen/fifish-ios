//
//  FSAddressViewController.h
//  Fifish
//
//  Created by THN-Dong on 2016/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseViewController.h"

@protocol FSAddressViewControllerDelegate <NSObject>

-(void)getAddress:(NSString *)address andLat:(CGFloat)lat andLon:(CGFloat)lon;

@end

@interface FSAddressViewController : FSBaseViewController

/**  */
@property (nonatomic, weak) id<FSAddressViewControllerDelegate> addressDelegate;

@end
