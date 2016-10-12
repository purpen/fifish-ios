//
//  FSWatermarkViewController.h
//  Fifish
//
//  Created by THN-Dong on 2016/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseViewController.h"

@protocol FSWatermarkViewControllerDelegate <NSObject>

-(void)switch:(BOOL)flag;
-(UIImage*)getWatermarkImage;
-(void)saveName:(NSString*)str;

@end

@interface FSWatermarkViewController : FSBaseViewController

/**  */
@property (nonatomic, strong) UIImage *bigImage;
/**  */
@property (nonatomic, weak) id<FSWatermarkViewControllerDelegate> waterDelegate;
@property (weak, nonatomic) IBOutlet UISwitch *watermarkSwitch;
/**  */
@property (nonatomic, assign) BOOL switchSState;
/**  */
@property(nonatomic,copy) NSString *str;

@end
