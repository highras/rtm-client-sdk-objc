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
-(void)rtmKickout:(RTMClient *)client{
    NSLog(@"rtmKickoutrtmKickoutrtmKickout%@",client);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
                self.client = [RTMClient clientWithEndpoint:@"rtm-intl-frontgate.ilivedata.com:13325"
                                                  projectId:80000087
                                                     userId:666
                                                   delegate:self
                                                     config:nil
                                                autoRelogin:YES];
    
                if (self.client) {
                    [self.client loginWithToken:@"F17544A607708E28DAA607C6D2521613"
                                       language:@"en"
                                      attribute:@{@"aaa":@"bbb"}
                                        timeout:30
                                        success:^{
    
    
                        NSLog(@"login success  %@",[NSThread currentThread]);
    
    
    
    
                    } connectFail:^(FPNError * _Nullable error) {
    
                        NSLog(@"login error %@ %@",[NSThread currentThread],error);
                    }];
    
                }
    
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
