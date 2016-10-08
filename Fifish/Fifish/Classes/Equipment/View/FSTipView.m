//
//  FSTipView.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTipView.h"
#import "UIView+FSExtension.h"

@interface FSTipView ()



@end

@implementation FSTipView

- (IBAction)cancelClick:(id)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.y = SCREEN_HEIGHT;
    } completion:nil];
    
}

@end
