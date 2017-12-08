//
//  TestTests.m
//  TestTests
//
//  Created by Neha Salankar on 07/12/17.
//  Copyright © 2017 Neha Salankar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface TestTests : XCTestCase
@property ViewController *viewController;
@end

@implementation TestTests

- (void)setUp {
    [super setUp];
    self.viewController = [[ViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNavigationTitle {
    NSString *url = @"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json";
    NSString *expectedTitle = @"About Canada";
    [self.viewController getWebDataWithUrlString:url completionHandler:^(bool complete) {
        NSString *resultTitle = self.viewController.navBarTitle;
        XCTAssertEqualObjects(expectedTitle, resultTitle);
        
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
