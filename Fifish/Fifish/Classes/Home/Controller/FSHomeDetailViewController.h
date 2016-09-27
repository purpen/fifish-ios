//
//  FSHomeDetailViewController.h
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSZuoPin;

@protocol FSHomeDetailViewControllerDelegate <NSObject>

-(void)lickClick:(BOOL)btnState :(NSString*)idFiled;

@end

@interface FSHomeDetailViewController : UIViewController

/**  */
@property (nonatomic, strong) FSZuoPin *model;
/**  */
@property (nonatomic, weak) id <FSHomeDetailViewControllerDelegate> homeDetailDelegate;

@end
