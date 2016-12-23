//
//  FSImageBrowserFlowLayout.m
//  Fifish
//
//  Created by THN-Dong on 2016/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageBrowserFlowLayout.h"

@implementation FSImageBrowserFlowLayout

-(instancetype)init{
    if (self = [super init]) {
        self.itemSize = CGSizeMake(KImageBrowserWidth, SCREEN_HEIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0.0f;
        self.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    return self;
}

@end
