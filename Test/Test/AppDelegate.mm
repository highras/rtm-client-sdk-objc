//
//  AppDelegate.m
//  Test
//
//  Created by zsl on 2019/11/27.
//  Copyright © 2019 FunPlus. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Rtm/Rtm.h>
#import "MainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
void uncaughtExceptionHandler(NSException*exception){

    NSLog(@"CRASH: %@", exception);

    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);

    // Internal error reporting

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init] ];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
     NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    //[[RTMClientManger shareInstance] applicationDidEnterBackground:application];
}




@end
