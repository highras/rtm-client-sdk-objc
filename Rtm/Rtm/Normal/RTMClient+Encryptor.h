//
//  RTMClient+Encryptor.h
//  Rtm
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import <Rtm/Rtm.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTMClient (Encryptor)

- (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
- (void)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;

@end

NS_ASSUME_NONNULL_END
