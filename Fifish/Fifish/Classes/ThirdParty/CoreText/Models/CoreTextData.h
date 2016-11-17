//
//  CoreTextData.h
//  CoreTextDemo
//

#import <Foundation/Foundation.h>
#import "CoreTextImageData.h"
#import "CoreText/CoreText.h"

@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray * imageArray;
@property (strong, nonatomic) NSArray * linkArray;
@property (strong, nonatomic) NSAttributedString *content;

@end
