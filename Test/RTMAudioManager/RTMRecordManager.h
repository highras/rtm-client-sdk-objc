//
//  RTMRecordManager.h
//  Test
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Rtm/Rtm.h>
NS_ASSUME_NONNULL_BEGIN

@interface RTMRecordManager : NSObject

-(void)startRecordWithLang:(NSString * _Nonnull)lang;
-(void)stopRecord:(void(^)(RTMAudioModel * audioModel))recorderFinish;


@end

NS_ASSUME_NONNULL_END
