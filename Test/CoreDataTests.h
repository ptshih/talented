//
//  CoreDataTests.h
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#import "application_headers" as required


@interface CoreDataTests : SenTestCase {

}
- (void)testGlyphs;
- (void)testWarrior;
- (void)runTestCharacterClass:(NSString *)characterClass;

@end
