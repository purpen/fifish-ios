//
//  FSHistoryView.h
//  Fifish
//
//  Created by THN-Dong on 2016/11/30.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSHistoryViewDelegate <NSObject>

-(void)beginSearch:(NSString*)keyStr;

@end

@interface FSHistoryView : UIView

/**  */
@property (nonatomic, weak) id <FSHistoryViewDelegate> hVDelegate;

@end
