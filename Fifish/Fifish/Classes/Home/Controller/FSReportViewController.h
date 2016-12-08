//
//  FSReportViewController.h
//  Fifish
//
//  Created by THN-Dong on 2016/11/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseViewController.h"
@class FSZuoPin;

@protocol FSReportViewControllerDelegate <NSObject>

-(void)deleteCellWithCellId:(NSString*)cellId;

@end

@interface FSReportViewController : FSBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewBottomSapce;
/**  */
@property (nonatomic, strong) FSZuoPin *model;
/**  */
@property (nonatomic, weak) id<FSReportViewControllerDelegate> fSReportDelegate;
/**  */
@property (nonatomic, assign) BOOL isMineStuff;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *haChBottomSpace;

@end
