//
//  FSImageItem.h
//  Fifish
//
//  Created by THN-Dong on 2016/12/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSImageBrowserModel.h"

@protocol FSImageItemProtocol <NSObject>

@optional
-(void)didClickedItemToHide;
-(void)didFinishedDownLoadHDImage;

@end

@interface FSImageItem : UIScrollView

@property (nonatomic, assign, getter=isFirstShow) BOOL firstShow;
@property (nonatomic, weak) id <FSImageItemProtocol> eventDelegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) FSImageBrowserModel *imageModel;

-(void)loadHdImage:(BOOL)animated;

@end
