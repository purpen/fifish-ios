//
//  FSBorswerImageCell.m
//  Fifish
//
//  Created by macpro on 16/8/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBorswerImageCell.h"
#import "FSVideoModel.h"
#import "FSImageModel.h"

#import "UIImageView+WebCache.h"
@implementation FSBorswerImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setFileUrlStr:(NSString *)fileUrlStr{
    
  
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.seletedBtn.selected = selected;
}
- (void)setMediaModel:(FSMediaModel *)mediaModel{
        _mediaModel = mediaModel;
    if ([mediaModel isKindOfClass:[FSVideoModel class]]) {
        //强转类型
        FSVideoModel *  videoModel = (FSVideoModel *)mediaModel;
        NSLog(@"视频");
        self.durationLab.hidden = NO;
        self.videoIcon.hidden = NO;
        self.borswerImageView.image = videoModel.VideoPicture;
        NSInteger minute = videoModel.duration/60.0;
        NSInteger second = videoModel.duration%60;
        self.durationLab.text = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    }
    
   else if ([mediaModel isKindOfClass:[FSImageModel class]]) {
        NSLog(@"图片");
        self.durationLab.hidden = YES;
        self.videoIcon.hidden = YES;
        FSImageModel*  imagemediaModel = (FSImageModel *)mediaModel;
        self.borswerImageView.image = imagemediaModel.defaultImage;
        
    }
   else{
       NSLog(@"没有");
       
   }
}
@end
