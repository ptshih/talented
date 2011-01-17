//
//  CoreDataTests.m
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "CoreDataTests.h"
#import "SMADataCenter.h"
#import "SMACoreDataStack.h"
#import "CJSONDeserializer.h"
#import "CharacterClass.h"
#import "TalentTree.h"
#import "Talent.h"
#import "PrimarySpell.h"
#import "Mastery.h"


@implementation CoreDataTests

- (void)setUp {

}

- (void)testGlyphs {
  NSString *fileName = @"glyphs.json";
  NSString *filePath = [[[NSBundle bundleForClass:[CoreDataTests class]] resourcePath] stringByAppendingFormat:@"/%@", fileName];
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSDictionary *testDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:nil];

    NSLog(@"Glyph Dict: %@", testDict);
    
//    // Test core data
//    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
//    [Talent addTalentWithDictionary:testDict forTalentTree:nil inContext:context];
//    
//    if (context.hasChanges) {
//      if (![context save:nil]) {
//        STAssertTrue(NO, @"Core Data Failed to Save in Context!");
//      }
//    }
  }
}

- (void)testWarrior {
  [self runTestCharacterClass:@"warrior"];
}

- (void)runTestCharacterClass:(NSString *)characterClass {
  NSString *fileName = [NSString stringWithFormat:@"%@.json", characterClass];
  NSString *filePath = [[[NSBundle bundleForClass:[CoreDataTests class]] resourcePath] stringByAppendingFormat:@"/%@", fileName];
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    NSDictionary *testDict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:nil] objectForKey:@"talentData"];
    
    // Parse characterClass
    NSDictionary *characterClassDict = [testDict objectForKey:@"characterClass"];
    CharacterClass *characterClass = [CharacterClass addCharacterClassWithDictionary:characterClassDict inContext:context];
    
    if (characterClass) {
      NSMutableSet *talentTreesSet = [NSMutableSet set];      
      
      // Parse talentTrees
      NSArray *talentTreesArray = [testDict objectForKey:@"talentTrees"];
      for (NSDictionary *talentTreeDict in talentTreesArray) {
        [talentTreesSet addObject:[TalentTree addTalentTreeWithDictionary:talentTreeDict forCharacterClass:characterClass inContext:context]];
      }
      
      // Set relationship for characterClass.talentTrees
      characterClass.talentTrees = talentTreesSet;
    }
    
    if (context.hasChanges) {
      if (![context save:nil]) {
        STAssertTrue(NO, @"Core Data Failed to Save in Context!");
      }
    }
  }
}


- (void)testTalent {
  NSString *fileName = @"talent.json";
  NSString *filePath = [[[NSBundle bundleForClass:[CoreDataTests class]] resourcePath] stringByAppendingFormat:@"/%@", fileName];
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSDictionary *testDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    [Talent addTalentWithDictionary:testDict forTalentTree:nil forIndex:0 inContext:context];
    
    if (context.hasChanges) {
      if (![context save:nil]) {
        STAssertTrue(NO, @"Core Data Failed to Save in Context!");
      }
    }
  }
}

- (void)testTalentAbility {
  NSString *fileName = @"talentAbility.json";
  NSString *filePath = [[[NSBundle bundleForClass:[CoreDataTests class]] resourcePath] stringByAppendingFormat:@"/%@", fileName];
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {

    NSDictionary *testDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    [Talent addTalentWithDictionary:testDict forTalentTree:nil forIndex:0 inContext:context];
    
    if (context.hasChanges) {
      if (![context save:nil]) {
        STAssertTrue(NO, @"Core Data Failed to Save in Context!");
      }
    }
  }
}

- (void)testPrimarySpell {
  NSString *fileName = @"primarySpells.json";
  NSString *filePath = [[[NSBundle bundleForClass:[CoreDataTests class]] resourcePath] stringByAppendingFormat:@"/%@", fileName];
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSArray *testArray = [[CJSONDeserializer deserializer] deserializeAsArray:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    for (NSDictionary *testDict in testArray) {
      [PrimarySpell addPrimarySpellWithDictionary:testDict forTalentTree:nil forIndex:0 inContext:context];
    }
    
    if (context.hasChanges) {
      if (![context save:nil]) {
        STAssertTrue(NO, @"Core Data Failed to Save in Context!");
      }
    }
  }
}

- (void)testMastery {
  NSString *fileName = @"masteries.json";
  NSString *filePath = [[[NSBundle bundleForClass:[CoreDataTests class]] resourcePath] stringByAppendingFormat:@"/%@", fileName];
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSArray *testArray = [[CJSONDeserializer deserializer] deserializeAsArray:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    for (NSDictionary *testDict in testArray) {
      [Mastery addMasteryWithDictionary:testDict forTalentTree:nil inContext:context];
    }
    
    if (context.hasChanges) {
      if (![context save:nil]) {
        STAssertTrue(NO, @"Core Data Failed to Save in Context!");
      }
    }
  }
}

- (void)testTalentTree {
  NSString *fileName = @"talentTrees.json";
  NSString *filePath = [[[NSBundle bundleForClass:[CoreDataTests class]] resourcePath] stringByAppendingFormat:@"/%@", fileName];
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSArray *testArray = [[CJSONDeserializer deserializer] deserializeAsArray:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    for (NSDictionary *testDict in testArray) {
      [TalentTree addTalentTreeWithDictionary:testDict forCharacterClass:nil inContext:context];
    }
    
    if (context.hasChanges) {
      if (![context save:nil]) {
        STAssertTrue(NO, @"Core Data Failed to Save in Context!");
      }
    }
  }
}

- (void)testCharacterClass {
  NSString *fileName = @"characterClass.json";
  NSString *filePath = [[[NSBundle bundleForClass:[CoreDataTests class]] resourcePath] stringByAppendingFormat:@"/%@", fileName];
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSDictionary *testDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    [CharacterClass addCharacterClassWithDictionary:testDict inContext:context];
    
    if (context.hasChanges) {
      if (![context save:nil]) {
        STAssertTrue(NO, @"Core Data Failed to Save in Context!");
      }
    }
  }
}

@end
