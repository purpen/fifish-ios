//
//  FSVideoLiveBottomBar.m
//  Fifish
//
//  Created by macpro on 16/8/17.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoLiveBottomBar.h"

#import "FSRovDirectionView.h"

@interface FSVideoLiveBottomBar ()


//右边的方向显示view
@property (nonatomic, strong) FSRovDirectionView * directionView;

@end

@implementation FSVideoLiveBottomBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.directionView];
        [self.directionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.left.equalTo(self.mas_left).offset(20);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

-(FSRovDirectionView *)directionView{
    if (!_directionView) {
        _directionView = [[FSRovDirectionView alloc] init];
    }
    return _directionView;
}

@end
