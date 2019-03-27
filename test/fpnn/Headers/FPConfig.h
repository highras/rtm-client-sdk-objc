//
//  FPConfig.h
//  fpnn
//
//  Created by dixun on 2018/5/30.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef FPConfig_h
#define FPConfig_h

#import <Foundation/Foundation.h>

@interface FPConfig : NSObject

+ (Byte *) FPNN_VERSION;
+ (Byte *) FP_FLAG;
+ (Byte *) FP_MESSAGE_TYPE;
+ (Byte *) TCP_MAGIC;
+ (Byte *) HTTP_MAGIC;
+ (NSInteger) READ_BUFFER_LEN;
+ (NSInteger) SEND_TIMEOUT;
+ (NSInteger) MAX_THREAD_COUNT;

enum {
    //for proto
    FPNN_EC_PROTO_UNKNOWN_ERROR = 10001,    // 未知错误(协议解析错误)
    FPNN_EC_PROTO_NOT_SUPPORTED = 10002,    // 不支持的协议
    FPNN_EC_PROTO_INVALID_PACKAGE = 10003,  // 无效的数据包
    FPNN_EC_PROTO_JSON_CONVERT = 10004,     // JSON转换错误
    FPNN_EC_PROTO_STRING_KEY = 10005,       // 数据包错误
    FPNN_EC_PROTO_MAP_VALUE = 10006,        // 数据包错误
    FPNN_EC_PROTO_METHOD_TYPE = 10007,      // 请求错误
    FPNN_EC_PROTO_PROTO_TYPE = 10008,       // 协议类型错误
    FPNN_EC_PROTO_KEY_NOT_FOUND = 10009,    // 数据包错误
    FPNN_EC_PROTO_TYPE_CONVERT = 10010,     // 数据包转换错误
    FPNN_EC_PROTO_FILE_SIGN = 10011,
    
    //for core
    FPNN_EC_CORE_UNKNOWN_ERROR = 20001,     // 未知错误(业务流程异常中断)
    FPNN_EC_CORE_CONNECTION_CLOSED = 20002, // 链接已关闭
    FPNN_EC_CORE_TIMEOUT = 20003,           // 请求超时
    FPNN_EC_CORE_UNKNOWN_METHOD = 20004,    // 错误的请求
    FPNN_EC_CORE_ENCODING = 20005,          // 编码错误
    FPNN_EC_CORE_DECODING = 20006,          // 解码错误
    FPNN_EC_CORE_SEND_ERROR = 20007,        // 发送错误
    FPNN_EC_CORE_RECV_ERROR = 20008,        // 接收错误
    FPNN_EC_CORE_INVALID_PACKAGE = 20009,   // 无效的数据包
    FPNN_EC_CORE_HTTP_ERROR = 20010,        // HTTP错误
    FPNN_EC_CORE_WORK_QUEUE_FULL = 20011,   // 任务队列满
    FPNN_EC_CORE_INVALID_CONNECTION = 20012,// 无效的链接
    FPNN_EC_CORE_FORBIDDEN = 20013,         // 禁止操作
    
    //for other
    FPNN_EC_ZIP_COMPRESS = 30001,
    FPNN_EC_ZIP_DECOMPRESS = 30002,
};
@end

#endif /* FPConfig_h */
