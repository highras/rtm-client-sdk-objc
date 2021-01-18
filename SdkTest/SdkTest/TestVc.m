//
//  ViewControlleraaa.m
//  SdkTest
//
//  Created by 张世良 on 2021/1/11.
//  Copyright © 2021 FunPlus. All rights reserved.
//

#import "TestVc.h"
#import <Rtm/Rtm.h>
@interface TestVc ()<RTMProtocol>
@property(nonatomic,strong)RTMClient * client;
@property(nonatomic,strong)RTMClient * client2;
@property(nonatomic,strong)RTMClient * client3;
@end

@implementation TestVc
-(void)rtmReloginCompleted:(RTMClient *)client reloginCount:(int)reloginCount reloginResult:(BOOL)reloginResult error:(FPNError *)error{
    NSLog(@"rtmReloginCompleted  uid = %lld reloginCount = %d reloginResult = %d   %@",client.userId,reloginCount,reloginResult,error);
}
-(BOOL)rtmReloginWillStart:(RTMClient *)client reloginCount:(int)reloginCount{

    NSLog(@"rtmReloginWillStart  reloginCount = %d  uid = %lld",reloginCount,client.userId);
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self.client closeConnect];
//    self.client = nil;
    self.client.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)rtmPushP2PChatMessage:(RTMClient *)client message:(RTMMessage *)message{
    NSLog(@"%@",message.translatedInfo.sourceText);
}
-(void)dealloc{
    NSLog(@"vvvcvcvcvc dealloc");
}
-(void)rtmKickout:(RTMClient *)client{
    NSLog(@"rtmKickoutrtmKickoutrtmKickout%@",client);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        for (int i = 0; i<999; i++) {
//            [NSThread sleepForTimeInterval:0.5];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"===== %d =====",i);
    
//                self.client = [RTMClient clientWithEndpoint:@"0"
//                                                  projectId:0
//                                                     userId:666
//                                                   delegate:self
//                                                     config:nil
//                                                autoRelogin:YES];
//
//                if (self.client) {
//                    [self.client loginWithToken:@"0"
//                                       language:@"en"
//                                      attribute:@{@"aaa":@"bbb"}
//                                        timeout:30
//                                        success:^{
//
//
//                        NSLog(@"login success  %@",[NSThread currentThread]);
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                            for (int i= 0; i<10000; i++) {
//                                [NSThread sleepForTimeInterval:0.05];
//                                [self.client sendP2PMessageChatWithId:@(777) message:@"66666" attrs:@"" timeout:10 success:^(RTMSendAnswer * _Nonnull sendAnswer) {
//                                    NSLog(@"  666发送成功  %d",i);
//                                } fail:^(FPNError * _Nullable error) {
//
//                                }];
//                            }
//
//                        });
//
//
//
//
//                    } connectFail:^(FPNError * _Nullable error) {
//
//                        NSLog(@"login error %@ %@",[NSThread currentThread],error);
//                    }];
//
//                }
//
//
//    self.client2 = [RTMClient clientWithEndpoint:@"0"
//                                      projectId:0
//                                         userId:777
//                                       delegate:self
//                                         config:nil
//                                    autoRelogin:YES];
//
//    if (self.client2) {
//        [self.client2 loginWithToken:@"0"
//                           language:@"en"
//                          attribute:@{@"aaa":@"bbb"}
//                            timeout:30
//                            success:^{
//
//
//            NSLog(@"login success  %@",[NSThread currentThread]);
//
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            for (int i= 0; i<10000; i++) {
//                [NSThread sleepForTimeInterval:0.05];
//                [self.client2 sendP2PMessageChatWithId:@(666) message:@"77777" attrs:@"" timeout:10 success:^(RTMSendAnswer * _Nonnull sendAnswer) {
//                    NSLog(@"  777发送成功  %d",i);
//                } fail:^(FPNError * _Nullable error) {
//
//                }];
//            }
//            });
//
//
//
//
//        } connectFail:^(FPNError * _Nullable error) {
//
//            NSLog(@"login error %@ %@",[NSThread currentThread],error);
//        }];
//
//    }
//
//
//    self.client3 = [RTMClient clientWithEndpoint:@"0"
//                                      projectId:0
//                                         userId:888
//                                       delegate:self
//                                         config:nil
//                                    autoRelogin:YES];
//
//    if (self.client3) {
//        [self.client3 loginWithToken:@"0"
//                           language:@"en"
//                          attribute:@{@"aaa":@"bbb"}
//                            timeout:30
//                            success:^{
//
//
//            NSLog(@"login success  %@",[NSThread currentThread]);
//
//            for (int i= 0; i<10000; i++) {
//                [NSThread sleepForTimeInterval:0.005];
//                [self.client3 sendP2PMessageChatWithId:@(666) message:@"888888" attrs:@"" timeout:10 success:^(RTMSendAnswer * _Nonnull sendAnswer) {
//                    NSLog(@"  发送成功  %d",i);
//                } fail:^(FPNError * _Nullable error) {
//
//                }];
//            }
//
//
//
//
//        } connectFail:^(FPNError * _Nullable error) {
//
//            NSLog(@"login error %@ %@",[NSThread currentThread],error);
//
//        }];
//
//    }

       
                
//            });
//        }
//    });
                
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
