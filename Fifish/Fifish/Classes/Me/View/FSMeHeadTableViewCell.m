//
//  FSMeHeadTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/7/28.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMeHeadTableViewCell.h"
#import "FSConst.h"

@implementation FSMeHeadTableViewCell


//-(instancetype)init{
//    if (self = [super init]) {
//        if (self.zuoPinBtn.selected) {
//            self.zuoPinShu.textColor = DEFAULT_COLOR;
//            self.zuoPinLabel.textColor = DEFAULT_COLOR;
//            self.guanZhuBtn.selected = NO;
//            self.fenSiBtn.selected = NO;
//        }else{
//            self.zuoPinShu.textColor = [UIColor whiteColor];
//            self.zuoPinLabel.textColor = [UIColor whiteColor];
//        }
//        
//        if (self.guanZhuBtn.selected) {
//            self.guanZhuShuLabel.textColor = DEFAULT_COLOR;
//            self.guanZhuLabel.textColor = DEFAULT_COLOR;
//            self.zuoPinBtn.selected = NO;
//            self.fenSiBtn.selected = NO;
//        }else{
//            self.guanZhuShuLabel.textColor = [UIColor whiteColor];
//            self.guanZhuLabel.textColor = [UIColor whiteColor];
//        }
//        
//        if (self.fenSiBtn.selected) {
//            self.fenSiShuLabel.textColor = DEFAULT_COLOR;
//            self.fenSiLabel.textColor = DEFAULT_COLOR;
//            self.guanZhuBtn.selected = NO;
//            self.zuoPinBtn.selected = NO;
//        }else{
//            self.fenSiShuLabel.textColor = [UIColor whiteColor];
//            self.fenSiLabel.textColor = [UIColor whiteColor];
//        }
//    }
//    return self;
//}

-(instancetype)init{
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    }
    return self;
}

@end
