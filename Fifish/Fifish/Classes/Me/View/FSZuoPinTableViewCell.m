//
//  FSZuoPinTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/8/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSZuoPinTableViewCell.h"
#import "FSZuoPin.h"

@interface FSZuoPinTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation FSZuoPinTableViewCell

-(void)setZuopin:(FSZuoPin *)zuopin{
    _zuopin = zuopin;
    
}

@end
