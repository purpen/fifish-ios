//
//  FSHomeModel.m
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeModel.h"

@interface FSHomeModel ()

{
    CGFloat _cellHeghit;
}

@end

@implementation FSHomeModel

-(CGFloat)cellHeghit{
    if (!_cellHeghit) {
        _cellHeghit = 300;
    }
    return _cellHeghit;
}

@end
