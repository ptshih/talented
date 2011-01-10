//
//  NSManagedObject+Fetch.m
//  Talented
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import "NSManagedObject+Fetch.h"
#import "SMACoreDataStack.h"

@implementation NSManagedObject (Fetch)

#pragma mark Retreiving NSFetchRequests
+ (NSFetchRequest *)fetchRequestWithName:(NSString *)name andSubstitutionVariables:(NSDictionary *)substitutionVariables {
  NSManagedObjectModel *sharedModel = [SMACoreDataStack managedObjectModel];
  if (!sharedModel) {
    //LIDERROR(@"Error retreiving managed object model from magic model factory");
    return nil;
  }
  
  NSFetchRequest *request = (substitutionVariables) ? [sharedModel fetchRequestFromTemplateWithName:name substitutionVariables:substitutionVariables] 
  : [sharedModel fetchRequestTemplateForName:name];
  
  return request;
}

#pragma mark Querying the NSManagedObjectContext
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)context {
  if (!fetchRequest || !context) {
    //err why did you call this method?
    return nil;
  }
  NSError *error = nil;
  NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
  if (error) {
    //LIDERROR(@"Error executing fetch: %@", fetchRequest);
    return nil;
  }
  
  return result;
}

@end
