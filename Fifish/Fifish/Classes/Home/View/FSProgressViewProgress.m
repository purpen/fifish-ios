//
//  FSProgressView.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/28.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSProgressViewProgress.h"
#import "UIColor+FSExtension.h"

@implementation FSProgressViewProgress

-(void)awakeFromNib{
    [super awakeFromNib];
    self.roundedCorners = 1;
    self.progressLabel.textColor = [UIColor colorWithHexString:@"#2288FF"];
    self.progressTintColor = [UIColor colorWithHexString:@"#2288FF"];
    self.thicknessRatio = 0.1;
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    [super setProgress:progress animated:animated];
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

-(instancetype)init{
    if (self = [super init]) {
        self.roundedCorners = 1;
        self.progressLabel.textColor = [UIColor colorWithHexString:@"#2288FF"];
        self.progressTintColor = [UIColor colorWithHexString:@"#2288FF"];
        self.thicknessRatio = 0.1;
    }
    return self;
}

@end
