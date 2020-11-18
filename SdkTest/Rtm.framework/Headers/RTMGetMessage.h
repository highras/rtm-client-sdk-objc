//
//  RTMGetMessage.h
//  Rtm
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTMFileInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTMGetMessage : NSObject
@property(nonatomic,assign)int64_t messageType;
@property(nonatomic,assign)int64_t cursorId;
@property(nonatomic,copy)NSString * stringMessage;
@property(nonatomic,strong)NSData * binaryMessage;
@property(nonatomic,strong)NSData * audioMessage;
@property(nonatomic,copy)NSString * attrs;
@property(nonatomic,assign)int64_t modifiedTime;
@property(nonatomic,strong)RTMFileInfo * fileInfo;
@end

NS_ASSUME_NONNULL_END
