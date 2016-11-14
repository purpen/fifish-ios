//
//  UINavigationBar+FSExtension.h
//  Fifish
//
//  Created by THN-Dong on 2016/11/14.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (FSExtension)

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;

@end
