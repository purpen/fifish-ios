//
//  FSHomeModel.m
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeModel.h"

@interface FSHomeModel ()

@end

@implementation FSHomeModel

-(CGFloat)cellHeghit{
    if (!_cellHeghit) {
        _cellHeghit = 300;
        
        if (self.type == FSZuoPinTypePicture) {
            _pictuerF = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        }else if (self.type == FSZuoPinTypeVideo){
            _videoF = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        }
        
    }
    return _cellHeghit;
}


@end
