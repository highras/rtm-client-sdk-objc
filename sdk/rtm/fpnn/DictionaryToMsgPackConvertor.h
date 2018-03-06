//
//  DictionaryToMsgPackConvertor.h
//  fpnn
//
//  Created by 施王兴 on 2017/11/23.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryToMsgPackConvertor : NSObject

- (BOOL)convertFrom:(NSDictionary*)payload toCppString:(void*)stringPtr;

@end
