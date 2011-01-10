//
//  TalentedAppDelegate.m
//  Talented
//
//  Created by Peter Shih on 11/25/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "TalentedAppDelegate.h"
#import "LauncherViewController.h"
#import "Constants.h"
#import "Appirater.h"

// Test stuff
#import "SMADataCenter.h"
#import "SMACoreDataStack.h"
#import "CJSONDeserializer.h"
#import "Talent.h"
#import "PrimarySpell.h"
#import "Mastery.h"
#import "TalentTree.h"
#import "CharacterClass.h"

@implementation TalentedAppDelegate

@synthesize window;
@synthesize launcherViewController = _launcherViewController;

- (void)loadTalentDataForLanguage {
  if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hasLoadedData_%@", USER_LANGUAGE]]) {
    [self talentDataTestForClass:@"warrior"];
    [self talentDataTestForClass:@"paladin"];
    [self talentDataTestForClass:@"hunter"];
    [self talentDataTestForClass:@"rogue"];
    [self talentDataTestForClass:@"priest"];
    [self talentDataTestForClass:@"deathknight"];
    [self talentDataTestForClass:@"shaman"];
    [self talentDataTestForClass:@"mage"];
    [self talentDataTestForClass:@"warlock"];
    [self talentDataTestForClass:@"druid"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"hasLoadedData_%@", USER_LANGUAGE]];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}


- (void)talentDataTestForClass:(NSString *)classString {
  // Localize datastore filename
  NSString *localizedFileName = [NSString stringWithFormat:@"%@_%@", classString, USER_LANGUAGE];
  
  // Check if json file exists, if not default to english
  NSString *filePath = [[NSBundle mainBundle] pathForResource:localizedFileName ofType:@"json"];  
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_en", classString] ofType:@"json"];
  }
    
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    DLog(@"testing core data insert");
    
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
      DLog(@"saving to core data");
    }
  }
  
  [[NSUserDefaults standardUserDefaults] setObject:USER_LANGUAGE forKey:@"lastSelectedLanguage"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  // Override point for customization after application launch.
  
  _launcherViewController = [[LauncherViewController alloc] initWithNibName:@"LauncherViewController" bundle:nil];
  
  if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSelectedLanguage"] isEqual:USER_LANGUAGE]) {
    [self loadTalentDataForLanguage];
  }
  
  [Appirater appLaunched:YES];
  
  [window addSubview:self.launcherViewController.view];
  [self.window makeKeyAndVisible];

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
  [Appirater appEnteredForeground:YES];
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
  [window release];
  [super dealloc];
}


@end
