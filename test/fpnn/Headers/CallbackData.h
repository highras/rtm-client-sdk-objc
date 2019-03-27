//
//  CallbackData.h
//  fpnn
//
//  Created by dixun on 2018/5/28.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef CallbackData_h
#define CallbackData_h

#import <Foundation/Foundation.h>

@class FPData;

@interface CallbackData : NSObject

@property(nonatomic, readwrite, assign) NSInteger mid;

@property(nonatomic, readonly, strong) FPData * data;
@property(nonatomic, readonly, strong) NSError * error;
@property(nonatomic, readonly, strong) NSObject * payload;

- (instancetype)initWithData:(FPData *)data;
- (instancetype)initWithError:(NSError *)error;
- (instancetype)initWithPayload:(NSObject *)payload;

- (void) checkError:(NSDictionary *)data andIsAnswerErr:(BOOL)isAnswerErr;
@end

#endif /* CallbackData_h */
