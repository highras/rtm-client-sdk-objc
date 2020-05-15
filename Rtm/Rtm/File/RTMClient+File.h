//
//  RTMClient+File.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RTMFileType)
{
    RTMImage = 0,
    RTMVoice = 1,
    RTMVideo = 2,
    RTMOther = 3,
};
@interface RTMClient (File)


/// p2p 发送文件 mtype=40图片  mtype=41语音  mtype=42视频
/// @param userId 发给谁
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendP2PFileWithId:(NSNumber * _Nonnull)userId
                fileData:(NSData * _Nonnull)fileData
                fileName:(NSString * _Nonnull)fileName
              fileSuffix:(NSString * _Nonnull)fileSuffix
                fileType:(RTMFileType)fileType
                 timeout:(int)timeout
                     tag:(id _Nullable)tag
                 success:(RTMAnswerSuccessCallBack)successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;

/// group 发送文件 mtype=40图片  mtype=41语音  mtype=42视频
/// @param groupId 群组id
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupFileWithId:(NSNumber * _Nonnull)groupId
                   fileData:(NSData * _Nonnull)fileData
                   fileName:(NSString * _Nonnull)fileName
                 fileSuffix:(NSString * _Nonnull)fileSuffix
                   fileType:(RTMFileType)fileType
                    timeout:(int)timeout
                       tag:(id _Nullable)tag
                    success:(RTMAnswerSuccessCallBack)successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;

/// room 发送文件  mtype=40图片  mtype=41语音  mtype=42视频
/// @param roomId 房间id
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param timeout 请求超时时间 秒
/// @param tag 请求标识
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendRoomFileWithId:(NSNumber * _Nonnull)roomId
                 fileData:(NSData * _Nonnull)fileData
                 fileName:(NSString * _Nonnull)fileName
               fileSuffix:(NSString * _Nonnull)fileSuffix
                 fileType:(RTMFileType)fileType
                  timeout:(int)timeout
                      tag:(id _Nullable)tag
                  success:(RTMAnswerSuccessCallBack)successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;

@end

NS_ASSUME_NONNULL_END
