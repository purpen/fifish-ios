//
//  FSAddTagViewController.h
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseViewController.h"

@protocol FSAddTagViewControllerDelegate <NSObject>

-(void)getTagName:(NSString*)tag andTagId:(NSString*)tagId;

@end

@interface FSAddTagViewController : FSBaseViewController

/**  */
@property (nonatomic, weak) id<FSAddTagViewControllerDelegate> addTagDelegate ;
/**  */
@property(nonatomic,copy) NSString *tags;

@end
