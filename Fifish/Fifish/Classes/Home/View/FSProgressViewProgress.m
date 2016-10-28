//
//  FSProgressView.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/28.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSProgressViewProgress.h"

@implementation FSProgressViewProgress

-(void)awakeFromNib{
    [super awakeFromNib];
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    [super setProgress:progress animated:animated];
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

-(instancetype)init{
    if (self = [super init]) {
        self.roundedCorners = 2;
        self.progressLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
