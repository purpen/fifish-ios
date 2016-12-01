//
//  FSRegulateCollectionView.h
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSRegulateCollectionViewDelegate <NSObject>

- (void)RegulateSeletedParameter:( NSIndexPath * _Nonnull )indexPath;



@end

@interface FSRegulateCollectionView : UICollectionView

@property (nonatomic,assign,nonnull) id<FSRegulateCollectionViewDelegate>FSRegulateDelegate;

//不严谨，后期改为只读属性
@property (nonatomic,strong,nonnull)NSArray * imageArr;
@property (nonatomic,strong,nonnull)NSArray * titleArr;

@end
