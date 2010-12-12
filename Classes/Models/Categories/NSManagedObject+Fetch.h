//
//  NSManagedObject+Fetch.h
//  TalentPad
//
//  Created by Peter Shih on 12/12/10.
//  Copyright 2010 Seven Minute Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (Fetch)

#pragma mark Retreiving NSFetchRequests
/**
 Grabs the specified fetch request from the NSManagedObjectModel provided by calling LICoreDataStack:sharedManagedObjectModel.
 If no substitution variables are provided, that is substitutionVariables == nil, fetch request are retreived using:
 - (NSFetchRequest *)fetchRequestTemplateForName:(NSString *)name
 
 Otherwise the fetch request will be retreived by using:
 - (NSFetchRequest *)fetchRequestFromTemplateWithName:(NSString *)name substitutionVariables:(NSDictionary *)variables
 
 @param name The name of the fetch request to use, note if this is nil or not found nil is returned.
 @param substitutionVariables The variables and keys to substitute in the fetch request.
 */
+ (NSFetchRequest *)fetchRequestWithName:(NSString *)name andSubstitutionVariables:(NSDictionary *)substitutionVariables;

#pragma mark Querying the NSManagedObjectContext
/**
 Executes the provided fetch request against the provided managed object context, returning the results.  This is a convenience wrapper around
 - (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error, which logs the error and returns nil in the case one occurs.
 
 @param fetchRequest the fetch request to execute, returns nil if this parameter is nil.
 @param context The NSManagedObjectContext in which to execute the fetch request, if this is nil, nil is returned.
 */
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest inManagedObjectContext:(NSManagedObjectContext *)context;

@end
