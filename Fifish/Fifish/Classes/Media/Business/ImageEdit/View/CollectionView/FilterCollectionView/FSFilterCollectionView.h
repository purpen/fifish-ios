//
//  FSFilterCollectionView.h
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSFilterCollectionViewDelegate <NSObject>

- (void)SeletedFilterWithIndex:(NSIndexPath*)indexpath;


@end

@interface FSFilterCollectionView : UICollectionView

@property (nonatomic,assign) id<FSFilterCollectionViewDelegate> FilterDelegate;

@property (nonatomic,assign) NSInteger collectionNumber;


-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
@end
