//
//  TalentPadAppDelegate.m
//  TalentPad
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TalentPadAppDelegate.h"
#import "LauncherViewController.h"

// Test stuff
#import "SMADataCenter.h"
#import "SMACoreDataStack.h"
#import "CJSONDeserializer.h"
#import "Talent.h"
#import "PrimarySpell.h"
#import "Mastery.h"
#import "TalentTree.h"
#import "CharacterClass.h"

@implementation TalentPadAppDelegate

@synthesize window;
@synthesize navigationController = _navigationController;
@synthesize launcherViewController = _launcherViewController;

- (void)doCoreDataTests {
//  [self talentDataTestForClass:@"warrior"];
//  [self talentDataTestForClass:@"paladin"];
//  [self talentAbilityTest];
//  [self primarySpellsTest];
//  [self masteriesTest];
//  [self talentTreesTest];
//  [self characterClassTest];
}

- (void)talentAbilityTest {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"talentAbility" ofType:@"json"];
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSLog(@"testing core data insert");
    
    NSDictionary *testDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    [Talent addTalentWithDictionary:testDict forTalentTree:nil inContext:context];
    
    if (context.hasChanges) {
      if (![context save:nil]) {
      }
      NSLog(@"saving to core data");
    }
  }
}

- (void)primarySpellsTest {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"primarySpells" ofType:@"json"];
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSLog(@"testing core data insert");
    
    NSArray *testArray = [[CJSONDeserializer deserializer] deserializeAsArray:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    for (NSDictionary *testDict in testArray) {
      [PrimarySpell addPrimarySpellWithDictionary:testDict forTalentTree:nil inContext:context];
    }
    
    if (context.hasChanges) {
      if (![context save:nil]) {
      }
      NSLog(@"saving to core data");
    }
  }
}

- (void)masteriesTest {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"masteries" ofType:@"json"];
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSLog(@"testing core data insert");
    
    NSArray *testArray = [[CJSONDeserializer deserializer] deserializeAsArray:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    for (NSDictionary *testDict in testArray) {
      [Mastery addMasteryWithDictionary:testDict forTalentTree:nil inContext:context];
    }
    
    if (context.hasChanges) {
      if (![context save:nil]) {
      }
      NSLog(@"saving to core data");
    }
  }
}

- (void)talentTreesTest {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"talentTrees" ofType:@"json"];
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSLog(@"testing core data insert");
    
    NSArray *testArray = [[CJSONDeserializer deserializer] deserializeAsArray:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    for (NSDictionary *testDict in testArray) {
      [TalentTree addTalentTreeWithDictionary:testDict forCharacterClass:nil inContext:context];
    }
    
    if (context.hasChanges) {
      if (![context save:nil]) {
      }
      NSLog(@"saving to core data");
    }
  }
}

- (void)characterClassTest {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"characterClass" ofType:@"json"];
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSLog(@"testing core data insert");
    
    NSDictionary *testDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:nil];
    
    // Test core data
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
    
    [CharacterClass addCharacterClassWithDictionary:testDict inContext:context];
    
    if (context.hasChanges) {
      if (![context save:nil]) {
      }
      NSLog(@"saving to core data");
    }
  }
}

- (void)talentDataTestForClass:(NSString *)classString {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:classString ofType:@"json"];
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSLog(@"testing core data insert");
    
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
      }
      NSLog(@"saving to core data");
    }
  }

}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  // Override point for customization after application launch.
  
  _launcherViewController = [[LauncherViewController alloc] initWithNibName:@"LauncherViewController" bundle:nil];
  _navigationController = [[UINavigationController alloc] initWithRootViewController:self.launcherViewController];
  self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
  self.navigationController.navigationBarHidden = NO;
  
  [window addSubview:self.navigationController.view];
  [self.window makeKeyAndVisible];
  
  [self doCoreDataTests];

  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
   */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  /*
   Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
   */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}


- (void)applicationWillTerminate:(UIApplication *)application {
  /*
   Called when the application is about to terminate.
   See also applicationDidEnterBackground:.
   */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
  /*
   Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
   */
}


- (void)dealloc {
  [_launcherViewController release];
  [_navigationController release];
  [window release];
  [super dealloc];
}


@end
