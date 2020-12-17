//
//  RTMClient+Encryptor.m
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "RTMClient+Encryptor.h"
#import "FPNNQuest.h"
#import "FPNNTCPClient.h"

@implementation RTMClient (Encryptor)
- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce{
    
    [fpnnMainClient enableEncryptorWithCurve:curve serverPublicKey:publicKey packageMode:packageMode withReinforce:reinforce];
    
}
- (void)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce{
    
    [fpnnMainClient enableEncryptorByDerData:derData packageMode:packageMode withReinforce:reinforce];
    
}
- (void)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce{
    
    [fpnnMainClient enableEncryptorByPemData:pemData packageMode:packageMode withReinforce:reinforce];
    
}
- (void)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce{
    
    [fpnnMainClient enableEncryptorByDerFile:derFilePath packageMode:packageMode withReinforce:reinforce];
    
}
- (void)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce{
    
    [fpnnMainClient enableEncryptorByPemFile:pemFilePath packageMode:packageMode withReinforce:reinforce];
    
    
}
@end
