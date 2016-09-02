//
//  FSVideoDepthRulerView.m
//  Fifish
//
//  Created by macpro on 16/9/2.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoDepthRulerView.h"
#import "Masonry.h"
#import "FSRulersScrollView.h"
@interface FSVideoDepthRulerView()

//左边刻度尺
@property (nonatomic, strong)FSRulersScrollView * leftRulersScrowView;

//右边刻度尺
@property (nonatomic, strong)FSRulersScrollView * rightRulersScrowView;

@end


@implementation FSVideoDepthRulerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    
    [self addSubview:self.leftRulersScrowView];
    
    [self.leftRulersScrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.bottom.mas_equalTo (self.mas_bottom).offset(-20);
        make.width.mas_equalTo(@30);
        make.centerX.equalTo(self.mas_centerX).offset(-100);
    }];
}
-(FSRulersScrollView *)leftRulersScrowView{
    if (!_leftRulersScrowView) {
        
        _leftRulersScrowView = [[FSRulersScrollView alloc] initWithMinValue:0 WithMaxValue:100.0 WithStpe:3.f WithFrame:CGRectMake(0, 0, 30, self.frame.size.height-40)];
        _leftRulersScrowView.backgroundColor =[UIColor clearColor];

    }
    return _leftRulersScrowView;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
