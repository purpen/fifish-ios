//
//  FSPictuerView.h
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSZuoPin;

@interface FSPictuerView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imagView;
/**  */
@property (nonatomic, strong) FSZuoPin *zuoPin;
@end
