//
//  FSVideoLiveBottomBar.m
//  Fifish
//
//  Created by macpro on 16/8/17.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoLiveBottomBar.h"

#import "FSRovDirectionView.h"

#import "FSRovMapView.h"

@interface FSVideoLiveBottomBar ()


//右边的方向显示view
@property (nonatomic, strong) FSRovDirectionView * directionView;

/**
 Rov路径显示View
 */
@property (nonatomic, strong) FSRovMapView       * RovMapView;

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
        
        [self addSubview:self.RovMapView];
        [self.RovMapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 120));
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
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

-(FSRovMapView *)RovMapView{
    if (!_RovMapView) {
        _RovMapView = [[FSRovMapView alloc] init];
        
    }
    return _RovMapView;
}

@end
 
