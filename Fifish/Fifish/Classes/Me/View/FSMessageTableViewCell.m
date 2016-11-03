//
//  FSMessageTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMessageTableViewCell.h"

@interface FSMessageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation FSMessageTableViewCell

-(void)setDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:dict[@"icon"]];
    self.typeLabel.text = dict[@"typeLabel"];
}

@end
