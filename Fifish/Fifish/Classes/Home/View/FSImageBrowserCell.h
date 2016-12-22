//
//  FSImageBrowserCell.h
//  Fifish
//
//  Created by THN-Dong on 2016/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSImageBrowserModel.h"
#import "FSImageItem.h"

@interface FSImageBrowserCell : UICollectionViewCell

@property (nonatomic, strong) FSImageBrowserModel *imageModel;
@property (nonatomic, strong) FSImageItem *imageItem;

@end
