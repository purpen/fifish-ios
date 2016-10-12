//
//  FSRegulateCollectionView.h
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSRegulateCollectionViewDelegate <NSObject>

- (void)RegulateSeletedParameter:(NSIndexPath *)indexPath;


@end

@interface FSRegulateCollectionView : UICollectionView

@property (nonatomic,assign) id<FSRegulateCollectionViewDelegate>FSRegulateDelegate;


@end
