//
//  FPData.h
//  fpnn
//
//  Created by dixun on 2018/5/24.
//  Copyright © 2018年 funplus. All rights reserved.
//

#ifndef FPData_h
#define FPData_h

#import <Foundation/Foundation.h>

@class FPConfig;

@interface FPData : NSObject {
    
}

@property(nonatomic, readwrite, assign) Byte * magic;
@property(nonatomic, readwrite, assign) NSInteger version;
@property(nonatomic, readwrite, assign) NSInteger flag;
@property(nonatomic, readwrite, assign) NSInteger mtype;
@property(nonatomic, readwrite, assign) NSInteger ss;
@property(nonatomic, readwrite, assign) NSInteger seq;
@property(nonatomic, readwrite, assign) NSInteger psize;
@property(nonatomic, readwrite, assign) NSInteger wpos;

@property(nonatomic, readwrite, strong) NSData * buffer;

@property(nonatomic, readwrite, assign) NSInteger pkglen;
@property(nonatomic, readwrite, strong) NSString * method;
@property(nonatomic, readwrite, strong) NSString * json;
@property(nonatomic, readwrite, strong) NSData * msgpack;
@end

#endif /* FPData_h */
