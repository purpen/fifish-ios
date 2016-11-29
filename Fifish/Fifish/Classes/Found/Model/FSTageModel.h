//
//  FSTageModel.h
//  Fifish
//
//  Created by THN-Dong on 16/9/21.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

@interface FSTageModel : JKDBModel

/**  */
@property(nonatomic,copy) NSString *tagId;
/**  */
@property(nonatomic,copy) NSString *name;
/**  */
@property(nonatomic,copy) NSString *display_name;
/**  */
@property(nonatomic,copy) NSString *cover;

@end
