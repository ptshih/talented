//
//  WTCoreDataStack.m
//  WoWTalentPro
//
//  Created by Peter Shih on 11/24/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "WTCoreDataStack.h"

static NSPersistentStoreCoordinator *_persistentStoreCoordinator = nil;
static NSManagedObjectModel *_managedObjectModel = nil;
static NSManagedObjectContext *_managedObjectContext = nil;

@interface WTCoreDataStack (Private)

+ (void)initPersistentStore;

@end

@implementation WTCoreDataStack

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
  
  NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"wikinvest.sqlite"]];
  NSError *error = nil;
  
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
    // Handle the error.
  }  
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

@end
