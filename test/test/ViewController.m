//
//  ViewController.m
//  test
//
//  Created by dixun on 2019/2/22.
//  Copyright © 2019 funplus. All rights reserved.
//

#import "ViewController.h"
#import "TestCase.h"
#import "AsyncStressTester.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    // case 1
//    [self baseTest];
    
    // case 2
    [self asyncStressTest];
}

- (void) baseTest {
    
    NSString * filePatch = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"/assets/key/test-secp256k1-public.der"];
    NSFileHandle * fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePatch];
    
    NSData * fileData = [fileHandle readDataToEndOfFile];
    [[[TestCase alloc] initWithFile:fileData] beginTest];
}

- (void) asyncStressTest {
    
    NSString * endpoint = @"52.83.245.22:13013";
    
    NSInteger clientCount = 10;
    NSInteger totalQPS = 500;
    
    AsyncStressTest * asyncTest = [[AsyncStressTest alloc] initWithEndpoint:endpoint andCount:clientCount andQPS:totalQPS];
    [asyncTest launch];

    [asyncTest showStatistics];
}


@end
