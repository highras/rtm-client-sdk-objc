//
//  PayloadDictionaryBuilder.m
//  fpnn
//
//  Created by 施王兴 on 2017/11/22.
//  Copyright © 2017年 FunPlus. All rights reserved.
//

#import "PayloadDictionaryBuilder.h"
typedef NS_ENUM(NSInteger, HandleType)
{
    noThing = 0,
    key = 1,
    value = 2,
};
@interface PayloadDictionaryBuilder ()

- (void)buildAction:(int)actionId;

@property(nonatomic,strong)PayloadDictionaryBuilder * tmpBuilder;
@property(nonatomic,assign)HandleType handleType;


@end


void buildActionFunc(void* obj, int actionId) {
    [(__bridge PayloadDictionaryBuilder*)obj buildAction:actionId];
}
void addPositiveIntFunc(void* obj, uint64_t v) {
    [(__bridge PayloadDictionaryBuilder*)obj addPositiveInt:v];
}
void addNegativeIntFunc(void* obj, int64_t v) {
    [(__bridge PayloadDictionaryBuilder*)obj addNegativeInt:v];
}
void addFloatFunc(void* obj, float v) {
    [(__bridge PayloadDictionaryBuilder*)obj addFloat:v];
}
void addDoubleFunc(void* obj, double v) {
    [(__bridge PayloadDictionaryBuilder*)obj addDouble:v];
}
void addStringFunc(void* obj, const char* buf, uint32_t size) {
    [(__bridge PayloadDictionaryBuilder*)obj addString:buf withLength:size];
}
void addBinaryFunc(void* obj, const char* buf, uint32_t size) {
    [(__bridge PayloadDictionaryBuilder*)obj addBinary:buf withLength:size];
}


@implementation PayloadDictionaryBuilder
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _actionFunc = buildActionFunc;
        _addPositiveIntFunc = addPositiveIntFunc;
        _addNegativeIntFunc = addNegativeIntFunc;
        _addFloatFunc = addFloatFunc;
        _addDoubleFunc = addDoubleFunc;
        _addStringFunc = addStringFunc;
        _addBinaryFunc = addBinaryFunc;
        _handleType = noThing;
        
    }
    return self;
}
- (void)addNil{
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil){
        [_tmpBuilder addNil];
    }else{
        if (_tmpArr) {
            
            [_tmpArr addObject:[NSNull null]];
            
        }else if (_tmpDic){
            
            switch (self.handleType) {
                case key:
                {
                    self.tmpKey = [NSNull null];
                }
                    break;

                case value:
                {
                    self.tmpValue = [NSNull null];
                }
                    break;

                default:
                {
                    //nothing
                }
                    break;
            }
            
        }
    }
}

- (void)addBool:(BOOL)v{
    
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil){
        [_tmpBuilder addBool:v];
    }else{
        NSNumber *number = [NSNumber numberWithBool:v];
        if (_tmpArr) {
            
            [_tmpArr addObject:number];
            
        }else if (_tmpDic){
            
            switch (self.handleType) {
                case key:
                {
                    self.tmpKey = [NSString stringWithFormat:@"%@",number];
                }
                    break;

                case value:
                {
                    self.tmpValue = number;
                }
                    break;

                default:
                {
                    //nothing
                }
                    break;
            }
            
        }
    }
}

- (void)addPositiveInt:(uint64_t)v{
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil){
        [_tmpBuilder addPositiveInt:v];
    }else{
        NSNumber *number = [NSNumber numberWithUnsignedLongLong:v];
        if (_tmpArr) {
            
            [_tmpArr addObject:number];
            
        }else if (_tmpDic){
            
            switch (self.handleType) {
                case key:
                {
                    self.tmpKey = [NSString stringWithFormat:@"%@",number];
                }
                    break;

                case value:
                {
                    self.tmpValue = number;
                }
                    break;

                default:
                {
                    //nothing
                }
                    break;
            }
            
        }
    }
}

- (void)addNegativeInt:(int64_t)v{
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil){
        [_tmpBuilder addNegativeInt:v];
    }else{
        NSNumber *number = [NSNumber numberWithLongLong:v];
        if (_tmpArr) {
            
            [_tmpArr addObject:number];
            
        }else if (_tmpDic){
            
            switch (self.handleType) {
                case key:
                {
                    self.tmpKey = [NSString stringWithFormat:@"%@",number];
                }
                    break;

                case value:
                {
                    self.tmpValue = number;
                }
                    break;

                default:
                {
                    //nothing
                }
                    break;
            }
            
        }
    }
}

- (void)addFloat:(float)v{
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil){
        [_tmpBuilder addFloat:v];
    }else{
        NSNumber *number = [NSNumber numberWithFloat:v];
        if (_tmpArr) {
            
            [_tmpArr addObject:number];
            
        }else if (_tmpDic){
            
            switch (self.handleType) {
                case key:
                {
                    self.tmpKey = [NSString stringWithFormat:@"%@",number];
                }
                    break;

                case value:
                {
                    self.tmpValue = number;
                }
                    break;

                default:
                {
                    //nothing
                }
                    break;
            }
            
        }
    }
}

- (void)addDouble:(double)v{
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil){
        [_tmpBuilder addDouble:v];
    }else{
        NSNumber *number = [NSNumber numberWithDouble:v];
        if (_tmpArr) {
            
            [_tmpArr addObject:number];
            
        }else if (_tmpDic){
            
            switch (self.handleType) {
                case key:
                {
                    self.tmpKey = [NSString stringWithFormat:@"%@",number];
                }
                    break;

                case value:
                {
                    self.tmpValue = number;
                }
                    break;

                default:
                {
                    //nothing
                }
                    break;
            }
            
        }
    }
}

- (void)addString:(const char*)buf withLength:(uint32_t)length{
    
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil) {
        
        [_tmpBuilder addString:buf withLength:length];
        
    }else{
        
        NSString * string = nil;
        NSData * data = nil;
        if (length > 0) {
            string = [[NSString alloc] initWithBytes:buf length:length encoding:NSUTF8StringEncoding];
            if (string == nil) {
                data = [NSData dataWithBytes:buf length:length];
//                string = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
                //c++二进制数当字符串处理  非字符串则 转为nsdata
            }
        }else{
            string = @"";
        }
        //NSLog(@"addString = %@",string);
        if (_tmpArr) {
            
            [_tmpArr addObject:string];
            
        }else if (_tmpDic){
            
            switch (self.handleType) {
                case key:
                {
                    self.tmpKey = string;
                }
                    break;

                case value:
                {
                    if (string == nil) {
                        self.tmpValue = data;
                    }else{
                        self.tmpValue = string;
                    }
                    
                }
                    break;

                default:
                {
                    //nothing
                }
                    break;
            }
            
        }

        
        
    }
    
    
}

- (void)addBinary:(const char*)buf withLength:(uint32_t)length{
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil){
        [_tmpBuilder addBinary:buf withLength:length];
    }else{
        
        NSData *data;
        if (length)
            data = [NSData dataWithBytes:buf length:length];
        else
            data = [NSData data];
        
        if (_tmpArr) {
            
            [_tmpArr addObject:data];
            
        }else if (_tmpDic){
            
            switch (self.handleType) {
                case key:
                {
                    self.tmpKey = [NSString stringWithFormat:@"%@",data];
                }
                    break;

                case value:
                {
                    self.tmpValue = data;
                }
                    break;

                default:
                {
                    //nothing
                }
                    break;
            }
            
        }
    }
}

- (void)startArray{
    
    
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil) {
        
        [_tmpBuilder startArray];
        
    }else{
        
        _tmpBuilder = [PayloadDictionaryBuilder new];
        _tmpBuilder.tmpArr = [NSMutableArray new];
        _tmpBuilder.father = self;
        //NSLog(@"创建array bulid = %@   dic = %p",_tmpBuilder,_tmpBuilder.tmpArr);

        
        
    }
    
    
}

- (void)finishArray{
    
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil){
        [_tmpBuilder finishArray];
    }else{
       // NSLog(@"-----%@  %@  %@  %@",_tmpArr,_tmpDic,self.father.tmpArr,self.father.tmpDic);
        if (self.father.tmpArr) {
            
            if (_tmpArr) {
                
                
                [self.father.tmpArr addObject:_tmpArr];
            }else if (_tmpDic){
                
                
                [self.father.tmpArr addObject:_tmpDic];
            }
           // NSLog(@"999999%@",self.father.tmpArr);
        }else if(self.father.tmpDic){
            
            if (_tmpArr) {
                [self.father.tmpDic setValue:_tmpArr forKey:self.father.tmpKey];
                
            }else if (_tmpDic){
                [self.father.tmpDic setValue:_tmpDic forKey:self.father.tmpKey];
                
            }
           // NSLog(@"88888%@",self.father.tmpDic);
        }
        _tmpArr= nil;
        _tmpDic = nil;
       // NSLog(@"aaarrararara完成 %@   %@",self.father.tmpDic,self.father.tmpArr);
    }
}

- (void)startMap{
    
        if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil) {
            
            [_tmpBuilder startMap];
            
        }else{
            
             if (_mainStart) {
                 
                _mainStart = NO;
                _tmpDic = [NSMutableDictionary dictionary];
               // NSLog(@"第一个 bulid = %@ %p",self,_tmpDic);//0x6000026bdaa0
                 
             }else{
                 
                 _tmpBuilder = [PayloadDictionaryBuilder new];
                 _tmpBuilder.tmpDic = [NSMutableDictionary dictionary];
                 //NSLog(@"创建dic bulid = %@   dic = %p",_tmpBuilder,_tmpBuilder.tmpDic);
                 _tmpBuilder.father = self;

             }
            
        }
    
}

- (void)startMapKey{
    
    self.handleType = key;
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil) {
        [_tmpBuilder startMapKey];
    }else{
        
    }

}

- (void)finishMapKey{
    

}

- (void)startMapValue{
    self.handleType = value;
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil) {
        [_tmpBuilder startMapValue];
    }else{
        
    }
    
}

- (void)finishMapValue{
    
    //NSLog(@"哪个dic finish = %@ %@ %@ 是否完成%d",self,_tmpValue,_tmpKey,_tmpBuilder.buildFinish);
    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil){
        
        [_tmpBuilder finishMapValue];
        
    }else{
        //NSLog(@"kkkkk%@   %@  %@",_tmpDic,_tmpKey,_tmpValue);
        if (_tmpDic && _tmpKey && _tmpValue) {
            
            [_tmpDic setValue:_tmpValue forKey:_tmpKey];
            _tmpValue = nil;
            _tmpKey = nil;
          //  NSLog(@"self = %@ dic = %@ dic地址 = %p key = %@ value = %@",self,_tmpDic,_tmpDic,_tmpKey,_tmpValue);
        }
        
    }
    
    
    
}

- (void)finishMap{
    

    if (_tmpBuilder.tmpArr != nil || _tmpBuilder.tmpDic != nil ){
        
        [_tmpBuilder finishMap];
        
    }else{
//        NSLog(@"======%@  %@  %@  %@",_tmpArr,_tmpDic,self.father.tmpArr,self.father.tmpDic);
        if (self.father.tmpArr) {
            
            if (_tmpArr) {
                [self.father.tmpArr addObject:_tmpArr];
            }else if (_tmpDic){
                [self.father.tmpArr addObject:_tmpDic];
            }
            
        }else if(self.father.tmpDic){
        
            if (_tmpArr) {
                [self.father.tmpDic setValue:_tmpArr forKey:self.father.tmpKey];
            }else if (_tmpDic){
                [self.father.tmpDic setValue:_tmpDic forKey:self.father.tmpKey];
            }

        }
        if (_mainoOver) {
            _buildFinish = YES;
        }else{
            _tmpArr = nil;
            _tmpDic = nil;
        }
        
//        NSLog(@"mmmmmmmmm完成 %@   %@",self.father.tmpDic,self.father.tmpArr);
    }
}



- (void)buildAction:(int)actionId
{
//    NSLog(@"%s   ======   %d",__FUNCTION__,actionId);
//    NSLog(@"%s  %@",__FUNCTION__,self);
    
    if (actionId == FPNN_PDB_StartMap)
    {
        [self startMap];
    }
    else if (actionId == FPNN_PDB_StartMapKey)
    {
        [self startMapKey];
    }
    else if (actionId == FPNN_PDB_FinishMapKey)
    {
        [self finishMapKey];
    }
    else if (actionId == FPNN_PDB_StartMapValue)
    {
        [self startMapValue];
    }
    else if (actionId == FPNN_PDB_FinishMapValue)
    {
        [self finishMapValue];
    }
    else if (actionId == FPNN_PDB_FinishMap)
    {
        [self finishMap];
    }
    else if (actionId == FPNN_PDB_StartArray)
    {
        [self startArray];
    }
    else if (actionId == FPNN_PDB_FinishArray)
    {
        [self finishArray];
    }
    else if (actionId == FPNN_PDB_AddTrue)
    {
        [self addBool:YES];
    }
    else if (actionId == FPNN_PDB_AddFalse)
    {
        [self addBool:NO];
    }
    else if (actionId == FPNN_PDB_AddNil)
    {
        [self addNil];
    }
}

@end
