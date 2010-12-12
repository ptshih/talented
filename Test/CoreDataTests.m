//
//  CoreDataTests.m
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "CoreDataTests.h"
#import "SMADataCenter.h"
#import "SMACoreDataStack.h"
#import "CJSONDeserializer.h"
#import "Talent.h"


@implementation CoreDataTests

- (void)setUp {

}

- (void)testTalentAbility {
  NSString *fileName = @"talentAbility.json";
  NSString *filePath = [[[NSBundle bundleForClass:[CoreDataTests class]] resourcePath] stringByAppendingFormat:@"/%@", fileName];
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSLog(@"testing core data insert");
    
    NSDictionary *testDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    [Talent addTalentWithDictionary:testDict forTalentTree:nil inContext:context];
    
    if (context.hasChanges) {
      if (![context save:nil]) {
        STAssertTrue(NO, @"The save failed when trying to set the categoryID of the two updates");
      }
      NSLog(@"saving to core data");
    }
  }
}

@end
