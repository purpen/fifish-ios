//
//  FSSearchBar.h
//  Fifish
//
//  Created by THN-Dong on 2016/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchTextBlock)(NSString * searchText);

typedef NS_ENUM(NSUInteger, LGLSearchBarStyle) {
    
    LGLSearchBarStyleDefault,
    LGLSearchBarStyleProminent,
    LGLSearchBarStyleMinimal
};

typedef NS_ENUM(NSInteger, LGLTextBorderStyle) {
    
    LGLTextBorderStyleNone,
    LGLTextBorderStyleLine,
    LGLTextBorderStyleBezel,
    LGLTextBorderStyleRoundedRect
};


@interface FSSearchBar : UIView

- (instancetype)initWithFrame:(CGRect)frame searchBarStyle:(LGLSearchBarStyle)style;



/** 提示文字 */
@property (nonatomic, copy)   NSString * placeholder;

/** 提示文字的颜色 */
@property (nonatomic, strong) UIColor  * placeholderColor;

/** 搜索框(输入框除外)的背景颜色 */
@property (nonatomic, strong) UIColor  * barBackgroudColor;

/** 输入框的背景颜色 */
@property (nonatomic, strong) UIColor  * textBackgroudColor;

/** 输入文字的颜色文字的颜色 */
@property (nonatomic, strong) UIColor  * textColor;

/** “搜索“文字的颜色 */
@property (nonatomic, strong) UIColor  * tintColor;

/** 提示文字的大小 */
@property (nonatomic, assign) CGFloat    placeholderFontSize;

/** 输入文字的大小 */
@property (nonatomic, assign) CGFloat    textFontSize;


/** 输入框的风格 */
@property (nonatomic, assign) LGLTextBorderStyle textBordStyle;

@property (nonatomic, copy) SearchTextBlock block;

/** 获得搜索的Text */
- (void)searchBarTextSearchTextBlock:(SearchTextBlock)block;

/** 改变里面输入框的 边框宽度 颜色 圆角  */
- (void)setSearchBarBordeWidth:(CGFloat)Width bordColor:(UIColor *)bordColor bordRadius:(CGFloat)bordcornerRadius;

/**
 * 修改放大镜的图片
 * @pramas imageName 图片名称
 * @pramas scale 改变图片的大小
 *
 */
- (void)setSearchBarImage:(NSString *)imageName scale:(CGFloat)scale;

@end
