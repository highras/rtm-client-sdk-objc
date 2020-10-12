//
//  VVViewController.m
//  Test
//
//  Created by zsl on 2020/1/19.
//  Copyright © 2020 FunPlus. All rights reserved.
//

#import "MainViewController.h"
#import "RtmVoiceConverterManager.h"
#import "RTMRecordManager.h"
#import "RTMAudioplayer.h"
#import <Rtm/Rtm.h>
#import "NSObject+Description.h"
#define NSAllLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,RTMProtocol>{
    
    
    
    int a,b,c,d,e,dd,ee;
    
    
}
@property(nonatomic,strong)UITableView * listView;
@property(nonatomic,strong)NSArray * array;

@property(nonatomic,strong)RTMClient * client;
@property(nonatomic,strong)RTMClient * client2;
@property(nonatomic,strong)RTMClient * client3;
@property(nonatomic,strong)RTMClient * client4;
@property(nonatomic,strong)RTMClient * client5;
@property(nonatomic,strong)RTMClient * client6;
@property(nonatomic,strong)RTMClient * client7;
@property(nonatomic,strong)RTMClient * client8;

@property(nonatomic,strong)RTMRecordManager * recordManager;
@property(nonatomic,strong)NSString * recordAmrAudioPath;
@property(nonatomic,assign)double  recordAmrAudioTime;
@property(nonatomic,strong)NSString * recordWavAudioPath;


@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark push delegate



//被踢下线
-(void)rtmKickout:(RTMClient *)client
{
    NSLog(@"rtmKickout");
}
//房间踢出
-(void)rtmRoomKickoutData:(RTMClient *)client data:(NSDictionary * _Nullable)data
{
    
}
//normal Binary
-(void)rtmPushP2PBinary:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushGroupBinary:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushRoomBinary:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushBroadcastBinary:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
//normal message
-(void)rtmPushP2PMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushGroupMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushRoomMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushBroadcastMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}

//file
-(void)rtmPushP2PFile:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushGroupFile:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushRoomFile:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushBroadcastFile:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}

//chat message
-(void)rtmPushP2PChatMessage:(RTMClient *)client message:(RTMMessage *_Nullable)message{
    NSLog(@"rtmPushP2PChatMessage  %@ ",message);
}
-(void)rtmPushGroupChatMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushRoomChatMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushBroadcastChatMessage:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}

//chat audio
-(void)rtmPushP2PChatAudio:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushGroupChatAudio:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushRoomChatAudio:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushBroadcastChatAudio:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}

//chat cmd
-(void)rtmPushP2PChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushGroupChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushRoomChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}
-(void)rtmPushBroadcastChatCmd:(RTMClient *)client message:(RTMMessage * _Nullable)message{
    
}

//重连
-(void)rtmReloginCompleted:(RTMClient *)client reloginCount:(int)reloginCount reloginResult:(BOOL)reloginResult error:(FPNError *)error{
    NSLog(@"rtmReloginCompleted  %d %d",reloginCount,reloginResult);
}
-(BOOL)rtmReloginWillStart:(RTMClient *)client reloginCount:(int)reloginCount{

    NSLog(@"rtmReloginWillStart  %d",reloginCount);
    return YES;
}
-(void)rtmConnectClose:(RTMClient *)client{
    NSLog(@"rtmConnectClose  %lld",client.userId);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    
    NSDictionary * dic = self.array[indexPath.section];
    NSArray * names = dic[@"names"];
    NSString * name = names[indexPath.row];
    NSLog(@"========== %@ ==========",name);
    
    
#pragma mark 验证登录
    if (indexPath.section == 0) {
        
        
        
        if (indexPath.row == 0) {//@[@"验证登录"]
        
//            [self test];
            self.client = [RTMClient clientWithEndpoint:@"161.189.171.91:13325"
                                              projectId:90000014
                                                 userId:666
                                               delegate:self
                                                 config:nil
                                            autoRelogin:YES];
            
            if (self.client) {
                [self.client loginWithToken:@"5B29E4874E1F7FA2216CE65FD10FAAB3"
                                   language:@"en"
                                  attribute:@{@"aaa":@"bbb"}
                                    timeout:30
                                    success:^{
                    
                    NSLog(@"login success");

                            
                    
                } connectFail:^(FPNError * _Nullable error) {
                    
                    NSLog(@"login error %@",error);
                }];
            }
        
        }
        
        
        
        
        
#pragma mark 单聊接口
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {//发送P2P消息
            
            [self.client sendP2PMessageToUserId:@(777)
                                    messageType:@(80)
                                        message:@"message"
                                          attrs:@"attrs"
                                        timeout:10
                                        success:^(RTMSendAnswer * sendAnswer) {

                NSLog(@"sendP2PMessageToUserId %lld %lld",sendAnswer.mtime,sendAnswer.messageId);

            }fail:^(FPNError * _Nullable error) {

                NSLog(@"sendP2PMessageToUserId %@",error);

            }];
//
            
            //同步接口
//            RTMSendAnswer * answer = [self.client sendP2PMessageToUserId:@(777)
//                                    messageType:@(80)
//                                        message:@"message"
//                                          attrs:@"attrs"
//                                        timeout:10];
//            if (answer.error) {
//                NSLog(@"sendP2PMessageToUserId %@",answer.error);
//            }else{
//                NSLog(@"sendP2PMessageToUserId %lld",answer.mtime);
//            }
            
            
        }else if (indexPath.row == 1){// 获取历史P2P消息（包括自己发送的消息）


            [self.client getP2PHistoryMessageWithUserId:@(777)
                                                 desc:YES
                                                  num:@(20)
                                                begin:nil
                                                  end:nil
                                               lastid:nil
                                               mtypes:@[@(80),@(40),@(31),@(30)]
                                              timeout:10
                                              success:^(RTMHistory * _Nullable history) {
                
                NSLog(@"getP2PHistoryMessageWithUserId %@",history.messageArray);
                NSLog(@"getP2PHistoryMessageWithUserId %@",history.messageArray.lastObject.rtm_autoDescription);
//                NSLog(@"getP2PHistoryMessageWithUserId %@",history.messageArray.firstObject.audioInfo.rtm_autoDescription);
                
            } fail:^(FPNError * _Nullable error) {
                
                NSLog(@"getP2PHistoryMessageWithUserId %@",error);
                
            }];
                

        }else if (indexPath.row == 2){//删除消息 p2p
            
                    [self.client deleteMessageWithMessageId:[NSNumber numberWithLongLong:1597718247286284]
                                                 fromUserId:@(666)
                                                   toUserId:@(777)
                                                    timeout:10
                                                    success:^{
                        
                        NSLog(@"deleteMessageWithMessageId success");
                        
                    } fail:^(FPNError * _Nullable error) {
                        
                        NSLog(@"%@",error);
                        
                    }];
            

        }else if (indexPath.row == 3){//获取消息 p2p
            [self.client getP2pMessageWithId:[NSNumber numberWithLongLong:1597733183879984]
                                  fromUserId:@(666)
                                    toUserId:@(777)
                                     timeout:10
                                     success:^(RTMGetMessage * _Nullable message) {
               
                NSLog(@"%@",message.rtm_autoDescription);
                
                if (message.audioMessage != nil) {//语音消息
                    [[RTMAudioplayer shareInstance] playWithData:message.audioMessage];
                }
                
            } fail:^(FPNError * _Nullable error) {
                
                NSLog(@"%@",error);
                
            }];

        }else if (indexPath.row == 4){//语音识别 p2p
            
            [self.client stranscribeP2pWithId:@(1597733183879984)
                                   fromUserId:@(666)
                                     toUserId:@(777)
                              profanityFilter:NO
                                      timeout:10
                                      success:^(RTMSpeechRecognitionAnswer * _Nullable message) {
                
                 NSLog(@"%@",message.rtm_autoDescription);
                
            } fail:^(FPNError * _Nullable error) {
                
                NSLog(@"%@",error);
                
            }];

               
        }
        
        //                if ([[data objectForKey:@"mtype"] intValue] == 31) {
        //                    //amr->wav
        //                    NSData * audioData = [data objectForKey:@"msg"];
        //                    NSString * wavPath = [self _voiceConvertAmrToWavFromFilePath:audioData];
        //                    if (wavPath) {
        //                        NSData * wavData = [NSData dataWithContentsOfFile:wavPath];
        //                        if (wavData) {
        //                            self.audioPlayer = [[AVAudioPlayer alloc] initWithData:wavData error:nil];
        //                            self.audioPlayer.delegate = self;
        //                            [self.audioPlayer play];
        //                        }
        //                    }
        //                }
        
        
        
        
        
#pragma mark 群聊接口
        }else if (indexPath.section == 2){
            
            if (indexPath.row == 0) {//发送Group消息
                    
                [self.client sendGroupMessageWithId:[NSNumber numberWithLongLong:666]
                                        messageType:[NSNumber numberWithLongLong:80]
                                            message:@"group message123"
                                              attrs:@"attrs"
                                            timeout:10
                                            success:^(RTMSendAnswer * sendAnswer) {
                    
                    NSLog(@"%lld %lld",sendAnswer.mtime,sendAnswer.messageId);
                    
                } fail:^(FPNError * _Nullable error) {
                    
                    NSLog(@"%@",error);
                    
                }];
                                 
            }else if (indexPath.row == 1){//获取group历史消息
                
                
                [self.client getGroupHistoryMessageWithGroupId:[NSNumber numberWithLongLong:666]
                                                          desc:YES
                                                           num:[NSNumber numberWithLongLong:20]
                                                         begin:nil
                                                           end:nil
                                                        lastid:nil
                                                        mtypes:@[@(80),@(40),@(31),@(30)]
                                                       timeout:10
                                                       success:^(RTMHistory * _Nullable history) {
                                               
                    NSLog(@"%@",history.messageArray);
                    
                   
                } fail:^(FPNError * _Nullable error) {
                    
                    NSLog(@"%@",error);
                    
                }];
                                                          
    
            }else if (indexPath.row == 2){//删除group消息
            
                [self.client deleteGroupMessageWithId:[NSNumber numberWithLongLong:1597735267814886]
                                              groupId:[NSNumber numberWithLongLong:666]
                                           fromUserId:@(666)
                                              timeout:10
                                              success:^{
                    
                    NSLog(@"deleteGroupMessageWithId success");
                    
                } fail:^(FPNError * _Nullable error) {
                    
                    NSLog(@"%@",error);
                    
                }];
                
            }else if (indexPath.row == 3){//获取消息 group
                        
                [self.client getGroupMessageWithId:[NSNumber numberWithLongLong:1597735470385533]
                                           groupId:[NSNumber numberWithLongLong:666]
                                        fromUserId:@(666)
                                           timeout:10
                                           success:^(RTMGetMessage * _Nullable message) {
                    
                    NSLog(@"%@",message.rtm_autoDescription);
                    if (message.audioMessage != nil) {//语音消息
                        [[RTMAudioplayer shareInstance] playWithData:message.audioMessage];
                    }
                    
                } fail:^(FPNError * _Nullable error) {
                    
                    NSLog(@"%@",error);
                    
                }];
                
            }else if (indexPath.row == 4){//添加Group成员，每次最多添加100人
                
                [self.client addGroupMembersWithId:@(666)
                                         membersId:@[@(888)]
                                           timeout:10
                                           success:^{
                    
                    NSLog(@"addGroupMembersWithId success");
                    
                } fail:^(FPNError * _Nullable error) {
                    
                    NSLog(@"%@",error);
                    
                }];
            
            }else if (indexPath.row == 5){//删除Group成员，每次最多删除100人
            
                [self.client deleteGroupMembersWithId:@(666)
                                            membersId:@[[NSNumber numberWithLongLong:888]]
                                              timeout:10
                                              success:^{
                    
                    NSLog(@"deleteGroupMembersWithId success");
                    
                } fail:^(FPNError * _Nullable error) {
                    
                    NSLog(@"%@",error);
                    
                }];
                        
            }else if (indexPath.row == 6){//获取group中的所有member
                
                [self.client getGroupMembersWithId:@(666)
                                           timeout:10
                                           success:^(NSArray * _Nullable uidsArray) {
                    
                    NSLog(@"%@",uidsArray);
                    
                } fail:^(FPNError * _Nullable error) {
                    
                    NSLog(@"%@",error);
                    
                }];
                
            }else if (indexPath.row == 7){//获取用户在哪些组里
                
                [self.client getUserGroupsWithTimeout:10
                                              success:^(NSArray * _Nullable groupArray)  {
                    
                    NSLog(@"%@",groupArray);
                    
                } fail:^(FPNError * _Nullable error) {
                    
                    NSLog(@"%@",error);
                    
                }];
            
                        
            
                   
            }else if (indexPath.row == 8){//设置群组的公开信息或者私有信息，会检查用户是否在组内
            
                        [self.client setGroupInfoWithId:@(666)
                                               openInfo:@"open info123"
                                            privateInfo:@"private info123"
                                                timeout:10
                                                success:^{
                            
                            NSLog(@"setGroupInfoWithId success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
            
            }else if (indexPath.row == 9){//获取群组的公开信息和私有信息，会检查用户是否在组内
            
                        [self.client getGroupInfoWithId:@(666)
                                                timeout:10
                                                success:^(RTMInfoAnswer * _Nullable info) {
                            
                            NSLog(@"%@  %@",info.openInfo,info.privateInfo);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                    
            }else if (indexPath.row == 10){//获取群组的公开信息
                
                        [self.client getGroupOpenInfoWithId:[NSNumber numberWithLongLong:666]
                                                    timeout:10
                                                    success:^(RTMInfoAnswer * _Nullable info) {
                            
                            NSLog(@"%@",info.openInfo);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                        }];
                             
                    
            }else if (indexPath.row == 11){//语音识别 group
                
                [self.client stranscribeGroupWithId:@(123)
                                         fromUserId:@(666)
                                          toGroupId:@(777)
                                    profanityFilter:NO
                                            timeout:10
                                            success:^(RTMSpeechRecognitionAnswer * _Nullable message) {
                    
                } fail:^(FPNError * _Nullable error) {
                    
                }];

                   
            }
            
            
                
                
                

#pragma mark 房间接口
        }else if (indexPath.section == 3){
                
                if (indexPath.row == 0) {//发送房间消息
        
                    [self.client sendRoomMessageWithId:[NSNumber numberWithLongLong:666]
                                           messageType:[NSNumber numberWithLongLong:80]
                                               message:@"room message"
                                                 attrs:@"attrs"
                                               timeout:10
                                               success:^(RTMSendAnswer * sendAnswer) {
                        
                        NSLog(@"%lld %lld",sendAnswer.mtime,sendAnswer.messageId);
                        
                    } fail:^(FPNError * _Nullable error) {
                        
                        NSLog(@"%@",error);
                        
                    }];
        
        
                }else if (indexPath.row == 1){//获取room历史消息
                
                            [self.client getRoomHistoryMessageWithId:@(666)
                                                                desc:YES
                                                                 num:@(20)
                                                               begin:nil
                                                                 end:nil
                                                              lastid:nil
                                                              mtypes:@[@(80),@(40),@(31),@(30)]
                                                             timeout:10
                                                             success:^(RTMHistory * _Nullable history) {
                                
                                NSLog(@"%@",history.messageArray.firstObject.translatedInfo.rtm_autoDescription);
                                
                            } fail:^(FPNError * _Nullable error) {
                                
                                NSLog(@"%@",error);
                                
                            }];
                
                        
                }else if (indexPath.row == 2){//删除消息 room
                
                            [self.client deleteRoomMessageWithId:[NSNumber numberWithLongLong:1597737469848698]
                                                          roomId:[NSNumber numberWithLongLong:666]
                                                      fromUserId:@(666)
                                                         timeout:10
                                                         success:^{
                                
                                NSLog(@"deleteRoomMessageWithId");
                                
                            } fail:^(FPNError * _Nullable error) {
                                
                                NSLog(@"%@",error);
                                
                            }];
                
                       
                }else if (indexPath.row == 3){//获取消息 room
                
                            [self.client getRoomMessageWithId:[NSNumber numberWithLongLong:1597737845804116]
                                                       roomId:[NSNumber numberWithLongLong:666]
                                                   fromUserId:@(666)
                                                      timeout:10
                                                      success:^(RTMGetMessage * _Nullable message) {
                                
                                NSLog(@"%@",message.rtm_autoDescription);
                                if (message.audioMessage != nil) {//语音消息
                                    [[RTMAudioplayer shareInstance] playWithData:message.audioMessage];
                                }
                                
                            } fail:^(FPNError * _Nullable error) {
                                NSLog(@"%@",error);
                            }];
                
                       
                }else if (indexPath.row == 4){//进入某个房间或者频道
                
                            [self.client enterRoomWithId:[NSNumber numberWithLongLong:66677]
                                                 timeout:10
                                                 success:^{
                                
                                NSLog(@"enterRoomWithId success");
                                
                            } fail:^(FPNError * _Nullable error) {
                                
                                NSLog(@"%@",error);
                                
                            }];
                    
                }else if (indexPath.row == 5){//离开某个房间或者频道（不会持久化）
                    
                            [self.client leaveRoomWithId:[NSNumber numberWithLongLong:666]
                                                 timeout:10
                                                 success:^{
                                
                                NSLog(@"leaveRoomWithId success");
                                
                            } fail:^(FPNError * _Nullable error) {
                                
                                NSLog(@"%@",error);
                                
                            }];
                    
                }else if (indexPath.row == 6){//获取用户当前所在的所有房间
                    
                            [self.client getUserAtRoomsWithTimeout:10
                                                           success:^(NSArray * _Nullable roomArray) {
                                
                                NSLog(@"%@",roomArray);
                                
                            } fail:^(FPNError * _Nullable error) {
                                
                                NSLog(@"%@",error);
                                
                            }];
                        
                }else if (indexPath.row == 7){//设置房间的公开信息或者私有信息，会检查用户是否在房间
                    
                            [self.client setRoomInfoWithId:[NSNumber numberWithLongLong:666]
                                                  openInfo:@"open"
                                               privateInfo:@"pri"
                                                   timeout:10
                                                   success:^{
                                
                                NSLog(@"setRoomInfoWithId success");
                                
                            } fail:^(FPNError * _Nullable error) {
                                
                                NSLog(@"%@",error);
                            }];
                        
                }else if (indexPath.row == 8){//获取房间的公开信息和私有信息，会检查用户是否在房间内
                    
                            [self.client getRoomInfoWithId:[NSNumber numberWithLongLong:666]
                                                   timeout:10
                                                   success:^(RTMInfoAnswer * _Nullable info) {
                                
                                NSLog(@"%@",info);
                                
                            } fail:^(FPNError * _Nullable error) {
                                
                                NSLog(@"%@",error);
                                
                            }];
                       
                }else if (indexPath.row == 9){//获取房间的公开信息
                            [self.client getRoomOpenInfoWithId:[NSNumber numberWithLongLong:666]
                                                       timeout:10
                                                       success:^(RTMInfoAnswer * _Nullable info) {
                                
                                NSLog(@"%@",info);
                                
                            } fail:^(FPNError * _Nullable error) {
                                
                                NSLog(@"%@",error);
                                
                            }];
                       
                }else if (indexPath.row == 10){//语音识别 room
                    
                    [self.client stranscribeRoomWithId:@(123)
                                            fromUserId:@(666)
                                              toRoomId:@(777)
                                       profanityFilter:NO
                                               timeout:10
                                               success:^(RTMSpeechRecognitionAnswer * _Nullable message) {
                        
                    } fail:^(FPNError * _Nullable error) {
                        
                    }];

                       
                }
                
#pragma mark 广播接口
        }else if (indexPath.section == 4){
               
                if (indexPath.row == 0) {//获取广播历史消息

                    [self.client getBroadCastHistoryMessageWithNum:@(20)
                                                              desc:YES
                                                             begin:nil
                                                               end:nil
                                                            lastid:nil
                                                            mtypes:@[@(80),@(40),@(31),@(30)]
                                                           timeout:10
                                                           success:^(RTMHistory * _Nullable history) {
                                                           
                        NSLog(@"%@",history.messageArray);
                        
                    } fail:^(FPNError * _Nullable error) {
                        
                        NSLog(@"%@",error);
                        
                    }];
        
        
                }else if (indexPath.row == 1){//语音识别 广播
                    
                    [self.client stranscribeBroadcastWithId:@(123)
                                                 fromUserId:@(666)
                                            profanityFilter:NO
                                                    timeout:10
                                                    success:^(RTMSpeechRecognitionAnswer * _Nullable message) {
                        
                    } fail:^(FPNError * _Nullable error) {
                        
                    }];

                       
                }
            
            
#pragma mark 文件接口
            }else if (indexPath.section == 5){
                    
                    if (indexPath.row == 0) {//p2p 发送文件 mtype=40图片  mtype=41语音  mtype=42视频
            
                        NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"timg"], 0);
                        [self.client sendP2PFileWithId:@(777)
                                              fileData:imageData
                                              fileName:@"imgName"
                                            fileSuffix:@"jpeg"
                                              fileType:RTMImage
                                               timeout:60
                                               success:^(RTMSendAnswer * sendAnswer) {
                            
                            NSLog(@"File%lld",sendAnswer.mtime);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"File%@",error);
                            
                        }];
            
                    }else if (indexPath.row == 1){//group 发送文件 mtype=40图片  mtype=41语音  mtype=42视频
                        
                        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"mp3"];
                        NSData * voiceData= [NSData dataWithContentsOfFile:filePath];
                        [self.client sendGroupFileWithId:[NSNumber numberWithLongLong:666]
                                                 fileData:voiceData
                                                 fileName:@"mp3Name"
                                               fileSuffix:@"mp3"
                                                 fileType:RTMVoice
                                                  timeout:60
                                                 success:^(RTMSendAnswer * sendAnswer) {
                            
                            NSLog(@"File%lld",sendAnswer.mtime);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                        
                    }else if (indexPath.row == 2){//room 发送文件  mtype=40图片  mtype=41语音  mtype=42视频
                        
                        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"mp4Test" ofType:@"mp4"];
                        NSData * movieData= [NSData dataWithContentsOfFile:filePath];
                        [self.client sendRoomFileWithId:[NSNumber numberWithLongLong:666]
                                                 fileData:movieData
                                                 fileName:@"mp4Test"
                                               fileSuffix:@"mp4"
                                                 fileType:RTMVideo
                                                  timeout:60
                                                success:^(RTMSendAnswer * sendAnswer) {
                            
                            NSLog(@"File%lld",sendAnswer.mtime);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                        
                    }
                
                
#pragma mark 好友接口
            }else if (indexPath.section == 6){
                    
                    if (indexPath.row == 0) {//添加好友，每次最多添加100人
            
                        [self.client addFriendWithId:@[@(888)]
                                             timeout:10
                                             success:^{
                            
                            NSLog(@"addFriendWithId success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
            
            
                    }else if (indexPath.row == 1){//删除好友，每次最多删除100人
                        
                        [self.client deleteFriendWithId:@[@(888)]
                                                timeout:10
                                                success:^{
                           
                            NSLog(@"deleteFriendWithId success");
                            
                        } fail:^(FPNError * _Nullable error) {
                             
                            NSLog(@"%@",error);
                            
                        }];
                                
                            
                    }else if (indexPath.row == 2){//获取好友
                        [self.client getUserFriendsWithTimeout:10
                                                       success:^(NSArray * _Nullable uidsArray) {
                            
                            NSLog(@"%@",uidsArray);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                                
                            
                    }else if (indexPath.row == 3){//添加黑名单
                        [self.client addBlacklistWithUserIds:@[[NSNumber numberWithLongLong:100]]
                                                     timeout:10
                                                     success:^{
                            
                            NSLog(@"addBlacklistWithUserIds success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                                
                    
                            
                    }else if (indexPath.row == 4){//解除黑名单
                        [self.client deleteBlacklistWithUserIds:@[[NSNumber numberWithLongLong:100]]
                                                     timeout:10
                                                        success:^{
                            
                            NSLog(@"deleteBlacklistWithUserIds success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                                
                    
                            
                    }else if (indexPath.row == 5){//拉取黑名单
                                
                        
                        [self.client getBlacklistWithTimeout:10
                                                     success:^(NSArray * _Nullable uidsArray) {
                            
                            NSLog(@"%@",uidsArray);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                    
                           
                    }
                    
                    
                        
                
            }else if (indexPath.section == 7){
                    #pragma mark 用户接口
                    if (indexPath.row == 0) {//客户端主动断开
            
            
                        [self.client offLineWithTimeout:10
                                                success:^{
                            
                            NSLog(@"offLineWithTimeout success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"offLineWithTimeout %@",error);
                            
                        }];
            
                    }else if (indexPath.row == 1){//踢掉一个链接（只对多用户登录有效，不能踢掉自己，可以用来实现同类设备，只容许一个登录）
                                
                        [self.client kickoutWithEndPoint:@"endpoint"
                                                 timeout:10
                                                 success:^{
                            
                            NSLog(@"kickoutWithEndPoint success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                          
                    }else if (indexPath.row == 2){//添加key_value形式的变量（例如设置客户端信息，会保存在当前链接中，客户端可以获取到）
                    
                        [self.client addAttrsWithAttrs:@{@"key1":@"value1"}
                                               timeout:10
                                               success:^{
                            
                            NSLog(@"addAttrsWithAttrs success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                            
                    
                    }else if (indexPath.row == 3){//获取attrs
                                
                    
                        [self.client getAttrsWithTimeout:10
                                                 success:^(RTMAttriAnswer * _Nullable attri) {
                            
                            NSLog(@"%@",attri.atttriDictionary);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                           
                    
                    }else if (indexPath.row == 4){//检测离线聊天  只有通过Chat类接口才会产生
                        
                        
                        [self.client getUnreadMessagesWithClear:NO
                                                        timeout:10
                                                        success:^(RTMP2pGroupMemberAnswer * _Nullable memberAnswer) {
                            
                            NSLog(@"%@  %@",memberAnswer.p2pArray,memberAnswer.groupArray);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                        
                                
                            
                    }else if (indexPath.row == 5){//清除离线聊天提醒
                        
                        [self.client cleanUnreadMessagesWithTimeout:10
                                                            success:^{
                            
                            NSLog(@"cleanUnreadMessagesWithTimeout success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                                
                            
                    }else if (indexPath.row == 6){//获取所有聊天的会话（p2p用户和自己也会产生会话 ，group）
                        
                        [self.client getAllSessionsWithTimeout:10
                                                       success:^(RTMP2pGroupMemberAnswer * _Nullable memberAnswer) {
                                                           
                            NSLog(@"%@  %@",memberAnswer.p2pArray,memberAnswer.groupArray);
                                                           
                                                      
                        } fail:^(FPNError * _Nullable error) {
                                                           
                            NSLog(@"%@",error);
                                                           
                                                      
                        }];
                                
                         
                    }else if (indexPath.row == 7){//获取在线用户列表，限制每次最多获取200个
                                
                        [self.client getOnlineUsers:@[[NSNumber numberWithLongLong:666]]
                                            timeout:10
                                            success:^(NSArray * _Nullable uidArray) {
                            
                            NSLog(@"%@",uidArray);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                        
                    }else if (indexPath.row == 8){//设置用户自己的公开信息或者私有信息
                            [self.client setUserInfoWithOpenInfo:@"open"
                                                      privteinfo:@"pri"
                                                         timeout:10
                                                         success:^{
                                
                                NSLog(@"setUserInfoWithOpenInfo success");
                                
                            } fail:^(FPNError * _Nullable error) {
                                
                                NSLog(@"%@",error);
                                
                            }];
                        
                    }else if (indexPath.row == 9){//获取用户自己的公开信息和私有信息
                                [self.client getUserInfoWithTimeout:10
                                                            success:^(RTMInfoAnswer * _Nullable info) {
                                    
                                    NSLog(@"%@",info.rtm_autoDescription);
                                    
                                } fail:^(FPNError * _Nullable error) {
                                    
                                    NSLog(@"%@",error);
                                    
                                }];
                            
                    }else if (indexPath.row == 10){//获取其他用户的公开信息，每次最多获取100人
                                [self.client getUserOpenInfo:@[@(666)]
                                                     timeout:10
                                                     success:^(RTMAttriAnswer * _Nullable info) {
                                    
                                    NSLog(@"%@",info.atttriDictionary);
                                    
                                } fail:^(FPNError * _Nullable error) {
                                    
                                    NSLog(@"%@",error);
                                    
                                }];
                            
                    }else if (indexPath.row == 11){//获取存储的数据信息
                                [self.client getUserValueInfoWithKey:@"kkk"
                                                             timeout:10
                                                             success:^(RTMInfoAnswer * _Nullable valueInfo) {
                                    
                                    NSLog(@"%@",valueInfo.rtm_autoDescription);
                                    
                                } fail:^(FPNError * _Nullable error) {
                                    
                                    NSLog(@"%@",error);
                                    
                                }];
                            
                    }else if (indexPath.row == 12){//设置存储的数据信息
                                [self.client setUserValueInfoWithKey:@"kkk"
                                                               value:@"vvvv"
                                                             timeout:10
                                                             success:^{
                                    
                                    NSLog(@"setUserValueInfoWithKey success");
                                    
                                } fail:^(FPNError * _Nullable error) {
                                    
                                     NSLog(@"%@",error);
                                    
                                }];
                            
                    }else if (indexPath.row == 13){//删除存储的数据信息
                                [self.client deleteUserDataWithKey:@"kkk"
                                                           timeout:10
                                                           success:^{
                                    NSLog(@"deleteUserDataWithKey success");
                                } fail:^(FPNError * _Nullable error) {
                                     NSLog(@"%@",error);
                                }];
                            }
                
                
                
 #pragma mark debug日志，设备相关操作接口
            }else if (indexPath.section == 8){
                    
                    if (indexPath.row == 0) {//添加debug日志
            
                        [self.client addDebugLogWithMsg:@"msg"
                                                  attrs:@"attrs"
                                                timeout:10
                                                success:^{
                            
                            NSLog(@"addDebugLogWithMsg success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
            
            
                   
                    }else if (indexPath.row == 1){//添加设备，应用信息
                    
                        [self.client addDeviceWithApptype:@"iphone11"
                                              deviceToken:@"token"
                                                  timeout:10
                                                  success:^{
                            
                            NSLog(@"addDeviceWithApptype success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                                
                    
                           
                    }else if (indexPath.row == 2){//删除设备，应用信息，解除绑定的意思
                    
                        
                        [self.client removeDeviceWithToken:@"token"
                                                   timeout:10
                                                   success:^{
                            
                            NSLog(@"removeDeviceWithToken success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                                
                    
                           
                    }
                    
#pragma mark chat单聊接口
            }else if (indexPath.section == 9){
                    
                    if (indexPath.row == 0) {//发送P2P消息 对 sendP2pMessageWithId 的封装 mtype=30
            
                        [self.client sendP2PMessageChatWithId:[NSNumber numberWithLongLong:777]
                                                      message:@"chat message"
                                                        attrs:@"attrs"
                                                      timeout:10
                                                      success:^(RTMSendAnswer * sendAnswer) {
                            
                            NSLog(@"%lld",sendAnswer.mtime);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                             NSLog(@"%@",error);
                            
                        }];
            
            
                    }else if (indexPath.row == 1){//发送音频消息 对 sendP2pMessageWithId 的封装 mtype=31
                    
                                
                        NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
                        NSTimeInterval durationTime = [RtmVoiceConverterManager audioDurationFromURL:wavPath];
                        NSString * amrPath = [RtmVoiceConverterManager voiceConvertWavToAmrFromFilePath:wavPath];
                        NSData * amrData = [NSData dataWithContentsOfFile:amrPath];
                        
                        
                        if (amrPath) {
                            
                            NSLog(@"%@ %f",self.recordAmrAudioPath,self.recordAmrAudioTime);
                            [self.client sendAudioMessageChatWithId:@(777)
                                                      audioFilePath:amrPath
                                                              attrs:@{}
                                                               lang:@"zh-cn"
                                                           duration:durationTime * 1000
                                                            timeout:20
                                                            success:^(RTMSendAnswer * sendAnswer) {
                                                                              
                                                    NSLog(@"%lld %lld",sendAnswer.mtime,sendAnswer.messageId);
                                                                              
                                } fail:^(FPNError * _Nullable error) {
                                                                                
                                                    NSLog(@"%@",error);
                                                                              
                                            
                            }];
                            
                                
                        }
                    
                    }else if (indexPath.row == 2){//发送系统命令 对 sendP2pMessageWithId 的封装 mtype=32
                    
                                
                        [self.client sendCmdMessageChatWithId:@(777)
                                                      message:@"cmd message"
                                                        attrs:@"attrs"
                                                      timeout:20
                                                      success:^(RTMSendAnswer * sendAnswer) {
                                  
                                    NSLog(@"%lld %lld",sendAnswer.mtime,sendAnswer.messageId);
                        
                                } fail:^(FPNError * _Nullable error) {
                               
                                    NSLog(@"%@",error);
                           
                                
                                }];
                        
                            
                    }else if (indexPath.row == 3){//获取历史P2P消息 对 getP2PHistoryMessageWithUserId 的封装 mtypes = [30,31,32]
                    
                                [self.client getP2PHistoryMessageChatWithUserId:[NSNumber numberWithLongLong:777]
                                                                           desc:YES
                                                                            num:[NSNumber numberWithLongLong:10]
                                                                          begin:nil
                                                                            end:nil
                                                                         lastid:nil
                                                                        timeout:10
                                                                        success:^(RTMHistory * _Nullable history) {
                                                                        
                                    NSLog(@"%@",history.messageArray.firstObject.rtm_autoDescription);
                                    
                                } fail:^(FPNError * _Nullable error) {
                                    
                                    NSLog(@"%@",error);
                                    
                                }];
                         
                    }
                    
                        
                
    
            }else if (indexPath.section == 10){
                    #pragma mark chat群组接口
                    if (indexPath.row == 0) {//发送Group消息 对 sendGroupMessageWithId 的封装 mtype=30
            
                        [self.client sendGroupMessageChatWithId:[NSNumber numberWithLongLong:666]
                                                        message:@"chat group message"
                                                          attrs:@"attrs"
                                                        timeout:10
                                                        success:^(RTMSendAnswer * sendAnswer) {
                            
                            NSLog(@"%lld",sendAnswer.mtime);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
            
            
            
                    }else if (indexPath.row == 1){//发送音频消息 对 sendGroupMessageWithId 的封装 mtype=31
                    
                    
                                NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
                                NSTimeInterval durationTime = [RtmVoiceConverterManager audioDurationFromURL:wavPath];
                                NSString * amrPath = [RtmVoiceConverterManager voiceConvertWavToAmrFromFilePath:wavPath];
                                NSData * amrData = [NSData dataWithContentsOfFile:amrPath];
                    
                        if (amrPath) {
                            NSLog(@"%@ %f",self.recordAmrAudioPath,self.recordAmrAudioTime);
                                    [self.client sendGroupAudioMessageChatWithId:[NSNumber numberWithInt:666]
                                                              audioFilePath:amrPath
                                                                      attrs:@{}
                                                                       lang:@"zh-cn"
                                                                   duration:durationTime * 1000
                                                                    timeout:20
                                                                         success:^(RTMSendAnswer * sendAnswer) {
                                        NSLog(@"%lld",sendAnswer.mtime);
                                    } fail:^(FPNError * _Nullable error) {
                                        NSLog(@"%@",error);
                                    }];
                    
                                }
                    
                            }else if (indexPath.row == 2){// 发送系统命令 对 sendGroupMessageWithId 的封装 mtype=32
                            
                            
                                        [self.client sendGroupCmdMessageChatWithId:[NSNumber numberWithLongLong:666]
                                                                           message:@"cmd message"
                                                                             attrs:@"attrs"
                                                                           timeout:10
                                                                           success:^(RTMSendAnswer * sendAnswer) {
                                            
                                            NSLog(@"%lld",sendAnswer.mtime);
                                            
                                        } fail:^(FPNError * _Nullable error) {
                                            
                                            NSLog(@"%@",error);
                                            
                                        }];
                            
                                   
                            } else if (indexPath.row == 3){// 获取历史group消息 对 getGroupMessageWithId 的封装 mtypes = [30,31,32]
                            
                            
                                        [self.client getGroupHistoryMessageChatWithGroupId:[NSNumber numberWithLongLong:666]
                                                                                      desc:YES
                                                                                       num:[NSNumber numberWithLongLong:10]
                                                                                     begin:nil
                                                                                       end:nil
                                                                                    lastid:nil
                                                                                   timeout:10
                                                                                    success:^(RTMHistory * _Nullable history) {
                                                                                   
                                            NSLog(@"%@",history.messageArray.firstObject.rtm_autoDescription);
                                            
                                        } fail:^(FPNError * _Nullable error) {
                                            
                                            NSLog(@"%@",error);
                                            
                                        }];
                                                                                      
                            
                                   
                            }
                            
#pragma mark chat房间接口
            }else if (indexPath.section == 11){
                    
                    if (indexPath.row == 0) {//发送Room消息 对 sendRoomMessageWithId 的封装 mtype=30
            
                        [self.client sendRoomMessageChatWithId:[NSNumber numberWithLongLong:666]
                                                        message:@"chat room message"
                                                          attrs:@"attrs"
                                                        timeout:10
                                                        success:^(RTMSendAnswer * sendAnswer) {
                            
                            NSLog(@"%lld",sendAnswer.mtime);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
            
            
                    
                    }else if (indexPath.row == 1){//发送音频消息 对 sendRoomMessageWithId 的封装 mtype=31
                    
                                NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
                                NSTimeInterval durationTime = [RtmVoiceConverterManager audioDurationFromURL:wavPath];
                                NSString * amrPath = [RtmVoiceConverterManager voiceConvertWavToAmrFromFilePath:wavPath];
                    
                                if (amrPath) {//调用demo
                                    NSLog(@"%@ %f",self.recordAmrAudioPath,self.recordAmrAudioTime);
                    
                                    [self.client sendRoomAudioMessageChatWithId:[NSNumber numberWithInt:666]
                                                                  audioFilePath:amrPath
                                                                          attrs:@{}
                                                                           lang:@"cn"
                                                                       duration:durationTime * 1000
                                                                        timeout:20
                                                                        success:^(RTMSendAnswer * sendAnswer) {
                                        NSLog(@"%lld",sendAnswer.mtime);
                                    } fail:^(FPNError * _Nullable error) {
                                        NSLog(@"%@",error);
                                    }];
                    
                                }
                           
                    }else if (indexPath.row == 2){//发送系统命令 对 sendRoomMessageWithId 的封装 mtype=32
                    
                                [self.client sendRoomCmdMessageChatWithId:[NSNumber numberWithLongLong:666]
                                                                  message:@"cmd message"
                                                                    attrs:@"attrs"
                                                                  timeout:10
                                                                  success:^(RTMSendAnswer * sendAnswer) {
                                                                  
                                    NSLog(@"%lld %lld",sendAnswer.mtime,sendAnswer.messageId);
                                                                 
                                } fail:^(FPNError * _Nullable error) {
                                                                    
                                    NSLog(@"%@",error);
                                                                 
                                }];
                    
                            }else if (indexPath.row == 3){//获取历史Room消息 对 getRoomMessageWithId 的封装 mtypes = [30,31,32]
                                        
                                [self.client getRoomHistoryMessageChatWithRoomId:[NSNumber numberWithLongLong:666]
                                                                             desc:YES
                                                                              num:[NSNumber numberWithLongLong:10]
                                                                            begin:nil
                                                                              end:nil
                                                                           lastid:nil
                                                                          timeout:10
                                                                            success:^(RTMHistory * _Nullable history) {
                                                                        
                                    NSLog(@"%@",history.messageArray.firstObject.rtm_autoDescription);
                                    
                                } fail:^(FPNError * _Nullable error) {
                                    
                                    NSLog(@"%@",error);
                                    
                                }];
                                
                            }
                            
                                
#pragma mark chat广播接口
            }else if (indexPath.section == 12){
                   
                    if (indexPath.row == 0) {//获取广播历史消息  对 getBroadCastHistoryMessageWithNum 的封装 mtypes = [30,31,32]
            
                        [self.client getBroadCastHistoryMessageChatWithNum:[NSNumber numberWithLongLong:10]
                                                                      desc:YES
                                                                     begin:nil
                                                                       end:nil
                                                                    lastid:nil
                                                                   timeout:10
                                                                   success:^(RTMHistory * _Nullable history) {
                                                                  
                            NSLog(@"%@",history.messageArray.firstObject.rtm_autoDescription);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
            
            
                    }
                
#pragma mark 翻译接口 语音识别 敏感词过滤
            }else if (indexPath.section == 13){
                    
                    if (indexPath.row == 0) {//@"设置当前用户需要的翻译语言(为空则取消翻译) 和 RTMClient里 lang属性 对应"
            
                        [self.client setLanguage:@"en"
                                         timeout:10
                                         success:^{
                            
                            NSLog(@"setLanguage success");
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                         
            
                    }else if (indexPath.row == 1){//@"翻译, 返回翻译后的字符串及 经过翻译系统检测的 语言类型（调用此接口需在管理系统启用翻译系统）",
                                
                        [self.client translateText:@"hello test"
                                  originalLanguage:@"en"
                                    targetLanguage:@"zh-CN"
                                              type:nil
                                         profanity:@"censor"
                                           timeout:30
                                           success:^(RTMTranslatedInfo * _Nullable translatedInfo) {
                            
                            NSLog(@"%@",translatedInfo.rtm_autoDescription);
                            
                        } fail:^(FPNError * _Nullable error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                    
                            
                    }else if (indexPath.row == 2){//@"敏感词过滤, 返回过滤后的字符串或者返回错误（调用此接口需在管理系统启用文本检测系统）",
                    
                                [self.client textProfanity:@"hello fuck"
                                                  classify:YES
                                                   timeout:10
                                                   success:^(RTMTextProfanityAnswer * _Nullable textProfanity) {
                                    
                                    NSLog(@"%@",textProfanity.rtm_autoDescription);
                                    
                                } fail:^(FPNError * _Nullable error) {
                                    
                                    NSLog(@"%@",error);
                                    
                                }];
                    
                           
                    }else if (indexPath.row == 3){//@"语音识别（调用此接口需在管理系统启用语音识别系统）调用这个接口的超时时间得加大到120s"
                    
                                NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"16 16 1 wav" ofType:@"wav"];
                                NSString * amrPath = [RtmVoiceConverterManager voiceConvertWavToAmrFromFilePath:wavPath];
                                
                                [self.client speechRecognition:amrPath
                                                          lang:@"zh-CN"
                                                      duration:2950
                                               profanityFilter:YES
                                                       timeout:120
                                                       success:^(RTMSpeechRecognitionAnswer * _Nullable textProfanity) {
                                
                                    NSLog(@"%@",textProfanity.rtm_autoDescription);
                                    
                                } fail:^(FPNError * _Nullable error) {
                                    
                                    NSLog(@"%@",error);
                                    
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
                
                
#pragma mark 录音方法
            }else if (indexPath.section == 15){
                if (indexPath.row == 0) {
                    //开始录音
                    self.recordManager = [[RTMRecordManager alloc] init];
                    [self.recordManager startRecord];
                    
                }else if (indexPath.row == 1){
                    //录音结束
                    [self.recordManager stopRecord:^(NSString * _Nullable amrAudioPath, NSString * _Nullable wavAudioPath,double durationTime) {
                        if (amrAudioPath && wavAudioPath && durationTime > 0) {
                            self.recordAmrAudioPath = amrAudioPath;
                            self.recordAmrAudioTime = durationTime;
                            self.recordWavAudioPath = wavAudioPath;
                            
                            
//                            [[RTMAudioplayer shareInstance] playWithAmrPath:amrAudioPath];
//                            [[RTMAudioplayer shareInstance] playWithWavPath:wavAudioPath];
//                            [[RTMAudioplayer shareInstance] stop];
                        }
                    }];
                }
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
                       @"获取消息 p2p",
                       @"语音识别"],
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
                       @"语音识别"
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
                       @"语音识别"
                       
            ]
        },
        @{
            @"typeName":@"广播接口",
            @"names":@[
                    @"获取广播历史消息",
                    @"语音识别"
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
                    @"添加黑名单",
                    @"解除黑名单",
                    @"拉取黑名单",
                       
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
            @"typeName":@"翻译接口 语音识别 敏感词过滤",
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
        @{
            @"typeName":@"录音",
            @"names":@[
                    
                    @"录音开始",
                    @"录音结束",
                      
                       
                       
                       
            ]
        },
        
        
    ];
    
    self.view = self.listView;

//点击一下  登录验证
    [self tableView:self.listView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self test];

}
-(void)test2{
    
    
//    self.client7 = [RTMClient clientWithEndpoint:@"52.82.27.68:13325"
//                                                        pid:90000014
//                                                        uid:18
//                                                      token:@"4297E324D29B7F0FB8B6CD55838CCAA0"];//server 获取
//    [self.client7 verifyConnectSuccess:^(NSDictionary * _Nullable data) {
//         NSLog(@"验证成功 verifyConnectSuccess  ");
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            int a = 0;
//            while (1) {
//                sleep(1.2);
//                a = a + 1;
//                [self.client7 sendGroupMessageChatWithId:@(13) message:[NSString stringWithFormat:@"client7  group message %d",a] attrs:@"" timeout:10];
//            }
//        });
//
//
//
//    } connectFali:nil];
    
    
}
-(void)test{
    
    self.client2 = [RTMClient clientWithEndpoint:@"161.189.171.91:13325"
                                      projectId:90000014
                                         userId:002
                                       delegate:self
                                         config:nil
                                    autoRelogin:YES];
    self.client3 = [RTMClient clientWithEndpoint:@"161.189.171.91:13325"
                                       projectId:90000014
                                          userId:003
                                        delegate:self
                                          config:nil
                                     autoRelogin:YES];
    self.client4 = [RTMClient clientWithEndpoint:@"161.189.171.91:13325"
                                       projectId:90000014
                                          userId:004
                                        delegate:self
                                          config:nil
                                     autoRelogin:YES];
    self.client5 = [RTMClient clientWithEndpoint:@"161.189.171.91:13325"
                                       projectId:90000014
                                          userId:005
                                        delegate:self
                                          config:nil
                                     autoRelogin:YES];
    self.client6 = [RTMClient clientWithEndpoint:@"161.189.171.91:13325"
                                       projectId:90000014
                                          userId:006
                                        delegate:self
                                          config:nil
                                     autoRelogin:YES];
    
    
    [self.client2 loginWithToken:@"6770DD93E43DBC2FC6628AA69338A208"
                        language:@"en"
                       attribute:nil
                         timeout:30
                         success:^{
        NSLog(@"client2 successsuccesssuccesssuccess");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
            int a = 0;
            while (a < 5000) {
                [NSThread sleepForTimeInterval:0];
                a = a + 1;
                NSLog(@"client2%d",a);
                [self.client2 sendP2PMessageChatWithId:@(666) message:@"client2 msg" attrs:@"" timeout:10];
            }
                
        });
        
    } connectFail:^(FPNError * _Nullable error) {
        
    }];
    
    
    [self.client3 loginWithToken:@"1AF84BAB1E0D1639E9683F24329D03EA"
                        language:@"en"
                       attribute:nil
                         timeout:30
                         success:^{
        NSLog(@"client3 successsuccesssuccesssuccess");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            int a = 0;
            while (a < 5000) {
                [NSThread sleepForTimeInterval:0];
                a = a + 1;
                NSLog(@"client3%d",a);
                [self.client3 sendP2PMessageChatWithId:@(666) message:@"client3 msg" attrs:@"" timeout:10];
            }

        });
    } connectFail:^(FPNError * _Nullable error) {
        NSLog(@"errorerrorerrorerrorerrorerror %@",error);
    }];

    [self.client4 loginWithToken:@"8EB8874C0274447DF5A8E40484D6D770"
                        language:@"en"
                       attribute:nil
                         timeout:30
                         success:^{
        NSLog(@"client4 successsuccesssuccesssuccess");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            int a = 0;
            while (a < 5000) {
                [NSThread sleepForTimeInterval:0];
                a = a + 1;
                NSLog(@"client4%d",a);
                [self.client4 sendP2PMessageChatWithId:@(666) message:@"client4 msg" attrs:@"" timeout:10];
            }

        });
    } connectFail:^(FPNError * _Nullable error) {

        NSLog(@"errorerrorerrorerrorerrorerror %@",error);

    }];

    [self.client5 loginWithToken:@"9380B8E8F72A4E85C552525AFE2F2F34"
                        language:@"en"
                       attribute:nil
                         timeout:30
                         success:^{
        NSLog(@"client5 successsuccesssuccesssuccess");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            int a = 0;
            while (a < 5000) {
                [NSThread sleepForTimeInterval:0];
                a = a + 1;
                NSLog(@"client5%d",a);
                [self.client5 sendP2PMessageChatWithId:@(666) message:@"client5 msg" attrs:@"" timeout:10];
            }

        });
    } connectFail:^(FPNError * _Nullable error) {

        NSLog(@"errorerrorerrorerrorerrorerror %@",error);

    }];

    [self.client6 loginWithToken:@"6634AC72245BFC3D42663604D5E9299A"
                        language:@"en"
                       attribute:nil
                         timeout:30
                         success:^{
        NSLog(@"client6 successsuccesssuccesssuccess");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            int a = 0;
            while (a < 5000) {
                [NSThread sleepForTimeInterval:0];
                a = a + 1;
                NSLog(@"client6%d",a);
                [self.client6 sendP2PMessageChatWithId:@(666) message:@"client6 msg" attrs:@"" timeout:10];
            }

        });

    } connectFail:^(FPNError * _Nullable error) {

        NSLog(@"errorerrorerrorerrorerrorerror %@",error);

    }];
    
    
                    
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
    lb.textColor = [UIColor redColor];
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
