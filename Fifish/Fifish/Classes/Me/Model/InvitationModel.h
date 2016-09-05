//
//  InvitationModel.h
//  Fiu
//
//  Created by THN-Dong on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitationModel : NSObject

@property(nonatomic,strong) NSString *headImageStr;
@property(nonatomic,strong) NSString *titleStr;
@property(nonatomic,strong) NSString *sumStr;

-(instancetype)initWithHeadStr:(NSString*)headStr :(NSString*)titlrStr :(NSString*)sumStr;;

@end
