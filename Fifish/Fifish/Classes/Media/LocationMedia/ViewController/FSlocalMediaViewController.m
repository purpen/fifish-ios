//
//  FSlocalMediaViewController.m
//  Fifish
//
//  Created by macpro on 16/8/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSlocalMediaViewController.h"

@implementation FSlocalMediaViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
    }
    return self;
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 0;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    if (index < _photos.count)
//        return [_photos objectAtIndex:index];
    return nil;
}
@end
