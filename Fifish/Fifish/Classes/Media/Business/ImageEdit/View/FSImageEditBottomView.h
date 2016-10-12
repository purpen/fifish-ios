//
//  FSImageEditBottomView.h
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseView.h"

@protocol FSImageEditBottomViewDelegate <NSObject>

- (void)FSImageEditBottomViewChooseWithIndex:(NSInteger)index;


@end

@interface FSImageEditBottomView : FSBaseView
/**
 第一个按钮
 */
@property (nonatomic,strong) UIButton * FilterBtn;

/**
 第二个
 */
@property (nonatomic,strong) UIButton * adjustmentBtn;
@property(assign,nonatomic) id<FSImageEditBottomViewDelegate>delegate;

-(instancetype)initWithFristTitle:(NSString *)fristTitle AndSencondTitle:(NSString *)secondTitle;


@end
