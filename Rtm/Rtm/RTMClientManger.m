//
//  RTMClientManger.m
//  Rtm
//
//  Created by zsl on 2020/1/19.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "RTMClientManger.h"
@interface RTMClientManger()
//@property(nonatomic,strong)NSHashTable * weakRecordArray;
@end
@implementation RTMClientManger
//+ (instancetype)shareInstance{
//    static RTMClientManger *_mySingle = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _mySingle = [[RTMClientManger alloc] init];
//    });
//    return _mySingle;
//}
//-(void)addRecordClient:(RTMClient *)client{
//
//    if (_weakRecordArray == nil) {
//        _weakRecordArray = [NSHashTable weakObjectsHashTable];
//    }
//    [_weakRecordArray addObject:client];
////    NSLog(@"===%@",_weakRecordArray);
//}
//-(void)applicationDidEnterBackground:(UIApplication *)application{
//    for (RTMClient * client in self.weakRecordArray) {
//        [client closeConnect];
//    }
//}
@end
