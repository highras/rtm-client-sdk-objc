//
//  RTMCountAnswer.h
//  Rtm
//
//  Created by zsl on 2020/12/8.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMBaseAnswer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTMRoomMemberCountAnswer : RTMBaseAnswer
@property(nonatomic,assign)NSDictionary <NSString*,NSArray*>* countDictionary; //@{roomId : @[count]}
@end

NS_ASSUME_NONNULL_END
