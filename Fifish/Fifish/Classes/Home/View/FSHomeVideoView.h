//
//  FSHomeVideoView.h
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSZuoPin;

@interface FSHomeVideoView : UIView

/**  */
@property (nonatomic, strong) FSZuoPin *model;
@property (weak, nonatomic) IBOutlet UIButton *tapBtn;

@end
