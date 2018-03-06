//
//  FPNNMessageConvertor.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/20.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FPNNAnswer;

@interface FPNNMessageConvertor : NSObject

/*
 quest is &(const fpnn::FPQuestPtr), CANNOT be NULL.
 Maybe return nil.
 */
+ (NSDictionary*)convertFPQuest:(const void*)quest;

/*
 answer is &(const fpnn::FPAnswerPtr), CANNOT be NULL.
 Never return nil.
 */
+ (FPNNAnswer*)convertFPAnswer:(const void*)answer;

@end
