//
//  FSFSVideoLiveStatusBar.h
//  Fifish
//
//  Created by macpro on 16/8/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseView.h"
#import "FSBearingsView.h"
@protocol FSVidoLiveStatusBarDelegate <NSObject>

@required
//返回
- (void)FifishBackBtnClick;

//菜单
- (void)VideoLiveMenuBtnClick;

@end

@interface FSFSVideoLiveStatusBar : FSBaseView
@property (nonatomic ,strong) FSBearingsView    * BearingsView;//方向

@property (nonatomic,assign)id<FSVidoLiveStatusBarDelegate>delegate;

@end
