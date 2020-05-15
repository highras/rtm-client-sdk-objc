//
//  ViewController.m
//  Test
//
//  Created by zsl on 2019/12/11.
//  Copyright © 2019 FunPlus. All rights reserved.
//
#import "VoiceConverter.h"
#import "RtmVoiceConverterManager.h"
#import "ViewController.h"
#import <Rtm/Rtm.h>
#import <AVFoundation/AVFoundation.h>
#import "PressureTestViewController.h"
#define NSAllLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
@interface ViewController ()<RTMProtocol,AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong)RTMClient * client;
@property(nonatomic,strong)RTMClient * client2;

@property (nonatomic, strong, nullable) NSObject *target;
@property (nonatomic, strong, nullable) NSTimer *timer;

@end

@implementation ViewController
-(void)dealloc{
    NSLog(@"ViewController dealloc");
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    PressureTestViewController * vc = [PressureTestViewController new];
//    [self presentViewController:vc animated:YES completion:nil];

//    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"timg"], 0);
//
//    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TestMp3" ofType:@"mp3"];
//
//    NSData * voiceData= [NSData dataWithContentsOfFile:filePath];
    
}
- (void)rtmConnectStateSuccess:(nonnull RTMClient *)client {
    NSLog(@" 连接成功  %d %@",client.isConnected,client.connectedHost);
}

- (void)rtmConnectstateClose:(nonnull RTMClient *)client {
    NSLog(@" 连接断开  %d %@",client.isConnected,client.connectedHost);
}

- (void)rtmKickout:(nonnull RTMClient *)client {
    NSLog(@" rtmKickout  %@",client);
}

- (void)rtmReceiveBroadcastData:(nonnull RTMClient *)client data:(NSDictionary * _Nullable)data {
    NSLog(@" rtmReceiveBroadcastData  %@ %@",client,data);
}

- (void)rtmReceiveGroupData:(nonnull RTMClient *)client data:(NSDictionary * _Nullable)data {
    NSLog(@" rtmReceiveGroupData  %@ %@",client,data);
}

- (void)rtmReceivePtoPData:(nonnull RTMClient *)client data:(NSDictionary * _Nullable)data {
    NSAllLog(@" rtmReceivePtoPData  %@ %@",client,data);
    
    if ([[data objectForKey:@"mtype"] intValue] == 31) {// 音频
        
        NSData * audioData = [data objectForKey:@"msg"];
        NSString * wavPath = [self _voiceConvertAmrToWavFromFilePath:audioData];
        NSData * wavData = [NSData dataWithContentsOfFile:wavPath];
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:wavData error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
        
    }
    
}

- (void)rtmReceiveRoomData:(nonnull RTMClient *)client data:(NSDictionary * _Nullable)data {
    NSLog(@" rtmReceiveRoomData  %@ %@",client,data);
}

- (void)rtmRoomKickoutData:(RTMClient *)client data:(NSDictionary *)data{
    NSLog(@" rtmRoomKickoutData  %@ %@",client,data);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self _addSubView];
      
    
    self.client = [RTMClient clientWithEndpoint:@"52.83.245.22:13325"
                                            pid:90000014
                                            uid:11
                                          token:@"754F512B614FADC445971356CF191C09"];//server 获取 1天过期
//    self.client.version = @"1.1.1";
    __weak typeof(self) weakSelf = self;
    
    self.client.delegate = self;
    
    [self.client verifyConnectSuccess:^(NSDictionary * _Nullable data) {
         __strong typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"验证成功 verifyConnectSuccess  %ld",(long)strongSelf.client.clientStatus);
        //[strongSelf event];
        //子线程 耗时操作
        dispatch_async(dispatch_get_main_queue(), ^{
            //ui操作
        });
        
    } connectFali:^(FPNError * _Nullable error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"验证失败 verifyConnectFail  %ld",(long)strongSelf.client.clientStatus);
        
    }];
    

    
}



-(void)event{
    
    NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
    NSTimeInterval durationTime = [self audioDurationFromURL:wavPath];
    NSString * amrPath = [self _voiceConvertWavToAmrFromFilePath:wavPath];
    
    if (amrPath) {
        
        [self.client sendAudioMessageChatWithId:[NSNumber numberWithInt:12] audioFilePath:amrPath attrs:@{} lang:@"cn" duration:durationTime * 1000 timeout:20 tag:@"" success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
            
            NSLog(@"%@",data);
            
        } fail:^(FPNError * _Nullable error, id  _Nullable tag) {

        }];
        
    }


    
    
//    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"timg"], 0);
//    [self.client sendSingleFileWithId:[NSNumber numberWithLongLong:12] fileData:imageData fileName:@"img" fileSuffix:@"jpeg" fileType:RTMImage timeout:11 tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
//
//    } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
//
//    }];
//
//    sleep(3);
//
    
//    [self.client sendSingleMessageWithId:[NSNumber numberWithInt:12] messageType:[NSNumber numberWithInt:88] message:@"ni hao" attrs:@"" timeout:10 tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
//
//    } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
//
//
//    }];
    
//    [self.client enterRoomWithId:[NSNumber numberWithLongLong:12] timeout:11 tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
//        NSLog(@"进入房间");
////        [self.client sendRoomMessageChatWithId:[NSNumber numberWithLongLong:12] message:@"hello" attrs:@"attrs" timeout:11 tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
////            NSLog(@"完成发送房间消息");
////        } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
////
////        }];
////
//    } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
//
//    }];
    
//    [self.client getUnreadMessagesWithClear:NO timeout:nil tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
//        NSLog(@"%@",data);
//    } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
//
//    }];
    
//    [self.client sendSingleMessageChatWithId:[NSNumber numberWithInt:11]  message:@"zzzz@" attrs:@"" timeout:11 tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
//        NSLog(@"%@",data);
//    } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
//
//    }];
    
}

-(void)btnClick{
    [self.client reconnect];
}
-(void)btnClick2{
    [self.client closeConnect];
}
-(void)btnClick3{
     
}
-(void)_addSubView{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 50, 88, 88);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(50, 200, 88, 88);
    btn2.backgroundColor = [UIColor yellowColor];
    [btn2 addTarget:self action:@selector(btnClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(50, 350, 88, 88);
    btn3.backgroundColor = [UIColor blueColor];
    [btn3 addTarget:self action:@selector(btnClick3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}

- (NSTimeInterval)audioDurationFromURL:(NSString *)url {
    AVURLAsset *audioAsset = nil;
    NSDictionary *dic = @{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)};
    if ([url hasPrefix:@"http://"]) {
        audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:dic];
    }else {
        audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:url] options:dic];
    }
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

//wav->amr
- (NSString*)_voiceConvertWavToAmrFromFilePath:(NSString *)filePath{
    
    NSString * tmpDir = NSTemporaryDirectory();
    tmpDir = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_rtm_voice.amr",[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000 * 1000]]];
    
    if ([RtmVoiceConverterManager encodeWavToAmrFromPath:filePath amrSaveToPath:tmpDir]) {
        
        NSLog(@"amr 路径 === %@",tmpDir);
        return tmpDir;
        
    }else{
        return nil;
    }
    
}
//amr->wav
- (NSString*)_voiceConvertAmrToWavFromFilePath:(NSData *)voiceData{
    
    if (voiceData) {
        
        NSString * tmpDir = NSTemporaryDirectory();
        NSString * amrTmpDir = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_rtm_voice.amr",[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000 * 1000]]];
        NSString * wavTmpDir = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_rtm_voice.wav",[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000 * 1000]]];
        

        if ([voiceData writeToFile:amrTmpDir atomically:YES]) {
            
            if ([RtmVoiceConverterManager decodeAmrToWavFromPath:amrTmpDir wavSaveToPath:wavTmpDir]) {
                
                NSLog(@"wav 路径 === %@",wavTmpDir);
                return wavTmpDir;
                
                
            }else{
                
                return nil;
            }
            
            
        }else{
            
            return nil;
            
        }
        
        
    }else{
        
        return nil;
        
    }
    
    
}

@end
//    NSDictionary * dic =
//    @{@"key":
//
//    @{
//
//        @"value":@[
//                        @"777",
//                        @{
//                        @"value1":@"1",
//                        @"value2":@{@"aaa":@{@"bbb":@"bbb"}}
//                        },
//                        @"9999999",
//                        @[@[@"33553084",@"33553084",@"33553084"],@[@"33553084",@"33553084",@"33553084"]],
//                        @[@"bbbbbb"],
//                        @{
//                        @"value3":@[@{@"bbb":@"bbb"},@"fff"],
//                        @"value4":@[@"FFF",@{@"bbb":@"bbb"}]
//                        },
//                        @{
//                        @"value5":@[@"123",@{@"rrr":@"bbb"}]
//                        },
//                        @"6666",
//                        @{
//                        @"value7":@[@"123",@{@"rrr":@"bbb"},@[@"888"],@{@"hhhh":@"hhhh"}]
//                        },
//                   ]
//
//    }
//
//    };
//
//    NSDictionary * dic2 =
//    @{
//        @"begin":@"33",
//        @"msg" : @[
//                @[@"33553084",@"33553084",@"33553084"]
//
//
//
//        ]
//
//    };
//
//
