//
//  FSTipNumberView.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTipNumberView.h"
#import "UIView+FSExtension.h"

@implementation FSTipNumberView

+(instancetype)getTipNumView{
    FSTipNumberView *numV = [FSTipNumberView viewFromXib];
    numV.layer.masksToBounds = YES;
    numV.layer.cornerRadius = 17 * 0.5;
    return numV;
}
@end
