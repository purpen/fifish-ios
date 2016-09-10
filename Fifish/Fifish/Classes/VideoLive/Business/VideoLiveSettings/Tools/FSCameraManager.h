//
//  FSCameraManager.h
//  Fifish
//
//  Created by macpro on 16/9/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const RecordAPI = @"CW_JSON_ManualRecord";//录制

static NSString * const TakePhotoAPI = @"CW_JSON_SnapPic";//拍照

static NSString * const GetRecordInfoAPI =@"CW_JSON_GetVideoEncodeEx";//查询视频编码信息

static NSString * const SetRecordInfoAPI =@"CW_JSON_SetVideoEncodeEx";//设置视频编码信息

static NSString * const GetVideoInfoAPI =@"CW_JSON_GetVideo";//设置视频编码信息


typedef void(^RequestSuccessBlock)(NSDictionary * responseObject);
typedef void(^RequestFailureBlock)(NSError * error);


@interface FSCameraManager : NSObject
#pragma mark 录制
/**
 *  @author MC
 *
 *  开始录制
 *
 *  @param successblock 返回成功字典
 *  @param failBlock    返回失败信息
 */
- (void)RovStarRecordSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock;
/**
 *  @author MC
 *
 *  停止录制
 *
 *  @param successblock 返回成功字典
 *  @param failBlock    返回失败error
 */
- (void)RovstopRecordSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock;

/**
 *  @author MC
 *
 *  拍照
 *
 *  @param successblock 成功回调
 *  @param failBlock    失败
 */
- (void)RovTakePhotoSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock;


#pragma mark 编码信息
/**
 *  @author MC
 *
 *  获取编码信息
 *
 *  @param successblock 成功回调
 *  @param failBlock    失败回调
 */
- (void)getVideoEncordeInfoWithSuccessBlock:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock;


/**
 *  @author MC
 *
 *  设置视频帧率和分辨率
 *
 *  @param endcodingInfo 视频信息
 *  @param successblock  成功回调
 *  @param failBlock     失败
 */
- (void)RovSetEncodeingInfo:(NSDictionary *)endcodingInfo Success:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock;

#pragma mark camera相关
/**
 *  @author MC
 *
 *  获取摄像机信息
 *
 *  @param successblock 成功回调
 *  @param failBlock    失败回调
 */
- (void)RovGetCameraSuccess:(RequestSuccessBlock)successblock WithFailureBlock:(RequestFailureBlock)failBlock;

@end
