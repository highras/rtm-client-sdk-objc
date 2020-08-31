//
//  RTMRecordManager.h
//  Test
//
//  Created by zsl on 2020/8/13.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMRecordManager : NSObject

-(void)startRecord;
-(void)stopRecord:(void(^)(NSString * _Nullable amrAudioPath,NSString * _Nullable wavAudioPath,double durationTime))recorderFinish;


@end

NS_ASSUME_NONNULL_END
