//
//  FSImageEditBottomView.h
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseView.h"

typedef NS_ENUM(NSUInteger, FSImageEditBottomViewType) {
    FSImageEditBottomViewFilterType,
    FSImageEditBottomViewadjustmentType,
};

@protocol FSImageEditBottomViewDelegate <NSObject>

- (void)FSImageEditBottomViewChooseWithType:(FSImageEditBottomViewType)type;


@end

@interface FSImageEditBottomView : FSBaseView

@property(assign,nonatomic) id<FSImageEditBottomViewDelegate>delegate;


@end
