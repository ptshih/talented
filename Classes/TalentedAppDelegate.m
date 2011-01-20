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
#import "Glyph.h"
#import "Save.h"
#import "Save+Fetch.h"

@implementation TalentedAppDelegate

@synthesize window;
@synthesize launcherViewController = _launcherViewController;

- (void)upgradeTalentData {
  // When version number is changed...
  // Migrate Save entities when allowed during an upgrade
  // Delete old persistent stores
}

- (void)loadTalentDataForLanguage:(NSString *)language {
  if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hasLoadedData_%@", language]]) {
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
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"hasLoadedData_%@", language]];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

- (void)talentDataTestForClass:(NSString *)classString {
  NSError *error;
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
      
      // Parse glyphs
      [self loadGlyphsForCharacterClass:characterClass];
    }
    
    if (context.hasChanges) {
      if (![context save:&error]) {
      }
      DLog(@"saving to core data");
    }
  }
  
  [[NSUserDefaults standardUserDefaults] setObject:USER_LANGUAGE forKey:@"lastSelectedLanguage"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadGlyphsForCharacterClass:(CharacterClass *)characterClass {
  // Check if json file exists, if not default to english
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"glyphs" ofType:@"json"];  
  
  NSData *myData = [NSData dataWithContentsOfFile:filePath];
  if (myData) {
    NSError *error;
    NSDictionary *testDict = [[CJSONDeserializer deserializer] deserializeAsDictionary:myData error:&error];
    NSString *glyphKeyPath = [self glyphKeyPathForCharacterClass:characterClass];
//    NSLog(@"Glyph Dict: %@", [testDict objectForKey:glyphKeyPath]);
    
    NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];

    for (NSDictionary *glyphDict in [[testDict objectForKey:glyphKeyPath] allValues]) {
      [Glyph addGlyphWithDictionary:glyphDict forCharacterClass:characterClass inContext:context];
    }
    
    if (context.hasChanges) {
      if (![context save:nil]) {
      }
    }
  }
}

- (NSString *)glyphKeyPathForCharacterClass:(CharacterClass *)characterClass {
  switch ([characterClass.characterClassId integerValue]) {
    case 1:
      return @"WARRIOR";
      break;
    case 2:
      return @"PALADIN";
      break;
    case 3:
      return @"HUNTER";
      break;
    case 4:
      return @"ROGUE";
      break;
    case 5:
      return @"PRIEST";
      break;
    case 6:
      return @"DEATHKNIGHT";
      break;
    case 7:
      return @"SHAMAN";
      break;
    case 8:
      return @"MAGE";
      break;
    case 9:
      return @"WARLOCK";
      break;
    case 11:
      return @"DRUID";
      break;
    default:
      return @"WARRIOR";
      break;
  }
}

#pragma mark Upgrade Code Path
- (void)migrateSaves {
  // Fetch all saves
  NSArray *oldSaves = [self fetchAllSavesAsDictionary];
  
  // Delete persistent store for all languages
  for (NSString *lang in LANGUAGES) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"hasLoadedData_%@", lang]];
  }
  [SMACoreDataStack deleteAllPersistentStores];

  // Reset current language's persistent store
  [SMACoreDataStack resetPersistentStore];
  // Reload Talent Data
  [self loadTalentDataForLanguage:USER_LANGUAGE];
  // Re-insert all saves
  [self insertAllSaves:oldSaves];
}

- (NSArray *)fetchAllSavesAsDictionary {
  NSError *error;
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Save" inManagedObjectContext:context];
  
  NSFetchRequest *request = [Save fetchRequestForAllSaves];
  [request setEntity:entity];
  
  NSArray *saves = [context executeFetchRequest:request error:&error];
  NSMutableArray *saveArray = [NSMutableArray array];
  for (Save *save in saves) {
    NSMutableDictionary *saveDict = [NSMutableDictionary dictionary];
    if (save.characterClassId) [saveDict setObject:save.characterClassId forKey:@"characterClassId"];
    if (save.saveName) [saveDict setObject:save.saveName forKey:@"saveName"];
    if (save.saveSpecTree) [saveDict setObject:save.saveSpecTree forKey:@"saveSpecTree"];
    if (save.saveString) [saveDict setObject:save.saveString forKey:@"saveString"];
    if (save.leftPoints) [saveDict setObject:save.leftPoints forKey:@"leftPoints"];
    if (save.middlePoints) [saveDict setObject:save.middlePoints forKey:@"middlePoints"];
    if (save.rightPoints) [saveDict setObject:save.rightPoints forKey:@"rightPoints"];
    if (save.timestamp) [saveDict setObject:save.timestamp forKey:@"timestamp"];
    if (save.glyphData) [saveDict setObject:save.glyphData forKey:@"glyphData"];
    [saveArray addObject:saveDict];
  }
  
  return saveArray;
}

- (void)insertAllSaves:(NSArray *)saves {
  NSError *error;
  NSManagedObjectContext *context = [SMACoreDataStack managedObjectContext];
  
  for (NSDictionary *saveDict in saves) {
    Save *newSave = [NSEntityDescription insertNewObjectForEntityForName:@"Save" inManagedObjectContext:context];
    newSave.characterClassId = [saveDict objectForKey:@"characterClassId"];
    newSave.saveName = [saveDict objectForKey:@"saveName"];
    newSave.saveSpecTree = [saveDict objectForKey:@"saveSpecTree"];
    newSave.saveString = [saveDict objectForKey:@"saveString"];
    newSave.leftPoints = [saveDict objectForKey:@"leftPoints"];
    newSave.middlePoints = [saveDict objectForKey:@"middlePoints"];
    newSave.rightPoints = [saveDict objectForKey:@"rightPoints"];
    newSave.timestamp = [saveDict objectForKey:@"timestamp"];
    if ([saveDict objectForKey:@"glyphData"]) newSave.glyphData = [saveDict objectForKey:@"glyphData"];
  }
  
  if (context.hasChanges) {
    if (![context save:&error]) {
    }
    DLog(@"saving to core data");
  }
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  // Detect Upgrade
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"]) {
    if (![[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"]]) {
      // Perform upgrade
      [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVersion"];
      [self migrateSaves];
    }
  } else {
    [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVersion"];
  }
  
#ifdef FORCE_MIGRATION
  [self migrateSaves];
#endif
  
  _launcherViewController = [[LauncherViewController alloc] initWithNibName:@"LauncherViewController" bundle:nil];
  
  if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSelectedLanguage"] isEqual:USER_LANGUAGE]) {
    [self loadTalentDataForLanguage:USER_LANGUAGE];
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
