//
//  FSFSVideoLiveStatusBar.h
//  Fifish
//
//  Created by macpro on 16/8/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSVidoLiveStatusBarDelegate <NSObject>

@required
//返回
- (void)FifishBackBtnClick;

@end

@interface FSFSVideoLiveStatusBar : UIView


@property (nonatomic,assign)id<FSVidoLiveStatusBarDelegate>delegate;

@end
