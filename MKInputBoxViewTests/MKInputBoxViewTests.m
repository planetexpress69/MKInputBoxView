//
//  MKInputBoxViewTests.m
//  MKInputBoxViewTests
//
//  Created by Martin Kautz on 25.02.15.
//  Copyright (c) 2015 JAKOTA Design Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MKInputBoxView.h"

@interface MKInputBoxView (Test)
// a category to tell the test about some methods
// that aren't exposed to the public
- (void)submitButtonTapped;
- (void)textInputDidChange;
@end


@interface MKInputViewTests : XCTestCase
@end

@implementation MKInputViewTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
 - (void)testExample 
 {
 // This is an example of a functional test case.
 XCTAssert(YES, @"Pass");
 }
 */

- (void)testNumbersOfDecimal
{
    NSString *inputString       = @"12000";
    NSString *expectedString    = @"1.2000";
    int numberOfDecimalsToCheck = 4;

    // init box
    MKInputBoxView *testBox = [MKInputBoxView boxWithStyle:NumberInput];
    [testBox setNumberOfDecimals:numberOfDecimalsToCheck];

    // pre-fill textField
    testBox.customise = ^(UITextField *textField) {
        textField.text = inputString;
        return textField;
    };

    // hook callbacks (and test)
    testBox.onSubmit = ^(NSString *value1, NSString *value2) {
        NSLog(@"%@", value1);
        XCTAssert([value1 isEqualToString:expectedString], @"Pass");
    };

    // show the box
    [testBox show];

    // simulate input to get logic triggered
    [testBox textInputDidChange];

    // simulate touching submit button
    [testBox submitButtonTapped];
}


/*
 - (void)testPerformanceExample 
 {
 // This is an example of a performance test case.
 [self measureBlock:^{
 }];
 }
 */
@end