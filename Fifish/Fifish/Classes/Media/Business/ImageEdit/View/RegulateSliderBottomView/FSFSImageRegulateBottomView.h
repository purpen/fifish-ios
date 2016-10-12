//
//  FSFSImageRegulateBottomView.h
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseView.h"


@protocol FSFSImageRegulateBottomViewDelegate <NSObject>

/**
 取消
 */
- (void)FSFSImageRegulateBottomViewCancel;

/**
 确认
 */
- (void)FSFSImageRegulateBottomViewConfirm;

@end

@interface FSFSImageRegulateBottomView : FSBaseView

@property (nonatomic,assign) id<FSFSImageRegulateBottomViewDelegate>RegulateBottomViewDelegate;


@end
