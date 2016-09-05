//
//  RovInfo.h
//  scoketDemo
//
//  Created by macpro on 16/8/30.
//  Copyright © 2016年 M-C_mac. All rights reserved.
//

#import <Foundation/Foundation.h>
struct RovinfoStruct{
    unsigned char packet_Header[2];//包头
    unsigned char temp[2];//温度
    unsigned char depth[2];//深度
    unsigned char heading_angle[2];//偏航角
    unsigned char pitch_angle[2];//俯仰角
    unsigned char roll_angle[2];//翻滚角
    unsigned char battery;
    unsigned char I_O;//开关
    unsigned char sonar_lenth;//声呐距离
    unsigned char reserver1;//预留字段
    unsigned char reserver2;
    unsigned char packetEnd;//包尾
};

@protocol RovInfoDelegate <NSObject>

- (void)UpdataNewInfoWithRovInfo:(struct RovinfoStruct)rovinfo;



@end


@interface RovInfo : NSObject
//温度
@property (nonatomic,strong) NSString  * Temp;
/**
 *  @author MC
 *
 *  Depth：0-99.9米（范围）
 *  例：当前为90.9米
 *  数据处理方法为：90.9*10 =909
 *  转换为16进制  ：909 = 0x38D
 *  所以  Depth_H = 0x03
 *  Depth_L = 0x8D
 */
@property (nonatomic) CGFloat Depth;
/**
 *  @author MC
 *
 *  Heading: 0-360度 （偏航角）
 *  例：当前为 180.5度
 *  数据处理方法为：180.5*10 =1805
 *  转换为16进制  ：1805 = 0x70D
 *  所以  Depth_H = 0x07
 *  Depth_L = 0x0D
 *  刻度尺显示：
 S            SW		   W		   NW		    N		     NE		    E		     SE		     S
 |------------|------------|-----------|------------|------------|----------|------------|-----------|
 360                      270		               180	   	                90		               	 0
 *   数值计算：
 *   0<X<=90：Y=X;
 *   90<X<=180：Y=180-X;
 *   180<X<=270：Y=X-180;
 *   270<X<=360：Y=360-X;
 *
 */
@property (nonatomic) CGFloat Heading_angle;
/**
 *  @author MC
 *
 *    Pitch/Roll：-90 至 90（俯仰角）
 *  例：当前为 -45度
 *  数据处理方法 ：-45+90 = 45
 *  转换为16进制 ：45 = 0x2D
 *  所以   Pitch_H = 0x00
 *  Pitch_L = 0x2D

 *  当前为 45度
 *  数据处理方法 ：45+90 = 135
 *  转换为16进制 ：135   = 0x87
 *  所以   Pitch_H = 0x00
 *  Pitch_L = 0x87
 */
@property (nonatomic) CGFloat Pitch_angle;
/**
 *  @author MC
 *
 *  翻滚角(同上)
 */
@property (nonatomic) CGFloat Roll_angle;
/**
 *  @author MC
 *
 *  Batt ：0% - 100%  步进 5% (电量)
 *  以16进制存储
 */
@property (nonatomic) CGFloat Remain_battery;
@property (nonatomic , strong) NSString * IO_Switch;
/**
 *  @author MC
 *
 *  声呐距离
 */
@property (nonatomic , strong) NSString * Sonar_length;


@property (nonatomic,assign)id<RovInfoDelegate>delegate;


//刷新rov数据
- (void)updataWithRovDataInfo:(NSData *)rovDataInfo;

+ (RovInfo *)sharedManager;
@end
