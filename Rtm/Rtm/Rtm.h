//
//  Rtm.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.1
//



#import <Foundation/Foundation.h>

// 1.在TARGETS->Build Settings->Other Linker Flags （选中ALL视图）中添加-ObjC，字母O和C大写，符号“-”请勿忽略
// 2.静态库中采用Objective-C++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)
// 3.添加库libresolv.9.tbd
// 4.Info.plist 添加麦克风权限 Privacy - Microphone Usage Description

#import <Rtm/RTMClient.h>
#import <Rtm/RTMClientManger.h>
#import <Rtm/RTMAnswer.h>
#import <Rtm/RTMClient+User.h>
#import <Rtm/RTMClient+Friend.h>
#import <Rtm/RTMClient+P2P.h>
#import <Rtm/RTMClient+Group.h>
#import <Rtm/RTMClient+Room.h>
#import <Rtm/RTMClient+Broadcast.h>
#import <Rtm/RTMClient+File.h>
#import <Rtm/RTMClient+Encryptor.h>
#import <Rtm/RTMClient+Tools.h>
#import <Rtm/RTMClient+P2P_Chat.h>
#import <Rtm/RTMClient+Group_Chat.h>
#import <Rtm/RTMClient+Room_Chat.h>
#import <Rtm/RTMClient+Broadcast_Chat.h>
#import <Rtm/RTMMessage.h>
#import <Rtm/RTMAudioInfo.h>
#import <Rtm/RTMTranslatedInfo.h>

//! Project version number for Rtm.
FOUNDATION_EXPORT double RtmVersionNumber;

//! Project version string for Rtm.
FOUNDATION_EXPORT const unsigned char RtmVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Rtm/PublicHeader.h>


