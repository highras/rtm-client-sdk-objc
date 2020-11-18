//
//  RTMClient+File.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>
#import "RTMAudioModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RTMFileType)
{
    RTMImage = 0,
    RTMVoice = 1,
    RTMVideo = 2,
    RTMOther = 3,
};
@interface RTMClient (File)


/// p2p 发送文件 mtype=40图片  mtype=41语音  mtype=42视频   mtype=50其他
/// 优先判断audioModel为有效则发送音频消息  如果audioModel无效时fileData fileName fileSuffix fileType为必传发送常规文件
/// @param userId 发给谁
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param attrs 自定义属性
/// @param audioModel rtm音频消息模型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendP2PFileWithId:(NSNumber * _Nonnull)userId
                fileData:(NSData * _Nullable)fileData
                fileName:(NSString * _Nullable)fileName
              fileSuffix:(NSString * _Nullable)fileSuffix
                fileType:(RTMFileType)fileType
                   attrs:(NSDictionary * _Nullable)attrs
              audioModel:(RTMAudioModel * _Nullable)audioModel
                 timeout:(int)timeout
                 success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                    fail:(RTMAnswerFailCallBack)failCallback;


/// group 发送文件 mtype=40图片  mtype=41语音  mtype=42视频   mtype=50其他
/// 优先判断audioModel为有效则发送音频消息  如果audioModel无效时fileData fileName fileSuffix fileType为必传发送常规文件
/// @param groupId 群组ID
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param attrs 自定义属性
/// @param audioModel rtm音频消息模型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendGroupFileWithId:(NSNumber * _Nonnull)groupId
                  fileData:(NSData * _Nullable)fileData
                  fileName:(NSString * _Nullable)fileName
                fileSuffix:(NSString * _Nullable)fileSuffix
                  fileType:(RTMFileType)fileType
                     attrs:(NSDictionary * _Nullable)attrs
                 audioModel:(RTMAudioModel * _Nullable)audioModel
                    timeout:(int)timeout
                    success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                       fail:(RTMAnswerFailCallBack)failCallback;


/// room 发送文件  mtype=40图片  mtype=41语音  mtype=42视频   mtype=50其他
/// 优先判断audioModel为有效则发送音频消息  如果audioModel无效时fileData fileName fileSuffix fileType为必传发送常规文件
/// @param roomId 房间Id
/// @param fileData 文件数据
/// @param fileName 文件名字
/// @param fileSuffix 文件后缀
/// @param fileType 文件类型
/// @param attrs 自定义属性
/// @param audioModel rtm音频消息模型
/// @param timeout 请求超时时间 秒
/// @param successCallback 成功回调
/// @param failCallback 失败回调
-(void)sendRoomFileWithId:(NSNumber * _Nonnull)roomId
                 fileData:(NSData * _Nullable)fileData
                 fileName:(NSString * _Nullable)fileName
               fileSuffix:(NSString * _Nullable)fileSuffix
                 fileType:(RTMFileType)fileType
                    attrs:(NSDictionary * _Nullable)attrs
               audioModel:(RTMAudioModel * _Nullable)audioModel
                  timeout:(int)timeout
                  success:(void(^)(RTMSendAnswer * sendAnswer))successCallback
                     fail:(RTMAnswerFailCallBack)failCallback;

@end

NS_ASSUME_NONNULL_END
