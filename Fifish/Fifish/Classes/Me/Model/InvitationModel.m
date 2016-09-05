//
//  InvitationModel.m
//  Fiu
//
//  Created by THN-Dong on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "InvitationModel.h"

@implementation InvitationModel

-(instancetype)initWithHeadStr:(NSString *)headStr :(NSString *)titlrStr :(NSString *)sumStr{
    if (self = [super init]) {
        self.headImageStr = headStr;
        self.titleStr = titlrStr;
        self.sumStr = sumStr;
    }
    return self;
}

@end
