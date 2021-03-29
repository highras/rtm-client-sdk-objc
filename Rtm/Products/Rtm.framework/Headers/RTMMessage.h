//
//  RTMMessage.h
//  Rtm
//
//  Created by zsl on 2020/8/4.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMAudioInfo.h"
#import "RTMTranslatedInfo.h"
#import "RTMFileInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMMessage : NSObject

@property(nonatomic,assign)int64_t fromUid;
@property(nonatomic,assign)int64_t toId;//根据p2p group room  可代表userId  groupId  roomId
@property(nonatomic,assign)int64_t messageType;
@property(nonatomic,assign)int64_t messageId;
@property(nonatomic,copy)NSString * stringMessage;
@property(nonatomic,strong)NSData * binaryMessage;
@property(nonatomic,copy,nullable)NSString * attrs;
@property(nonatomic,assign)int64_t modifiedTime;
@property(nonatomic,strong)RTMFileInfo * fileInfo;
@property(nonatomic,strong)RTMTranslatedInfo * translatedInfo;//chat结构


@end

NS_ASSUME_NONNULL_END
