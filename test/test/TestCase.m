//
//  TestCase.m
//  test
//
//  Created by dixun on 2018/6/14.
//  Copyright © 2018年 funplus. All rights reserved.
//

#import "TestCase.h"
#import "RTMClient.h"
#import "RTMProcessor.h"
#import "RTMConfig.h"
#import "FPEvent.h"
#import "EventData.h"
#import "CallbackData.h"

@interface TestCase() {
    
}
@end


@implementation TestCase

- (instancetype) initWithFile:(NSData *)fileData {
    
    if (self = [super init]) {
        
        _fileData = fileData;
    }
    
    return self;
}

- (void) beginTest {
    
    _client = [[RTMClient alloc] initWithDispatch:@"52.83.245.22:13325" andPid:1000012 andUid:654321 andToken:@"73F472BE6D2594234C711FDA8656722F" andVersion:@"" andAttrs:@{} andReconnect:YES andTimeout:20 * 1000 andStartTimerThread:YES];
    
    [self.client.event addType:@"login" andListener:^(EventData * evd) {
        
        if (evd.error != nil) {
            
            [self onError:evd.error];
            return;
        }
        
        [self onLogin:evd.payload];
    }];
    
    [self.client.event addType:@"close" andListener:^(EventData * evd) {
        
        [self onClose:evd.retry];
    }];
    
    [self.client.event addType:@"error" andListener:^(EventData * evd) {
        
        [self onError:evd.error];
    }];
    
    [self.client.processor.event addType:RTMConfig.SERVER_PUSH_recvPing andListener:^(EventData * evd) {
        
        NSLog(@"[PUSH] %@", evd.type);
    }];
    
    [self.client loginWithEndpoint:nil andIPv6:NO];
}

- (void) onLogin:(NSObject *)payload {
    
    NSLog(@"login: %@", payload);
    
    NSInteger to = 778899;

    NSArray * tos = @[ @654321, @778898, @778899 ];
    NSArray * friends = @[ @778898, @778899 ];
    
    NSInteger gid = 999;
    NSInteger rid = 666;

    NSDictionary * attrs = @{ @"user1": @"test user1 attrs" };
    
    NSInteger timeout = 20 * 1000;
    NSInteger sleep_time = 2;

    NSLog(@"test start!");
    [self threadSleep:sleep_time];

    //rtmGate (2)
    //---------------------------------sendMessage--------------------------------------
    [self.client sendMessage:to andMtype:8 andMessage:@"hello !" andAttrs:@"" andMid:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] sendMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] sendMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (3)
    //---------------------------------sendGroupMessage--------------------------------------
    [self.client sendGroupMessage:gid andMtype:8 andMessage:@"hello !" andAttrs:@"" andMid:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] sendGroupMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] sendGroupMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (4)
    //---------------------------------sendRoomMessage--------------------------------------
    [self.client sendRoomMessage:rid andMtype:8 andMessage:@"hello !" andAttrs:@"" andMid:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] sendRoomMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] sendRoomMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (5)
    //---------------------------------getUnreadMessage--------------------------------------
    [self.client getUnreadMessage:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getUnreadMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] getUnreadMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (6)
    //---------------------------------cleanUnreadMessage--------------------------------------
    [self.client cleanUnreadMessage:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] cleanUnreadMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] cleanUnreadMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (7)
    //---------------------------------getSession--------------------------------------
    [self.client getSession:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getSession: %@", dict);
        } else {
            
            NSLog(@"[ERR] getSession: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (8)
    //---------------------------------getGroupMessage--------------------------------------
    [self.client getGroupMessage:gid andDesc:YES andNumber:10 andBegin:0 andEnd:0 andLastID:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getGroupMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] getGroupMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (9)
    //---------------------------------getRoomMessage--------------------------------------
    [self.client getRoomMessage:rid andDesc:YES andNumber:10 andBegin:0 andEnd:0 andLastID:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getRoomMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] getRoomMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (10)
    //---------------------------------getBroadcastMessage--------------------------------------
    [self.client getBroadcastMessage:YES andNumber:10 andBegin:0 andEnd:0 andLastID:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getBroadcastMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] getBroadcastMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (11)
    //---------------------------------getP2PMessage--------------------------------------
    [self.client getP2PMessage:to andDesc:YES andNumber:10 andBegin:0 andEnd:0 andLastID:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getP2PMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] getP2PMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];
    
    //rtmGate (12)
    //---------------------------------fileToken--------------------------------------
    [self.client fileToken:@"sendfile" andTos:nil andTo:to andRid:0 andGid:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] fileToken: %@", dict);
        } else {
            
            NSLog(@"[ERR] fileToken: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (14)
    //---------------------------------addAttrs--------------------------------------
    [self.client addAttrs:attrs andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] addAttrs: %@", dict);
        } else {
            
            NSLog(@"[ERR] addAttrs: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (15)
    //---------------------------------getAttrs--------------------------------------
    [self.client getAttrs:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getAttrs: %@", dict);
        } else {
            
            NSLog(@"[ERR] getAttrs: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (16)
    //---------------------------------addDebugLog--------------------------------------
    [self.client addDebugLog:@"msg" andAttrs:@"attrs" andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] addDebugLog: %@", dict);
        } else {
            
            NSLog(@"[ERR] addDebugLog: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (17)
    //---------------------------------addDevice--------------------------------------
    [self.client addDevice:@"app-info" andDeviceToken:@"device-token" andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] addDevice: %@", dict);
        } else {
            
            NSLog(@"[ERR] addDevice: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (18)
    //---------------------------------removeDevice--------------------------------------
    [self.client removeDevice:@"device-token" andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] removeDevice: %@", dict);
        } else {
            
            NSLog(@"[ERR] removeDevice: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (19)
    //---------------------------------setTranslationLanguage--------------------------------------
    [self.client setTranslationLanguage:@"en" andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] setTranslationLanguage: %@", dict);
        } else {
            
            NSLog(@"[ERR] setTranslationLanguage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (20)
    //---------------------------------translate--------------------------------------
    [self.client translate:@"你好!" andOriginalLanguage:nil andTargetLanguage:@"en" andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] translate: %@", dict);
        } else {
            
            NSLog(@"[ERR] translate: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (21)
    //---------------------------------addFriends--------------------------------------
    [self.client addFriends:friends andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] addFriends: %@", dict);
        } else {
            
            NSLog(@"[ERR] addFriends: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (22)
    //---------------------------------deleteFriends--------------------------------------
    [self.client deleteFriends:friends andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] deleteFriends: %@", dict);
        } else {
            
            NSLog(@"[ERR] deleteFriends: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (23)
    //---------------------------------getFriends--------------------------------------
    [self.client getFriends:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getFriends: %@", dict);
        } else {
            
            NSLog(@"[ERR] getFriends: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (24)
    //---------------------------------addGroupMembers--------------------------------------
    [self.client addGroupMembers:gid andUIDs:tos andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] addGroupMembers: %@", dict);
        } else {
            
            NSLog(@"[ERR] addGroupMembers: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (25)
    //---------------------------------deleteGroupMembers--------------------------------------
    [self.client deleteGroupMembers:rid andUIDs:tos andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] deleteGroupMembers: %@", dict);
        } else {
            
            NSLog(@"[ERR] deleteGroupMembers: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (26)
    //---------------------------------getGroupMembers--------------------------------------
    [self.client getGroupMembers:gid andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getGroupMembers: %@", dict);
        } else {
            
            NSLog(@"[ERR] getGroupMembers: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (27)
    //---------------------------------getUserGroups--------------------------------------
    [self.client getUserGroups:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getUserGroups: %@", dict);
        } else {
            
            NSLog(@"[ERR] getUserGroups: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (28)
    //---------------------------------enterRoom--------------------------------------
    [self.client enterRoom:rid andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] enterRoom: %@", dict);
        } else {
            
            NSLog(@"[ERR] enterRoom: %@", cbd.error);
        }
    }];
   
    [self threadSleep:sleep_time];

    //rtmGate (29)
    //---------------------------------leaveRoom--------------------------------------
    [self.client leaveRoom:rid andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] leaveRoom: %@", dict);
        } else {
            
            NSLog(@"[ERR] leaveRoom: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (30)
    //---------------------------------getUserRooms--------------------------------------
    [self.client getUserRooms:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getUserRooms: %@", dict);
        } else {
            
            NSLog(@"[ERR] getUserRooms: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (31)
    //---------------------------------getOnlineUsers--------------------------------------
    [self.client getOnlineUsers:tos andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] getOnlineUsers: %@", dict);
        } else {
            
            NSLog(@"[ERR] getOnlineUsers: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (32)
    //---------------------------------deleteMessage--------------------------------------
    [self.client deleteMessage:0 andXID:to andType:1 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] deleteMessage: %@", dict);
        } else {
            
            NSLog(@"[ERR] deleteMessage: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (33)
    //---------------------------------kickout--------------------------------------
    [self.client kickout:@"" andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] kickout: %@", dict);
        } else {
            
            NSLog(@"[ERR] kickout: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (35)
    //---------------------------------dbSet--------------------------------------
    [self.client dbSet:@"db-test-key" andValue:@"db-test-value" andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] dbSet: %@", dict);
        } else {
            
            NSLog(@"[ERR] dbSet: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (34)
    //---------------------------------dbGet--------------------------------------
    [self.client dbGet:@"db-test-key" andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] dbGet: %@", dict);
        } else {
            
            NSLog(@"[ERR] dbGet: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //fileGate (1)
    //---------------------------------sendFile--------------------------------------
    [self.client sendFile:50 andTo:to andFile:self.fileData andMid:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] sendFile: %@", dict);
        } else {
            
            NSLog(@"[ERR] sendFile: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //fileGate (3)
    //---------------------------------sendGroupFile--------------------------------------
    [self.client sendGroupFile:50 andGid:gid andFile:self.fileData andMid:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] sendGroupFile: %@", dict);
        } else {
            
            NSLog(@"[ERR] sendGroupFile: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //fileGate (4)
    //---------------------------------sendRoomFile--------------------------------------
    [self.client sendRoomFile:50 andRid:rid andFile:self.fileData andMid:0 andTimeout:timeout andBlock:^(CallbackData *cbd) {
        
        NSDictionary * dict = (NSDictionary *)cbd.payload;
        
        if (dict != nil) {
            
            NSLog(@"[DATA] sendRoomFile: %@", dict);
        } else {
            
            NSLog(@"[ERR] sendRoomFile: %@", cbd.error);
        }
    }];
    
    [self threadSleep:sleep_time];

    //rtmGate (13)
    //---------------------------------close--------------------------------------
    [self.client close];
    
    NSLog(@"test end! %ld", self.sleep_count - 1);
}

- (void) onClose:(BOOL)retry {
    
    NSLog(@"closed: %@", retry ? @"Yes" : @"No");
}

- (void) onError:(NSError *)error {
    
    NSLog(@"error: %@", error);
}

- (void) threadSleep:(NSInteger)ms {
    
    sleep((int)ms);
    _sleep_count++;
}

@end
