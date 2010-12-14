//
//  SMACoreDataStack.m
//  TalentPad
//
//  Created by Peter Shih on 11/24/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "SMACoreDataStack.h"

static NSPersistentStoreCoordinator *_persistentStoreCoordinator = nil;
static NSManagedObjectModel *_managedObjectModel = nil;
static NSManagedObjectContext *_managedObjectContext = nil;

@interface SMACoreDataStack (Private)

+ (void)initPersistentStore;
+ (void)prepareDocumentsDirectory;

@end

@implementation SMACoreDataStack

+ (void)load {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  // Initialize persistent store at load time
  [self initPersistentStore];
  [pool drain];
}

#pragma mark Core Data
+ (void)initPersistentStore {
  if (_persistentStoreCoordinator) {
    [_persistentStoreCoordinator release];
    _persistentStoreCoordinator = nil;
  }
  
  [SMACoreDataStack prepareDocumentsDirectory];
  
  NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"talentpad.sqlite"]];
  NSError *error = nil;
  
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
    // Handle the error.
    NSLog(@"failed to create persistent store");
  }
  
  NSLog(@"init persistent store with path: %@", storeUrl);
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if(!_persistentStoreCoordinator) {
    [self initPersistentStore];
  }
  return _persistentStoreCoordinator;
}

+ (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  
  _managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]] retain];
  return _managedObjectModel;
}

+ (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return _managedObjectContext;
}

+ (NSString *)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)prepareDocumentsDirectory {
  BOOL isDir;
  [[NSFileManager defaultManager] fileExistsAtPath:[self applicationDocumentsDirectory]  isDirectory:&isDir];
  if (!isDir) {
    [[NSFileManager defaultManager] createDirectoryAtPath:[self applicationDocumentsDirectory] 
                              withIntermediateDirectories:YES attributes:nil error:nil];
  }
}

@end
