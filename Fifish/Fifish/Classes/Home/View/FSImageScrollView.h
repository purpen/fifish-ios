//
//  FSImageScrollView.h
//  Fifish
//
//  Created by THN-Dong on 2016/9/28.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSZuoPin.h"

@interface FSImageScrollView : UIScrollView

- (void)displayImage:(UIImage *)image;
- (void)displayImageUrl:(NSString *)imageUrl andModel:(FSZuoPin*)model;

@end
