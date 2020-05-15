//
//  FPError.m
//  Rtm
//
//  Created by zsl on 2019/12/23.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "FPNError.h"
#import <objc/runtime.h>
@implementation FPNError
-(instancetype)initWithEx:(NSString *)ex code:(int)code{
    self = [super init];
    if (self) {
        
        _code = code;
        _ex = ex == nil ? @"" : ex;
        
    }
    return self;
}

+(instancetype)errorWithEx:(NSString*)ex code:(int)code{
    return [[self alloc]initWithEx:ex code:code];
}

- (NSString *)description{
    NSString * desc= [super description];
    desc = [NSString stringWithFormat:@"\n%@\n", desc];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        const char * propName = property_getName(property);
        if (propName) {
            NSString * prop = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
            id obj = [self valueForKey:prop];
            desc = [desc stringByAppendingFormat:@"%@ : %@,\n",prop,obj];
        }
    }
    free(properties);
    return desc;
}
@end
