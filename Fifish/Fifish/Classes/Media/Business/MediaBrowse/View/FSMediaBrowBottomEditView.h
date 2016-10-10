//
//  FSMediaBrowBottomEditView.h
//  Fifish
//
//  Created by macpro on 16/10/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBaseView.h"

@protocol FSMediaBrowBottomEditViewDelegate <NSObject>

/**
 分享编辑
 */
- (void)MediaBrowViewEditAndShare;

/**
 删除
 */
- (void)MediaBrowViewDelete;


@end

@interface FSMediaBrowBottomEditView : FSBaseView

@property (assign, nonatomic) id<FSMediaBrowBottomEditViewDelegate> delegate;

@end
