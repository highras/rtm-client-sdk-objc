//
//  VVViewController.m
//  Test
//
//  Created by zsl on 2020/1/19.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "RtmVoiceConverterManager.h"
#import <Rtm/Rtm.h>
#import <AVFoundation/AVFoundation.h>
#define NSAllLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,RTMProtocol,AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)NSArray * array;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong)RTMClient * client;
@property(nonatomic,strong)RTMClient * client2;
@property(nonatomic,strong)RTMClient * client3;
@property(nonatomic,strong)RTMClient * client4;
@property(nonatomic,strong)RTMClient * client5;
@property(nonatomic,strong)RTMClient * client6;
@property(nonatomic,strong)RTMClient * client7;
@property(nonatomic,strong)RTMClient * client8;
@end

@implementation MainViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    ViewController * vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}


#pragma mark RTM  代理方法

#pragma mark 状态 delegate
//连接成功
- (void)rtmConnectStateSuccess:(nonnull RTMClient *)client {
    NSLog(@" 连接成功  %d %@ %ld",client.isConnected,client.connectedHost,(long)client.clientStatus);
}
//连接断开
- (void)rtmConnectstateClose:(nonnull RTMClient *)client {
    NSLog(@" 连接断开  %d %@ %ld",client.isConnected,client.connectedHost,(long)client.clientStatus);
}
//被T下线
- (void)rtmKickout:(nonnull RTMClient *)client {
    NSLog(@" rtmKickout  %@",client);
}
//被T出房间
- (void)rtmRoomKickoutData:(RTMClient *)client data:(NSDictionary *)data{
    NSLog(@" rtmRoomKickoutData  %@ %@",client,data);
}

#pragma mark 普通消息 delegate
//normal message
-(void)rtmReceiveP2PData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveP2PData  %@ %@",client,data);
}
-(void)rtmReceiveGroupData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveGroupData  %@ %@",client,data);
}
-(void)rtmReceiveRoomData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveRoomData  %@ %@",client,data);
}
-(void)rtmReceiveBroadcastData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveBroadcastData  %@ %@",client,data);
}

//normal Binary
-(void)rtmReceiveP2PBinaryData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveP2PBinaryData  %@ %@",client,data);
}
-(void)rtmReceiveGroupBinaryData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveGroupBinaryData  %@ %@",client,data);
}
-(void)rtmReceiveRoomBinaryData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveRoomBinaryData  %@ %@",client,data);
}
-(void)rtmReceiveBroadcastBinaryData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveBroadcastBinaryData  %@ %@",client,data);
}


#pragma mark chat delegate

//chat message
-(void)rtmReceiveP2PMessageChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveP2PMessageChat  %@ %@",client,data);
}
-(void)rtmReceiveGroupMessageChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveGroupMessageChat  %@ %@",client,data);
}
-(void)rtmReceiveRoomMessageChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveRoomMessageChat  %@ %@",client,data);
}
-(void)rtmReceiveBroadcastMessageChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveBroadcastMessageChat  %@ %@",client,data);
}

//chat audio
-(void)rtmReceiveP2PAudioChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveP2PAudioChat  %@ %@",client,data);
    
    
    //amr->wav
    NSData * audioData = [data objectForKey:@"msg"];
    NSString * wavPath = [self _voiceConvertAmrToWavFromFilePath:audioData];
    if (wavPath) {
    
        NSData * wavData = [NSData dataWithContentsOfFile:wavPath];
        if (wavData) {
            self.audioPlayer = [[AVAudioPlayer alloc] initWithData:wavData error:nil];
            self.audioPlayer.delegate = self;
            [self.audioPlayer play];
        }
    }
}
-(void)rtmReceiveGroupAudioChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveGroupAudioChat  %@ %@",client,data);
    
}
-(void)rtmReceiveRoomAudioChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveRoomAudioChat  %@ %@",client,data);
    
}
-(void)rtmReceiveBroadcastAudioChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveBroadcastAudioChat  %@ %@",client,data);
}

//chat cmd
-(void)rtmReceiveP2PCmdChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveP2PCmdChat  %@ %@",client,data);
}
-(void)rtmReceiveGroupCmdChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveGroupCmdChat  %@ %@",client,data);
}
-(void)rtmReceiveRoomCmdChat:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveRoomCmdChat  %@ %@",client,data);
}
-(void)rtmReceiveBroadcastCmdChat:(RTMClient *)client data:(NSDictionary * _Nullable)data;{
    NSLog(@" rtmReceiveBroadcastCmdChat  %@ %@",client,data);
}

#pragma mark file delegate
//file
-(void)rtmReceiveP2PFileData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceivePtoPFileData  %@ %@",client,data);
    
    int type = [[data objectForKey:@"mtype"] intValue];
    if (type == 40) {
        //图片文件   返回url
    }
    if (type == 41) {
        //音频文件   返回url
    }
    if (type == 42) {
        //文件   返回url
    }
    if (type == 50) {
        //50 泛指文件，服务器会修改此值（如果服务器可以判断出具体类型的话，仅在mtype=50的情况下）
    }
}
-(void)rtmReceiveGroupFileData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveGroupFileData  %@ %@",client,data);
}
-(void)rtmReceiveRoomFileData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveRoomFileData  %@ %@",client,data);
}
-(void)rtmReceiveBroadcastFileData:(RTMClient *)client data:(NSDictionary * _Nullable)data{
    NSLog(@" rtmReceiveBroadcastFileData  %@ %@",client,data);
}
#pragma mark 一些转换操作的方法
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
    
    NSLog(@"NSTimeInterval  %f",audioDurationSeconds);
    return audioDurationSeconds;
}

//wav->amr
- (NSString*)_voiceConvertWavToAmrFromFilePath:(NSString *)filePath{
    
    NSString * tmpDir = NSTemporaryDirectory();
    tmpDir = [tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_rtm_voice.amr",[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000 * 1000]]];
    
    if ([RtmVoiceConverterManager encodeWavToAmrFromPath:filePath amrSaveToPath:tmpDir]) {
        
        NSData * dd = [NSData dataWithContentsOfFile:tmpDir];
        NSLog(@"amr 路径 === %@",tmpDir);
        return tmpDir;
        
    }else{
        
        return nil;
        
    }
    
}
//amr->wav
- (NSString*)_voiceConvertAmrToWavFromFilePath:(NSData *)voiceData{
    
    if (voiceData) {
        //tmp路径  可自行修改
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


 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    
    NSDictionary * dic = self.array[indexPath.section];
    NSArray * names = dic[@"names"];
    NSString * name = names[indexPath.row];
    NSLog(@"========== %@ ==========",name);
    
    
    //52.83.245.22:13325
    if (indexPath.section == 0) {
        #pragma mark 验证登录
        
        
        if (indexPath.row == 0) {//@[@"验证登录"]
            
            self.client = [RTMClient clientWithEndpoint:@""
                                                    pid:0
                                                    uid:0
                                                  token:@""];//server 获取 1天过期

                __weak typeof(self) weakSelf = self;
                self.client.delegate = self;
                [self.client verifyConnectSuccess:^(NSDictionary * _Nullable data) {
                     __strong typeof(weakSelf)strongSelf = weakSelf;
                    NSLog(@"验证成功 verifyConnectSuccess  %ld",(long)strongSelf.client.clientStatus);

                    
                    //子线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                    //返回主线程
                        
                    });
                    
                    
                } connectFali:^(FPNError * _Nullable error) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    NSLog(@"%@ 验证失败 verifyConnectFail  %ld",error,(long)strongSelf.client.clientStatus);
                    
                }];
        
        }
        
    }else if (indexPath.section == 1){
        #pragma mark 单聊接口
        if (indexPath.row == 0) {//发送P2P消息
        
               [self.client sendP2PMessageWithId:[NSNumber numberWithLongLong:12]
                                     messageType:[NSNumber numberWithLongLong:32]
                                         message:@""
                                           attrs:@"attrs"
                                         timeout:10
                                             tag:@"传什么会返回什么 操作标记 不需要就传nil"
                                         success:^(NSDictionary * _Nullable data, id  _Nullable tag) {

                NSLog(@"%@ \n %@",data,tag);

            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {

                NSLog(@"%@ \n %@",error,tag);

            }];
            
// 发送二进制数据
//            NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"timg"], 0);
//            [self.client sendP2PMessageWithId:[NSNumber numberWithLongLong:12]
//                                     messageType:[NSNumber numberWithLongLong:66]
//                                         data:imageData
//                                           attrs:@"attrsattrs"
//                                         timeout:10
//                                             tag:@"传什么会返回什么 操作标记 不需要就传nil"
//                                         success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
//
//                NSLog(@"%@ \n %@",data,tag);
//
//            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
//
//                NSLog(@"%@ \n %@",error,tag);
//
//            }];
            
            
            
            
            
        }else if (indexPath.row == 1){// 获取历史P2P消息（包括自己发送的消息）
            
            [self.client getP2PHistoryMessageWithUserId:[NSNumber numberWithLongLong:12]
                                                      desc:NO
                                                       num:[NSNumber numberWithLongLong:2]
                                                     begin:nil
                                                       end:nil
                                                    lastid:nil
                                                    mtypes:@[[NSNumber numberWithLongLong:30]]
                                                   timeout:20
                                                       tag:@"传什么会返回什么 操作标记 不需要就传nil"
                                         success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                NSAllLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
                
                
            }];
            
        }else if (indexPath.row == 2){//删除消息 p2p
            [self.client deleteMessageWithMessageId:[NSNumber numberWithLongLong:1586488007162505]
                                             userId:[NSNumber numberWithLongLong:12]
                                            timeout:10
                                                tag:nil
                                            success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                 NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
               
                
            }];
            
        }else if (indexPath.row == 3){//获取消息 p2p
            [self.client getMessageWithMessageId:[NSNumber numberWithLongLong:1586488007162505]
                                             userId:[NSNumber numberWithLongLong:12]
                                            timeout:10
                                                tag:nil
                                            success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                 NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
               
                
            }];
            
        }
        
    }else if (indexPath.section == 2){
        #pragma mark 群聊接口
        if (indexPath.row == 0) {//发送Group消息
            
            [self.client sendGroupMessageWithId:[NSNumber numberWithLongLong:12]
                                    messageType:[NSNumber numberWithLongLong:66]
                                        message:@"group message"
                                          attrs:@"attrs"
                                        timeout:10
                                            tag:nil
                                        success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                NSLog(@"%@",error);
            }];
            
            
            
        }else if (indexPath.row == 1){//获取group历史消息
            
            [self.client getGroupMessageWithId:[NSNumber numberWithLongLong:12]
                                          desc:YES
                                           num:[NSNumber numberWithLongLong:20]
                                         begin:nil
                                           end:nil
                                        lastid:nil
                                        mtypes:nil
                                       timeout:10
                                           tag:nil
                                       success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 2){//删除消息 group
            [self.client deleteGroupMessageWithId:[NSNumber numberWithLongLong:1586488007162500]                                           groupId:[NSNumber numberWithLongLong:12]
                                          timeout:10
                                              tag:nil
                                          success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 3){//获取消息 group
            [self.client getGroupMessageWithId:[NSNumber numberWithLongLong:1586488007162500]                                                               groupId:[NSNumber numberWithLongLong:12]
                                          timeout:10
                                              tag:nil
                                          success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 4){//添加Group成员，每次最多添加100人
            
            [self.client addGroupMembersWithId:[NSNumber numberWithLongLong:12]
                                     membersId:@[[NSNumber numberWithLongLong:12]]
                                       timeout:11
                                           tag:nil
                                       success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                      NSLog(@"%@",data);
                
                  } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                      
                      NSLog(@"%@",error);
                      
                  }];
        }else if (indexPath.row == 5){//删除Group成员，每次最多删除100人
            
            [self.client deleteGroupMembersWithId:[NSNumber numberWithLongLong:12]
                                membersId:@[[NSNumber numberWithLongLong:12]]
                                  timeout:11
                                      tag:nil
                                  success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                 NSLog(@"%@",data);
             } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                 
            
             }];
            
        }else if (indexPath.row == 6){//获取group中的所有member
            
             [self.client getGroupMembersWithId:[NSNumber numberWithLongLong:12]
                                       timeout:10
                                           tag:nil
                                       success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
           
            
        }else if (indexPath.row == 7){//获取用户在哪些组里
            
            [self.client getUserGroupsWithTimeout:10 tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 8){//设置群组的公开信息或者私有信息，会检查用户是否在组内
            
            [self.client setGroupInfoWithId:[NSNumber numberWithLongLong:12]
                                   openInfo:@"open info"
                                privateInfo:@"private info"
                                    timeout:10
                                        tag:nil
                                    success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 9){//获取群组的公开信息和私有信息，会检查用户是否在组内
            
            [self.client getGroupInfoWithId:[NSNumber numberWithLongLong:12]
                                    timeout:10
                                        tag:nil
                                    success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 10){//获取群组的公开信息
            [self.client getGroupOpenInfoWithId:[NSNumber numberWithLongLong:12]
                                        timeout:10
                                            tag:nil
                                        success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }
        
        
    }else if (indexPath.section == 3){
        #pragma mark 房间接口
        if (indexPath.row == 0) {//发送房间消息
            
            [self.client sendRoomMessageWithId:[NSNumber numberWithLongLong:12]
                                   messageType:[NSNumber numberWithLongLong:66]
                                       message:@"room message"
                                         attrs:@"attrs"
                                       timeout:10
                                           tag:nil
                                       success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
            
        }else if (indexPath.row == 1){//获取room历史消息
            
            [self.client getRoomMessageWithId:[NSNumber numberWithLongLong:12]
                                         desc:YES
                                          num:[NSNumber numberWithLongLong:2]
                                        begin:nil
                                          end:nil
                                       lastid:nil
                                       mtypes:@[[NSNumber numberWithLongLong:66]]
                                      timeout:10
                                          tag:nil
                                      success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 2){//删除消息 room
            
            [self.client deleteRoomMessageWithId:[NSNumber numberWithLongLong:1581585225925222]
                                          roomId:[NSNumber numberWithLongLong:12]
                                         timeout:10
                                             tag:nil
                                         success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 3){//获取消息 room
            
            [self.client getRoomMessageWithId:[NSNumber numberWithLongLong:1583735601521150]
                                       roomId:[NSNumber numberWithLongLong:12]
                                      timeout:10
                                          tag:nil
                                      success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 4){//进入某个房间或者频道
            
            [self.client enterRoomWithId:[NSNumber numberWithLongLong:12]
                                 timeout:10
                                     tag:nil
                                 success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 5){//离开某个房间或者频道（不会持久化）
            [self.client leaveRoomWithId:[NSNumber numberWithLongLong:12]
                                 timeout:10
                                     tag:nil
                                 success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 6){//获取用户当前所在的所有房间
            [self.client getUserAtRoomsWithTimeout:10
                                               tag:nil
                                           success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 7){//设置房间的公开信息或者私有信息，会检查用户是否在房间
            [self.client setRoomInfoWithId:[NSNumber numberWithLongLong:12]
                                  openInfo:@"open"
                               privateInfo:@"pri"
                                   timeout:10
                                       tag:nil
                                   success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 8){//获取房间的公开信息和私有信息，会检查用户是否在房间内
            [self.client getRoomInfoWithId:[NSNumber numberWithLongLong:12]
                                   timeout:10
                                       tag:nil
                                   success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 9){//获取房间的公开信息
            [self.client getRoomOpenInfoWithId:[NSNumber numberWithLongLong:12]
                                       timeout:10
                                           tag:nil
                                       success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }
        
    }else if (indexPath.section == 4){
        #pragma mark 广播接口
        if (indexPath.row == 0) {//获取广播历史消息
            
            
            [self.client getBroadCastHistoryMessageWithNum:[NSNumber numberWithLongLong:10]
                                                      desc:YES
                                                     begin:nil
                                                       end:nil
                                                    lastid:nil
                                                    mtypes:nil
                                                   timeout:10
                                                       tag:nil
                                                   success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
            
        }
        
    }else if (indexPath.section == 5){
        #pragma mark 文件接口
        if (indexPath.row == 0) {//p2p 发送文件 mtype=40图片  mtype=41语音  mtype=42视频
            
            NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"timg"], 0);
            
            [self.client sendP2PFileWithId:[NSNumber numberWithLongLong:11]
                                     fileData:imageData
                                     fileName:@"imgName"
                                   fileSuffix:@"jpeg"
                                     fileType:RTMImage
                                      timeout:60
                                          tag:nil
                                      success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                NSLog(@"%@",error);
            }];
            
            
        }else if (indexPath.row == 1){//group 发送文件 mtype=40图片  mtype=41语音  mtype=42视频
            NSString * filePath = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"mp3"];
            NSData * voiceData= [NSData dataWithContentsOfFile:filePath];
            [self.client sendGroupFileWithId:[NSNumber numberWithLongLong:12]
                                     fileData:voiceData
                                     fileName:@"mp3Name"
                                   fileSuffix:@"mp3"
                                     fileType:RTMVoice
                                      timeout:60
                                          tag:nil
                                      success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 2){////room 发送文件  mtype=40图片  mtype=41语音  mtype=42视频
            NSString * filePath = [[NSBundle mainBundle] pathForResource:@"mp4Test" ofType:@"mp4"];
            NSData * movieData= [NSData dataWithContentsOfFile:filePath];
            [self.client sendRoomFileWithId:[NSNumber numberWithLongLong:12]
                                     fileData:movieData
                                     fileName:@"mp4Test"
                                   fileSuffix:@"mp4"
                                     fileType:RTMVideo
                                      timeout:60
                                          tag:nil
                                      success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                 NSLog(@"%@",error);
                
            }];
            
        }
        
    }else if (indexPath.section == 6){
        #pragma mark 好友接口
        if (indexPath.row == 0) {//添加好友，每次最多添加100人
            
            [self.client addFriendWithId:@[[NSNumber numberWithLongLong:12]]
                                 timeout:10
                                     tag:nil
                                 success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                NSLog(@"%@",error);
                
            }];
            
            
        }else if (indexPath.row == 1){//删除好友，每次最多删除100人
            [self.client deleteFriendWithId:@[[NSNumber numberWithLongLong:12]]
                                    timeout:10
                                        tag:nil
                                    success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 2){//获取好友
            [self.client getUserFriendsWithTimeout:10
                                               tag:nil
                                           success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                
                NSLog(@"%@",data);
                
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }
        
    }else if (indexPath.section == 7){
        #pragma mark 用户接口
        if (indexPath.row == 0) {//客户端主动断开
            
            
            [self.client offLineWithTimeout:10
                                        tag:nil
                                    success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 1){//踢掉一个链接（只对多用户登录有效，不能踢掉自己，可以用来实现同类设备，只容许一个登录）
            [self.client kickoutWithEndPoint:@"endpoint"
                                     timeout:10
                                         tag:nil
                                     success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 2){//添加key_value形式的变量（例如设置客户端信息，会保存在当前链接中，客户端可以获取到）
            [self.client addAttrsWithAttrs:@{@"key":@"value"}
                                   timeout:10
                                       tag:nil
                                   success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 3){//获取attrs
            [self.client getAttrsWithTimeout:10
                                         tag:nil
                                     success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 4){//检测离线聊天  只有通过Chat类接口才会产生
            [self.client getUnreadMessagesWithClear:NO
                                            timeout:10
                                                tag:nil
                                            success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 5){//清除离线聊天提醒
            [self.client cleanUnreadMessagesWithTimeout:10
                                                    tag:nil
                                                success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 6){//获取所有聊天的会话（p2p用户和自己也会产生会话 ，group）
            [self.client getAllSessionsWithTimeout:10 tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 7){//获取在线用户列表，限制每次最多获取200个
            [self.client getOnlineUsers:@[[NSNumber numberWithLongLong:12]]
                                timeout:10
                                    tag:nil
                                success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 8){//设置用户自己的公开信息或者私有信息
            [self.client setUserInfoWithOpenInfo:@"open"
                                      privteinfo:@"pri"
                                         timeout:10
                                             tag:nil
                                         success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 9){//获取用户自己的公开信息和私有信息
            [self.client getUserInfoWithTimeout:10
                                            tag:nil
                                        success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 10){//获取其他用户的公开信息，每次最多获取100人
            [self.client getUserOpenInfo:@[[NSNumber numberWithLongLong:12]] timeout:10 tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 11){//获取存储的数据信息
            [self.client getUserDataWithKey:@"kkk"
                                    timeout:10
                                        tag:nil
                                    success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                 NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 12){//设置存储的数据信息
            [self.client setUserDataWithKey:@"kkk"
                                      value:@"vvvv"
                                    timeout:10
                                        tag:nil
                                    success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                 NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 13){//删除存储的数据信息
            [self.client deleteUserDataWithKey:@"kkk"
                                       timeout:10
                                           tag:nil
                                       success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }
        
    }else if (indexPath.section == 8){
        #pragma mark debug日志，设备相关操作接口
        if (indexPath.row == 0) {//添加debug日志
            
            [self.client addDebugLogWithMsg:@"msg"
                                      attrs:@"attrs"
                                    timeout:10
                                        tag:nil
                                    success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
            
        }else if (indexPath.row == 1){//添加设备，应用信息
            
            [self.client addDeviceWithApptype:@"iphone11"
                                  deviceToken:@"token"
                                      timeout:10
                                          tag:nil
                                      success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 2){//删除设备，应用信息，解除绑定的意思
            
            [self.client removeDeviceWithToken:@"token"
                                       timeout:10
                                           tag:nil
                                       success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }
        
    }else if (indexPath.section == 9){
        #pragma mark chat单聊接口
        if (indexPath.row == 0) {//发送P2P消息 对 sendP2pMessageWithId 的封装 mtype=30
            
            [self.client sendP2PMessageChatWithId:[NSNumber numberWithLongLong:11]
                                          message:@"chat message"
                                            attrs:@"attrs"
                                          timeout:10
                                              tag:nil
                                          success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
            
        }else if (indexPath.row == 1){//发送音频消息 对 sendP2pMessageWithId 的封装 mtype=31
            
            NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
            NSTimeInterval durationTime = [self audioDurationFromURL:wavPath];
            NSString * amrPath = [self _voiceConvertWavToAmrFromFilePath:wavPath];
            NSData * amrData = [NSData dataWithContentsOfFile:amrPath];
            
            if (amrPath) {
                [self.client sendAudioMessageChatWithId:[NSNumber numberWithInt:11]
                                          audioFilePath:amrPath
                                                  attrs:@{}
                                                   lang:@"zh-cn"
                                               duration:durationTime * 1000
                                                timeout:20
                                                    tag:@""
                                                success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                    
                    NSLog(@"~~%@",data);
                    
                } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                    NSLog(@"~~%@",error);
                }];
                
            }
            
        }else if (indexPath.row == 2){//发送系统命令 对 sendP2pMessageWithId 的封装 mtype=32
            
            [self.client sendCmdMessageChatWithId:[NSNumber numberWithLongLong:11]
                                          message:@"cmd message"
                                            attrs:@"attrs"
                                          timeout:10
                                              tag:nil
                                          success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                 NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }else if (indexPath.row == 3){//获取历史P2P消息 对 getP2PHistoryMessageWithUserId 的封装 mtypes = [30,31,32]
            
            [self.client getP2PHistoryMessageChatWithUserId:[NSNumber numberWithLongLong:12]
                                                         desc:YES
                                                          num:[NSNumber numberWithLongLong:10]
                                                        begin:nil
                                                          end:nil
                                                       lastid:nil
                                                      timeout:10
                                                          tag:nil
                                                      success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSAllLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }
        
    }else if (indexPath.section == 10){
        #pragma mark chat群组接口
        if (indexPath.row == 0) {//发送Group消息 对 sendGroupMessageWithId 的封装 mtype=30
            
            [self.client sendGroupMessageChatWithId:[NSNumber numberWithLongLong:12]
                                            message:@"chat group message"
                                              attrs:@"attrs"
                                            timeout:10
                                                tag:nil
                                            success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
            
            
        }else if (indexPath.row == 1){//发送音频消息 对 sendGroupMessageWithId 的封装 mtype=31
            
            
            NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
            NSTimeInterval durationTime = [self audioDurationFromURL:wavPath];
            NSString * amrPath = [self _voiceConvertWavToAmrFromFilePath:wavPath];
            NSData * amrData = [NSData dataWithContentsOfFile:amrPath];
            
            if (amrPath) {
                
                [self.client sendGroupAudioMessageChatWithId:[NSNumber numberWithInt:12]
                                          audioFilePath:amrPath
                                                  attrs:@{}
                                                   lang:@"zh-cn"
                                               duration:durationTime * 1000
                                                timeout:20
                                                    tag:@""
                                                success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                    
                    NSLog(@"%@",data);
                    
                } fail:^(FPNError * _Nullable error, id  _Nullable tag) {

                }];
                
            }
            
        }else if (indexPath.row == 2){// 发送系统命令 对 sendGroupMessageWithId 的封装 mtype=32
            
            
            [self.client sendGroupCmdMessageChatWithId:[NSNumber numberWithLongLong:12]
                                          message:@"cmd message"
                                            attrs:@"attrs"
                                          timeout:10
                                              tag:nil
                                          success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                 NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 3){// 获取历史group消息 对 getGroupMessageWithId 的封装 mtypes = [30,31,32]
            
            
            [self.client getGroupHistoryMessageChatWithUserId:[NSNumber numberWithLongLong:12]
                                                         desc:YES
                                                          num:[NSNumber numberWithLongLong:10]
                                                        begin:nil
                                                          end:nil
                                                       lastid:nil
                                                      timeout:10
                                                          tag:nil
                                                      success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSAllLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }
        
    }else if (indexPath.section == 11){
        #pragma mark chat房间接口
        if (indexPath.row == 0) {//发送Room消息 对 sendRoomMessageWithId 的封装 mtype=30
            
            [self.client sendRoomMessageChatWithId:[NSNumber numberWithLongLong:12]
                                            message:@"chat room message"
                                              attrs:@"attrs"
                                            timeout:10
                                                tag:nil
                                            success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
            
        }else if (indexPath.row == 1){//发送音频消息 对 sendRoomMessageWithId 的封装 mtype=31
            
            NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
            NSTimeInterval durationTime = [self audioDurationFromURL:wavPath];
            NSString * amrPath = [self _voiceConvertWavToAmrFromFilePath:wavPath];
            
            if (amrPath) {
                
                [self.client sendRoomAudioMessageChatWithId:[NSNumber numberWithInt:12]
                                          audioFilePath:amrPath
                                                  attrs:@{}
                                                   lang:@"cn"
                                               duration:durationTime * 1000
                                                timeout:20
                                                    tag:@""
                                                success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                    
                    NSLog(@"%@",data);
                    
                } fail:^(FPNError * _Nullable error, id  _Nullable tag) {

                }];
                
            }
        }else if (indexPath.row == 2){//发送系统命令 对 sendRoomMessageWithId 的封装 mtype=32
            
            [self.client sendRoomCmdMessageChatWithId:[NSNumber numberWithLongLong:12]
                                          message:@"cmd message"
                                            attrs:@"attrs"
                                          timeout:10
                                              tag:nil
                                          success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                 NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 3){//获取历史Room消息 对 getRoomMessageWithId 的封装 mtypes = [30,31,32]
            [self.client getRoomHistoryMessageChatWithUserId:[NSNumber numberWithLongLong:12]
                                                         desc:YES
                                                          num:[NSNumber numberWithLongLong:10]
                                                        begin:nil
                                                          end:nil
                                                       lastid:nil
                                                      timeout:10
                                                          tag:nil
                                                      success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSAllLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
        }
        
    }else if (indexPath.section == 12){
        #pragma mark chat广播接口
        if (indexPath.row == 0) {//获取广播历史消息  对 getBroadCastHistoryMessageWithNum 的封装 mtypes = [30,31,32]
            
            [self.client getBroadCastHistoryMessageChatWithNum:[NSNumber numberWithLongLong:10]
                                                          desc:YES
                                                         begin:nil
                                                           end:nil
                                                        lastid:nil
                                                       timeout:10
                                                           tag:nil
                                                       success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSAllLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
            
        }
        
    }else if (indexPath.section == 13){
        #pragma mark 翻译接口
        if (indexPath.row == 0) {//@"设置当前用户需要的翻译语言(为空则取消翻译) 和 RTMClient里 lang属性 对应"
            
            [self.client setLanguage:@"en"
                             timeout:10
                                 tag:nil
                             success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
            
        }else if (indexPath.row == 1){//@"翻译, 返回翻译后的字符串及 经过翻译系统检测的 语言类型（调用此接口需在管理系统启用翻译系统）",
            [self.client translateText:@"hello test"
                      originalLanguage:@"en"
                        targetLanguage:@"zh-CN"
                                  type:nil
                             profanity:@"censor"
                               timeout:30
                                   tag:nil
                               success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 2){//@"敏感词过滤, 返回过滤后的字符串或者返回错误（调用此接口需在管理系统启用文本检测系统）",
            
            [self.client textProfanity:@"hello fuck"
                              classify:YES
                               timeout:10
                                   tag:nil
                               success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                
            }];
            
        }else if (indexPath.row == 3){//@"语音识别（调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s"
            
            NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
            NSString * amrPath = [self _voiceConvertWavToAmrFromFilePath:wavPath];
            NSData * amrData = [NSData dataWithContentsOfFile:amrPath];
            if (amrData == nil) {
                return;
            }
            [self.client speechRecognition:amrData
                                      lang:@"zh-cn"
                                  duration:2950
                           profanityFilter:YES
                                   timeout:120
                                       tag:nil
                                   success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
                NSLog(@"==%@",data);
            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
                NSLog(@"==%@",error);
            }];
        }
        
    }else if (indexPath.section == 14){
        #pragma mark 加密操作
        
//        NSString *pemFilePath= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"keyName.pem"];
//        [self.client enableEncryptorByPemFile:pemFilePath packageMode:YES withReinforce:NO];
           
//        - (void)enableEncryptorWithCurve:(NSString*)curve serverPublicKey:(NSData*)publicKey packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
//        - (void)enableEncryptorByDerData:(NSData*)derData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
//        - (void)enableEncryptorByPemData:(NSData*)pemData packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
//        - (void)enableEncryptorByDerFile:(NSString*)derFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
//        - (void)enableEncryptorByPemFile:(NSString*)pemFilePath packageMode:(BOOL)packageMode withReinforce:(BOOL)reinforce;
    }
    
}

#pragma mark UI

-(void)loadView{
    self.array = @[


        @{
            @"typeName":@"验证登录",
            @"names":@[@"验证登录"],
        },
        @{
            @"typeName":@"单聊接口",
            @"names":@[@"发送P2P消息",
                       @"获取历史P2P消息（包括自己发送的消息）",
                       @"删除消息 p2p",
                       @"获取消息 p2p"],
        },
        @{
            @"typeName":@"群聊接口",
            @"names":@[@"发送Group消息",
                       @"获取group历史消息",
                       @"删除消息 group",
                       @"获取消息 group",
                       @"添加Group成员，每次最多添加100人",
                       @"删除Group成员，每次最多删除100人",
                       @"获取group中的所有member",
                       @"获取用户在哪些组里",
                       @"设置群组的公开信息或者私有信息，会检查用户是否在组内",
                       @"获取群组的公开信息和私有信息，会检查用户是否在组内",
                       @"获取群组的公开信息",
                       ]
        },
        @{
            @"typeName":@"房间接口",
            @"names":@[@"发送房间消息",
                       @"获取room历史消息",
                       @"删除消息 room",
                       @"获取消息 room",
                       @"进入某个房间或者频道",
                       @"离开某个房间或者频道（不会持久化）",
                       @"获取用户当前所在的所有房间",
                       @"设置房间的公开信息或者私有信息，会检查用户是否在房间",
                       @"获取房间的公开信息和私有信息，会检查用户是否在房间内",
                       @"获取房间的公开信息",
                       
            ]
        },
        @{
            @"typeName":@"广播接口",
            @"names":@[
                    @"获取广播历史消息"
            ],
        },
        @{
            @"typeName":@"文件接口",
            @"names":@[
                    @"p2p 发送文件 mtype=40图片  mtype=41语音  mtype=42视频",
                    @"group 发送文件 mtype=40图片  mtype=41语音  mtype=42视频",
                    @"room 发送文件  mtype=40图片  mtype=41语音  mtype=42视频",
            ]
        },
        @{
            @"typeName":@"好友接口",
            @"names":@[
                    @"添加好友，每次最多添加100人",
                    @"删除好友，每次最多删除100人",
                    @"获取好友",
                       
            ]
        },
        @{
            @"typeName":@"用户接口",
            @"names":@[@"客户端主动断开",
                       @"踢掉一个链接（只对多用户登录有效，不能踢掉自己，可以用来实现同类设备，只容许一个登录）",
                       @"添加key_value形式的变量（例如设置客户端信息，会保存在当前链接中，客户端可以获取到）",
                       @"获取attrs",
                       @"检测离线聊天  只有通过Chat类接口才会产生",
                       @"清除离线聊天提醒",
                       @"获取所有聊天的会话（p2p用户和自己也会产生会话 ，group）",
                       @"获取在线用户列表，限制每次最多获取200个",
                       @"设置用户自己的公开信息或者私有信息",
                       @"获取用户自己的公开信息和私有信息",
                       @"获取其他用户的公开信息，每次最多获取100人",
                       @"获取存储的数据信息",
                       @"设置存储的数据信息",
                       @"删除存储的数据信息",
                       
                       
            ]
        },
        @{
            @"typeName":@"debug日志，设备相关操作接口",
            @"names":@[
                    
                    @"添加debug日志",
                    @"添加设备，应用信息",
                    @"删除设备，应用信息，解除绑定的意思"
                       
                       
            ]
        },
        @{
            @"typeName":@"chat单聊接口",
            @"names":@[
                    
                    @"发送P2P消息 对 sendP2pMessageWithId 的封装 mtype=30",
                    @"发送音频消息 对 sendP2PMessageWithId 的封装 mtype=31",
                    @"发送系统命令 对 sendP2PMessageWithId 的封装 mtype=32",
                    @"获取历史P2P消息 对 getP2PHistoryMessageWithUserId 的封装 mtypes = [30,31,32]",
                      
                       
                       
            ]
        },
        @{
            @"typeName":@"chat群组接口",
            @"names":@[@"发送Group消息 对 sendGroupMessageWithId 的封装 mtype=30",
                       @"发送音频消息 对 sendGroupMessageWithId 的封装 mtype=31",
                       @"发送系统命令 对 sendGroupMessageWithId 的封装 mtype=32",
                       @"获取历史group消息 对 getGroupMessageWithId 的封装 mtypes = [30,31,32] ",
                       
                       
                       
            ]
        },
        @{
            @"typeName":@"chat房间接口",
            @"names":@[@"发送Room消息 对 sendRoomMessageWithId 的封装 mtype=30",
                       @"发送音频消息 对 sendRoomMessageWithId 的封装 mtype=31",
                       @"发送系统命令 对 sendRoomMessageWithId 的封装 mtype=32",
                       @"获取历史Room消息 对 getRoomMessageWithId 的封装 mtypes = [30,31,32] ",
                       
                       
                       
            ]
        },
        
        @{
            @"typeName":@"chat广播接口",
            @"names":@[
                    @"获取广播历史消息  对 getBroadCastHistoryMessageWithNum 的封装 mtypes = [30,31,32]",
                       
                       
            ]
        },
        
        @{
            @"typeName":@"翻译接口",
            @"names":@[@"设置当前用户需要的翻译语言(为空则取消翻译) 和 RTMClient里 lang属性 对应",
                       @"翻译, 返回翻译后的字符串及 经过翻译系统检测的 语言类型（调用此接口需在管理系统启用翻译系统）",
                       @"敏感词过滤, 返回过滤后的字符串或者返回错误（调用此接口需在管理系统启用文本检测系统）",
                       @"语音识别（调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s"
                      
                       
                       
                       
            ]
        },
        @{
            @"typeName":@"加密操作",
            @"names":@[
                    
                    @"加密操作",
                      
                       
                       
                       
            ]
        },
        
    ];
    
    self.view = self.listView;

//点击一下  登录验证
    [self tableView:self.listView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self test];
//    [self test2];
//    self.client = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
//                                                        pid:90000014
//                                                        uid:12
//                                                      token:@"2AFC64151C04F9F23A69A88048984144"];//server 获取
//    [self.client verifyConnectSuccess:^(NSDictionary * _Nullable data) {
//         NSLog(@"验证成功 verifyConnectSuccess  ");
//
//
//        NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
//        NSTimeInterval durationTime = [self audioDurationFromURL:wavPath];
//        NSString * amrPath = [self _voiceConvertWavToAmrFromFilePath:wavPath];
//        NSData * amrData = [NSData dataWithContentsOfFile:amrPath];
//
////        if (amrPath) {
////            [self.client sendGroupAudioMessageChatWithId:[NSNumber numberWithInt:12]
////                                      audioFilePath:amrPath
////                                              attrs:@{}
////                                               lang:@"zh-cn"
////                                           duration:durationTime * 1000
////                                            timeout:20
////                                                tag:@""
////                                            success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
////
////                NSLog(@"~~%@",data);
////
////            } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
////                NSLog(@"~~%@",error);
////            }];
////        }
//        NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"head2.jpg"], 0);
//        [self.client sendGroupFileWithId:@(12) fileData:imageData fileName:@"img123" fileSuffix:@"jpg" fileType:RTMImage timeout:10 tag:nil success:^(NSDictionary * _Nullable data, id  _Nullable tag) {
//
//        } fail:^(FPNError * _Nullable error, id  _Nullable tag) {
//
//        }];
//
//    } connectFali:nil];
}
-(void)test2{
    self.client6 = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
                                                        pid:90000014
                                                        uid:17
                                                      token:@"B8C3A4C4270C40C72C1C201EF9B5EF67"];//server 获取
    [self.client6 verifyConnectSuccess:^(NSDictionary * _Nullable data) {
         NSLog(@"验证成功 verifyConnectSuccess  ");

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int a = 0;
            while (1) {
                sleep(1);
                a = a + 1;
                [self.client6 sendGroupMessageChatWithId:@(12) message:[NSString stringWithFormat:@"client6  group message %d",a] attrs:@"" timeout:10];
            }
        });



    } connectFali:nil];
    
    self.client7 = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
                                                        pid:90000014
                                                        uid:18
                                                      token:@"4297E324D29B7F0FB8B6CD55838CCAA0"];//server 获取
    [self.client7 verifyConnectSuccess:^(NSDictionary * _Nullable data) {
         NSLog(@"验证成功 verifyConnectSuccess  ");

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int a = 0;
            while (1) {
                sleep(1.2);
                a = a + 1;
                [self.client7 sendGroupMessageChatWithId:@(13) message:[NSString stringWithFormat:@"client7  group message %d",a] attrs:@"" timeout:10];
            }
        });



    } connectFali:nil];
    
    self.client8 = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
                                                        pid:90000014
                                                        uid:19
                                                      token:@"F28F614AC444E3FF9199BBA36574BB01"];//server 获取
    [self.client8 verifyConnectSuccess:^(NSDictionary * _Nullable data) {
         NSLog(@"验证成功 verifyConnectSuccess  ");

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int a = 0;
            while (1) {
                sleep(1.4);
                a = a + 1;
                [self.client8 sendGroupMessageChatWithId:@(14) message:[NSString stringWithFormat:@"client8  group message %d",a] attrs:@"" timeout:10];
            }
        });



    } connectFali:nil];
}
-(void)test{
    self.client = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
                                                        pid:90000014
                                                        uid:12
                                                      token:@"583876ED4DA5DE951C203C2653BE8B7F"];//server 获取
    [self.client verifyConnectSuccess:^(NSDictionary * _Nullable data) {
         NSLog(@"验证成功 verifyConnectSuccess  ");

        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int a = 0;
            while (1) {
                sleep(1);
                a = a + 1;
                [self.client sendP2PMessageChatWithId:@(11) message:[NSString stringWithFormat:@"client1  message %d",a] attrs:@"" timeout:10];
            }
        });
        
    } connectFali:nil];
    
    self.client2 = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
                                                        pid:90000014
                                                        uid:13
                                                      token:@"C292BB4471123EEC368B3EF534201BF1"];//server 获取
    [self.client2 verifyConnectSuccess:^(NSDictionary * _Nullable data) {

        NSLog(@"验证成功 verifyConnectSuccess  ");

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int a = 0;
            while (1) {
                sleep(1.1);
                a = a + 1;
                [self.client2 sendP2PMessageChatWithId:@(11) message:[NSString stringWithFormat:@"client2  message %d",a] attrs:@"" timeout:10];
            }
        });



    } connectFali:nil];

    self.client3 = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
                                                        pid:90000014
                                                        uid:14
                                                      token:@"E0773818447CBAA8CE4FAA019DB2AFF0"];//server 获取
    [self.client3 verifyConnectSuccess:^(NSDictionary * _Nullable data) {
         NSLog(@"验证成功 verifyConnectSuccess  14");

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int a = 0;
            while (1) {
                sleep(1.2);
                a = a + 1;
                [self.client3 sendP2PMessageChatWithId:@(11) message:[NSString stringWithFormat:@"client3  message %d",a] attrs:@"" timeout:10];
            }
        });



    } connectFali:nil];
//
    self.client4 = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
                                                        pid:90000014
                                                        uid:15
                                                      token:@"FBF2FFEE24484F01C87587A979860738"];//server 获取
    [self.client4 verifyConnectSuccess:^(NSDictionary * _Nullable data) {
         NSLog(@"验证成功 verifyConnectSuccess  ");

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           int a = 0;
            while (1) {
                sleep(1.3);
                a = a + 1;
                [self.client4 sendP2PMessageChatWithId:@(11) message:[NSString stringWithFormat:@"client4  message %d",a] attrs:@"" timeout:10];
            }
        });



    } connectFali:nil];
//
    self.client5 = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
                                                        pid:90000014
                                                        uid:16
                                                      token:@"1A33482D81B1756AE0169E350F6A1EB2"];//server 获取
    [self.client5 verifyConnectSuccess:^(NSDictionary * _Nullable data) {
         NSLog(@"验证成功 verifyConnectSuccess  ");

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int a = 0;
            while (1) {
                sleep(1.4);
                a = a + 1;
                [self.client5 sendP2PMessageChatWithId:@(11) message:[NSString stringWithFormat:@"client5  message %d",a] attrs:@"" timeout:10];
            }
        });



    } connectFali:nil];
                    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary * dic = self.array[section];
    NSArray * names = dic[@"names"];
    return names.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    lb.textColor = [UIColor blackColor];
    NSDictionary * dic = self.array[section];
    lb.text = [NSString stringWithFormat:@"     %@",dic[@"typeName"]];
    lb.font = [UIFont boldSystemFontOfSize:23];
    return lb;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    NSDictionary * dic = self.array[indexPath.section];
    NSArray * names = dic[@"names"];
    cell.textLabel.text = names[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.numberOfLines = 0;
    return cell;
}
-(UITableView*)listView{
    if (_listView == nil) {
        _listView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}


@end
